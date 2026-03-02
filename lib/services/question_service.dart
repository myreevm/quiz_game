import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/app_settings.dart';
import '../models/question.dart';

class QuestionService {
  static const _dataRoot = 'assets/data';
  static const _knownLanguageDirectories = <String>{
    'en',
    'english',
    'ru',
    'russian',
    'sah',
    'sa',
    'yakut',
    'sakha',
    'saha',
  };

  static List<String>? _cachedJsonAssets;

  static Future<List<Question>> loadQuestions({
    required String country,
    String? region,
    required String category,
    AppLanguage language = AppLanguage.russian,
  }) async {
    final normalizedCountry = _normalizeSegment(country);
    final normalizedRegion = _normalizeOptionalSegment(region);
    final normalizedCategory = _normalizeSegment(category);
    final languageDirectory = _languageDirectoryFor(language);

    if (normalizedCountry.isEmpty || normalizedCategory.isEmpty) {
      return [];
    }

    if (normalizedRegion != null) {
      final fromRegionNew = await _loadQuestionsFromPath(
        _regionLanguageCategoryPath(
          country: normalizedCountry,
          region: normalizedRegion,
          languageDirectory: languageDirectory,
          category: normalizedCategory,
        ),
        language: language,
        isLanguageScopedPath: true,
      );

      if (fromRegionNew.isNotEmpty) {
        return fromRegionNew;
      }

      final fromRegionLegacy = await _loadQuestionsFromPath(
        _regionLegacyCategoryPath(
          country: normalizedCountry,
          region: normalizedRegion,
          category: normalizedCategory,
        ),
        language: language,
        isLanguageScopedPath: false,
      );

      if (fromRegionLegacy.isNotEmpty) {
        return fromRegionLegacy;
      }
    }

    final fromCountryNew = await _loadQuestionsFromPath(
      _countryLanguageCategoryPath(
        country: normalizedCountry,
        languageDirectory: languageDirectory,
        category: normalizedCategory,
      ),
      language: language,
      isLanguageScopedPath: true,
    );
    if (fromCountryNew.isNotEmpty) {
      return fromCountryNew;
    }

    final fromCountryLegacy = await _loadQuestionsFromPath(
      _countryLegacyCategoryPath(
        country: normalizedCountry,
        category: normalizedCategory,
      ),
      language: language,
      isLanguageScopedPath: false,
    );
    List<Question>? deferredCountryLegacyFallback;
    if (fromCountryLegacy.isNotEmpty && language == AppLanguage.russian) {
      return fromCountryLegacy;
    }
    if (fromCountryLegacy.isNotEmpty) {
      deferredCountryLegacyFallback = fromCountryLegacy;
    }

    if (normalizedRegion != null) {
      return deferredCountryLegacyFallback ?? const [];
    }

    final regionalSources = await _findRegionalCategorySources(
      country: normalizedCountry,
      category: normalizedCategory,
      languageDirectory: languageDirectory,
    );
    if (regionalSources.isEmpty) {
      return deferredCountryLegacyFallback ?? const [];
    }

    final collected = <Question>[];
    for (final source in regionalSources) {
      final fromRegionPath = await _loadQuestionsFromPath(
        source.path,
        language: language,
        isLanguageScopedPath: source.isLanguageScopedPath,
      );
      if (fromRegionPath.isNotEmpty) {
        collected.addAll(fromRegionPath);
      }
    }

    if (collected.isNotEmpty) {
      return _deduplicateQuestions(collected);
    }

    return deferredCountryLegacyFallback ?? const [];
  }

  static Future<List<Question>> _loadQuestionsFromPath(
    String path, {
    required AppLanguage language,
    required bool isLanguageScopedPath,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return _parseQuestions(
        jsonString,
        path,
        language,
        isLanguageScopedPath: isLanguageScopedPath,
      );
    } catch (_) {
      return const [];
    }
  }

  static List<Question> _parseQuestions(
      String jsonString, String path, AppLanguage language,
      {required bool isLanguageScopedPath}) {
    final dynamic decoded;
    try {
      decoded = json.decode(jsonString);
    } catch (error) {
      debugPrint('Failed to decode JSON for "$path": $error');
      return const [];
    }

    if (decoded is! List) {
      debugPrint('Unexpected JSON format in "$path": root is not a list.');
      return const [];
    }

    final questions = <Question>[];
    for (final item in decoded) {
      final map = _asStringDynamicMap(item);
      if (map == null) {
        continue;
      }

      final questionText = _readLocalizedText(
        map['question'],
        language,
        isLanguageScopedPath: isLanguageScopedPath,
      );
      final imageAsset =
          _readText(map['imageAsset']) ?? _readText(map['image']);
      final answersData = map['answers'];
      if (questionText == null || answersData is! List) {
        continue;
      }

      final answers = <Answer>[];
      for (final rawAnswer in answersData) {
        final answerMap = _asStringDynamicMap(rawAnswer);
        if (answerMap == null) {
          continue;
        }

        final answerText = _readLocalizedText(
          answerMap['text'],
          language,
          isLanguageScopedPath: isLanguageScopedPath,
        );
        final score = _parseScore(answerMap['score']);
        if (answerText == null || score == null) {
          continue;
        }

        answers.add(Answer(text: answerText, score: score));
      }

      if (answers.isEmpty) {
        continue;
      }

      questions.add(
        Question(
          questionText: questionText,
          imageAsset: imageAsset,
          answers: answers,
        ),
      );
    }

    return questions;
  }

