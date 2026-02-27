import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/services/question_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuestionService real asset coverage', () {
    test('AssetManifest includes regional language files', () async {
      final manifestBin = File('build/unit_test_assets/AssetManifest.bin');
      expect(manifestBin.existsSync(), isTrue);

      final manifestContent = const Utf8Decoder(allowMalformed: true).convert(
        await manifestBin.readAsBytes(),
      );
      const expectedPaths = <String>[
        'assets/data/russia/yakutia/en/history.json',
        'assets/data/russia/yakutia/ru/history.json',
        'assets/data/russia/yakutia/sah/history.json',
        'assets/data/russia/dagestan/en/history.json',
        'assets/data/russia/dagestan/ru/history.json',
        'assets/data/russia/dagestan/sah/history.json',
      ];

      for (final path in expectedPaths) {
        expect(manifestContent.contains(path), isTrue);
      }
    });

    test('loads Yakutia history for English and Yakut languages', () async {
      final englishQuestions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'history',
        language: AppLanguage.english,
      );
      final yakutQuestions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'history',
        language: AppLanguage.yakut,
      );
      final russianQuestions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'history',
        language: AppLanguage.russian,
      );

      expect(englishQuestions, isNotEmpty);
      expect(yakutQuestions, isNotEmpty);
      expect(russianQuestions, isNotEmpty);
      expect(
        englishQuestions.first.questionText,
        'What is the name of the capital of the Republic of Sakha (Yakutia)?',
      );
      expect(
        yakutQuestions.first.answers.first.text,
        isNot(russianQuestions.first.answers.first.text),
      );
    });
  });
}
