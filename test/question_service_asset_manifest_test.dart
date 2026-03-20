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

      const regions = <String>['oklahoma', 'texas'];
      const languages = <String>['en', 'ru', 'sah'];
      const categories = <String>[
        'famous_people',
        'history',
        'movies',
        'music',
      ];

      for (final region in regions) {
        for (final language in languages) {
          for (final category in categories) {
            final path = 'assets/data/usa/$region/$language/$category.json';
            expect(manifestContent.contains(path), isTrue);
          }
        }
      }
    });

    test(
        'AssetManifest includes Algeria, Argentina, Armenia, Australia, Austria, Azerbaijan, Belarus, Brazil, Bulgaria, Canada, China, Croatia, Czechia, Egypt, Finland, France, Georgia, Germany, Greece, Hungary, India, Iceland, Indonesia, Italy, Japan, Kazakhstan, Kyrgyzstan, Laos, Libya, Malaysia, Mexico, Mongolia, Morocco, Myanmar, New Zealand, Norway, Papua New Guinea, Poland, Portugal, Romania, Russia, Serbia, Singapore, Slovakia, Slovenia, South Africa, South Korea, Spain, Sweden, Switzerland, Tajikistan, Thailand, Tunisia, Turkey, UK, USA, Uzbekistan, and Vietnam language files',
        () async {
      final manifestBin = File('build/unit_test_assets/AssetManifest.bin');
      expect(manifestBin.existsSync(), isTrue);

      final manifestContent = const Utf8Decoder(allowMalformed: true).convert(
        await manifestBin.readAsBytes(),
      );

      const countries = <String>[
        'algeria',
        'argentina',
        'armenia',
        'australia',
        'austria',
        'azerbaijan',
        'belarus',
        'brazil',
        'bulgaria',
        'canada',
        'china',
        'croatia',
        'czechia',
        'egypt',
        'finland',
        'france',
        'georgia',
        'germany',
        'greece',
        'hungary',
        'india',
        'iceland',
        'indonesia',
        'italy',
        'japan',
        'kazakhstan',
        'kyrgyzstan',
        'laos',
        'libya',
        'malaysia',
        'mexico',
        'mongolia',
        'morocco',
        'myanmar',
        'new_zealand',
        'norway',
        'papua_new_guinea',
        'poland',
        'portugal',
        'romania',
        'russia',
        'serbia',
        'singapore',
        'slovakia',
        'slovenia',
        'south_africa',
        'south_korea',
        'spain',
        'sweden',
        'switzerland',
        'tajikistan',
        'thailand',
        'tunisia',
        'turkey',
        'uk',
        'usa',
        'uzbekistan',
        'vietnam',
      ];
      const languages = <String>['en', 'ru', 'sah'];
      const categories = <String>[
        'famous_people',
        'history',
        'movies',
        'music',
      ];

      for (final country in countries) {
        for (final language in languages) {
          for (final category in categories) {
            final path = 'assets/data/$country/$language/$category.json';
            expect(manifestContent.contains(path), isTrue);
          }
        }
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

    test('loads USA regions for English, Russian, and Yakut languages',
        () async {
      for (final region in const <String>['oklahoma', 'texas']) {
        for (final category in const <String>[
          'famous_people',
          'history',
          'movies',
          'music',
        ]) {
          final englishQuestions = await QuestionService.loadQuestions(
            country: 'usa',
            region: region,
            category: category,
            language: AppLanguage.english,
          );
          final russianQuestions = await QuestionService.loadQuestions(
            country: 'usa',
            region: region,
            category: category,
            language: AppLanguage.russian,
          );
          final yakutQuestions = await QuestionService.loadQuestions(
            country: 'usa',
            region: region,
            category: category,
            language: AppLanguage.yakut,
          );

          expect(englishQuestions, isNotEmpty);
          expect(russianQuestions, isNotEmpty);
          expect(yakutQuestions, isNotEmpty);
          expect(russianQuestions.first.questionText,
              isNot(englishQuestions.first.questionText));
          expect(yakutQuestions.first.questionText,
              isNot(englishQuestions.first.questionText));
        }
      }
    });

    test(
        'loads Algeria, Argentina, Armenia, Australia, Austria, Azerbaijan, Belarus, Brazil, Bulgaria, Canada, China, Croatia, Czechia, Egypt, Finland, France, Georgia, Germany, Greece, Hungary, India, Iceland, Indonesia, Italy, Japan, Kazakhstan, Kyrgyzstan, Laos, Libya, Malaysia, Mexico, Mongolia, Morocco, Myanmar, New Zealand, Norway, Papua New Guinea, Poland, Portugal, Romania, Russia, Serbia, Singapore, Slovakia, Slovenia, South Africa, South Korea, Spain, Sweden, Switzerland, Tajikistan, Thailand, Tunisia, Turkey, UK, USA, Uzbekistan, and Vietnam categories for all app languages',
        () async {
      for (final country in const <String>[
        'algeria',
        'argentina',
        'armenia',
        'australia',
        'austria',
        'azerbaijan',
        'belarus',
        'brazil',
        'bulgaria',
        'canada',
        'china',
        'croatia',
        'czechia',
        'egypt',
        'finland',
        'france',
        'georgia',
        'germany',
        'greece',
        'hungary',
        'india',
        'iceland',
        'indonesia',
        'italy',
        'japan',
        'kazakhstan',
        'kyrgyzstan',
        'laos',
        'libya',
        'malaysia',
        'mexico',
        'mongolia',
        'morocco',
        'myanmar',
        'new_zealand',
        'norway',
        'papua_new_guinea',
        'poland',
        'portugal',
        'romania',
        'russia',
        'serbia',
        'singapore',
        'slovakia',
        'slovenia',
        'south_africa',
        'south_korea',
        'spain',
        'sweden',
        'switzerland',
        'tajikistan',
        'thailand',
        'tunisia',
        'turkey',
        'uk',
        'usa',
        'uzbekistan',
        'vietnam',
      ]) {
        for (final category in const <String>[
          'famous_people',
          'history',
          'movies',
          'music',
        ]) {
          final englishQuestions = await QuestionService.loadQuestions(
            country: country,
            category: category,
            language: AppLanguage.english,
          );
          final russianQuestions = await QuestionService.loadQuestions(
            country: country,
            category: category,
            language: AppLanguage.russian,
          );
          final yakutQuestions = await QuestionService.loadQuestions(
            country: country,
            category: category,
            language: AppLanguage.yakut,
          );

          expect(englishQuestions, isNotEmpty);
          expect(russianQuestions, isNotEmpty);
          expect(yakutQuestions, isNotEmpty);
          expect(russianQuestions.first.questionText,
              isNot(englishQuestions.first.questionText));
          expect(yakutQuestions.first.questionText,
              isNot(englishQuestions.first.questionText));
        }
      }
    });
  });
}