  static Future<List<_RegionalCategorySource>> _findRegionalCategorySources({
    required String country,
    required String category,
    required String languageDirectory,
  }) async {
    final allJsonAssets = await _loadAllJsonAssetPaths();
    final prefix = '$_dataRoot/$country/';
    final fileName = '$category.json';
    final byRegion = <String, _RegionalCategorySource>{};

    for (final path in allJsonAssets) {
      if (!path.startsWith(prefix) || !path.endsWith('/$fileName')) {
        continue;
      }

      final relativePath = path.substring(prefix.length);
      final segments = relativePath.split('/');

      if (segments.length == 3) {
        final region = segments[0];
        final langDir = segments[1];
        final filename = segments[2];

        if (filename != fileName ||
            langDir != languageDirectory ||
            _isLanguageDirectory(region)) {
          continue;
        }

        byRegion[region] = _RegionalCategorySource(
          path: path,
          isLanguageScopedPath: true,
        );
        continue;
      }

      if (segments.length == 2) {
        final region = segments[0];
        final filename = segments[1];

        if (filename != fileName || _isLanguageDirectory(region)) {
          continue;
        }

        byRegion.putIfAbsent(
          region,
          () => _RegionalCategorySource(
            path: path,
            isLanguageScopedPath: false,
          ),
        );
      }
    }

    final regions = byRegion.keys.toList()..sort();
    return regions.map((region) => byRegion[region]!).toList();
  }

  static Future<List<String>> _loadAllJsonAssetPaths() async {
    final cached = _cachedJsonAssets;
    if (cached != null) {
      return cached;
    }

    try {
      final manifestString = await rootBundle.loadString('AssetManifest.json');
      final manifestJson = json.decode(manifestString);
      if (manifestJson is! Map) {
        _cachedJsonAssets = const [];
        return _cachedJsonAssets!;
      }

      final keys = manifestJson.keys
          .whereType<String>()
          .where((path) =>
              path.startsWith('$_dataRoot/') && path.endsWith('.json'))
          .toList()
        ..sort();

      _cachedJsonAssets = keys;
      return keys;
    } catch (error) {
      debugPrint('Failed to read AssetManifest.json: $error');
      _cachedJsonAssets = const [];
      return _cachedJsonAssets!;
    }
  }

  static List<Question> _deduplicateQuestions(Iterable<Question> questions) {
    final unique = <String>{};
    final result = <Question>[];

    for (final question in questions) {
      final key = question.questionText.trim().toLowerCase();
      if (key.isEmpty || !unique.add(key)) {
        continue;
      }
      result.add(question);
    }

    return result;
  }

  static String _countryLanguageCategoryPath({
    required String country,
    required String languageDirectory,
    required String category,
  }) {
    return '$_dataRoot/$country/$languageDirectory/$category.json';
  }

  static String _regionLanguageCategoryPath({
    required String country,
    required String region,
    required String languageDirectory,
    required String category,
  }) {
    return '$_dataRoot/$country/$region/$languageDirectory/$category.json';
  }

  static String _countryLegacyCategoryPath({
    required String country,
    required String category,
  }) {
    return '$_dataRoot/$country/$category.json';
  }

  static String _regionLegacyCategoryPath({
    required String country,
    required String region,
    required String category,
  }) {
    return '$_dataRoot/$country/$region/$category.json';
  }

  static String _normalizeSegment(String value) {
    return value.trim().toLowerCase();
  }

  static String? _normalizeOptionalSegment(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = _normalizeSegment(value);
    return normalized.isEmpty ? null : normalized;
  }

  static Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, mapValue) => MapEntry(key.toString(), mapValue),
      );
    }

    return null;
  }

  static String? _readText(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static String? _readLocalizedText(
    dynamic value,
    AppLanguage language, {
    required bool isLanguageScopedPath,
  }) {
    if (value is! Map) {
      return _readText(value);
    }

    final map = value.map(
      (key, entryValue) =>
          MapEntry(key.toString().trim().toLowerCase(), entryValue),
    );

    final aliases = <String>[
      ..._languageAliases(language),
      if (language != AppLanguage.russian || !isLanguageScopedPath)
        ..._languageAliases(AppLanguage.russian),
    ];

    final seenAliases = <String>{};
    for (final alias in aliases) {
      if (!seenAliases.add(alias)) {
        continue;
      }

      final text = _readText(map[alias]);
      if (text != null) {
        return text;
      }
    }

    return null;
  }

  static List<String> _languageAliases(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const <String>['en', 'english'];
      case AppLanguage.russian:
        return const <String>['ru', 'russian'];
      case AppLanguage.yakut:
        return const <String>['yakut', 'sah', 'saha', 'sakha'];
    }
  }

  static String _languageDirectoryFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.russian:
        return 'ru';
      case AppLanguage.yakut:
        return 'sah';
    }
  }

  static bool _isLanguageDirectory(String segment) {
    return _knownLanguageDirectories.contains(segment);
  }

  static int? _parseScore(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is bool) {
      return value ? 1 : 0;
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }
}

class _RegionalCategorySource {
  final String path;
  final bool isLanguageScopedPath;

  const _RegionalCategorySource({
    required this.path,
    required this.isLanguageScopedPath,
  });
}
