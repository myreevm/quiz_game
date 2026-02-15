import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/app_settings.dart';
import '../models/question.dart';

class QuestionService {
  static const _dataRoot = 'assets/data';

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

    if (normalizedCountry.isEmpty || normalizedCategory.isEmpty) {
      return [];
    }

    if (normalizedRegion != null) {
      final fromRegion = await _loadQuestionsFromPath(
        _regionCategoryPath(
          country: normalizedCountry,
          region: normalizedRegion,
          category: normalizedCategory,
        ),
        language: language,
      );

      if (fromRegion.isNotEmpty) {
        return fromRegion;
      }
    }

    final countryPath = _countryCategoryPath(
      country: normalizedCountry,
      category: normalizedCategory,
    );
    final fromCountry = await _loadQuestionsFromPath(
      countryPath,
      language: language,
    );
    if (fromCountry.isNotEmpty) {
      return fromCountry;
    }

    final regionalPaths = await _findRegionalCategoryPaths(
      country: normalizedCountry,
      category: normalizedCategory,
    );
    if (regionalPaths.isEmpty) {
      return [];
    }

    final collected = <Question>[];
    for (final path in regionalPaths) {
      final fromRegionPath = await _loadQuestionsFromPath(
        path,
        language: language,
      );
      if (fromRegionPath.isNotEmpty) {
        collected.addAll(fromRegionPath);
      }
    }

    return _deduplicateQuestions(collected);
  }

  static Future<List<Question>> _loadQuestionsFromPath(
    String path, {
    required AppLanguage language,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return _parseQuestions(jsonString, path, language);
    } catch (_) {
      return const [];
    }
  }

  static List<Question> _parseQuestions(
    String jsonString,
    String path,
    AppLanguage language,
  ) {
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

      final questionText = _readLocalizedText(map['question'], language);
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

        final answerText = _readLocalizedText(answerMap['text'], language);
        final score = _parseScore(answerMap['score']);
        if (answerText == null || score == null) {
          continue;
        }

        answers.add(Answer(text: answerText, score: score));
      }

      if (answers.isEmpty) {
        continue;
      }

      questions.add(Question(questionText: questionText, answers: answers));
    }

    return questions;
  }

  static Future<List<String>> _findRegionalCategoryPaths({
    required String country,
    required String category,
  }) async {
    final allJsonAssets = await _loadAllJsonAssetPaths();
    final prefix = '$_dataRoot/$country/';
    final suffix = '/$category.json';

    final paths = allJsonAssets.where((path) {
      if (!path.startsWith(prefix) || !path.endsWith(suffix)) {
        return false;
      }

      final relativePath = path.substring(prefix.length);
      final firstSlash = relativePath.indexOf('/');
      if (firstSlash <= 0) {
        return false;
      }

      return relativePath.indexOf('/', firstSlash + 1) == -1;
    }).toList()
      ..sort();

    return paths;
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

  static String _countryCategoryPath({
    required String country,
    required String category,
  }) {
    return '$_dataRoot/$country/$category.json';
  }

  static String _regionCategoryPath({
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

  static String? _readLocalizedText(dynamic value, AppLanguage language) {
    if (value is! Map) {
      return _readText(value);
    }

    final map = value.map(
      (key, entryValue) =>
          MapEntry(key.toString().trim().toLowerCase(), entryValue),
    );

    final orderedAliases = <String>[
      ..._languageAliases(language),
      ..._languageAliases(AppLanguage.russian),
      ..._languageAliases(AppLanguage.english),
      ..._languageAliases(AppLanguage.yakut),
    ];

    for (final alias in orderedAliases) {
      final text = _readText(map[alias]);
      if (text != null) {
        return text;
      }
    }

    for (final fallback in map.values) {
      final text = _readText(fallback);
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
        return const <String>['yakut', 'sakha', 'saha'];
    }
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
