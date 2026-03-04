import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/services/question_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assets = _buildMockAssets();

  setUpAll(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        if (message == null) {
          return null;
        }

        final key = utf8.decode(message.buffer.asUint8List());
        final content = assets[key];
        if (content == null) {
          return null;
        }

        final bytes = Uint8List.fromList(utf8.encode(content));
        return ByteData.view(bytes.buffer);
      },
    );
  });

  tearDownAll(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler('flutter/assets', null);
  });

  group('QuestionService language path resolution', () {
    test('loads region questions from new format for English', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(questions.first.questionText,
          'Who is the most famous Dagestani poet?');
    });

    test('loads region questions from new sah folder for Yakut language',
        () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.yakut,
      );

      expect(questions, isNotEmpty);
      expect(questions.first.questionText,
          'РЎР°С…Р° С‚С‹Р»С‹РЅР°РЅ СЃСѓРѕР»С‚Р°Р»Р°Р°С… СЃСѓСЂСѓР№Р°Р°С‡С‡С‹ РєРёРјРёР№?');
    });

    test('falls back to legacy region file with strict map lookup', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'history',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(questions.first.questionText, 'Who founded Yakutsk?');
    });

    test('legacy plain strings fall back to Russian for non-Russian languages',
        () async {
      final englishQuestions = await QuestionService.loadQuestions(
        country: 'usa',
        category: 'famous_people',
        language: AppLanguage.english,
      );
      final yakutQuestions = await QuestionService.loadQuestions(
        country: 'usa',
        category: 'famous_people',
        language: AppLanguage.yakut,
      );
      final russianQuestions = await QuestionService.loadQuestions(
        country: 'usa',
        category: 'famous_people',
        language: AppLanguage.russian,
      );

      const expectedQuestion =
          'РљС‚Рѕ Р±С‹Р» РїРµСЂРІС‹Рј РїСЂРµР·РёРґРµРЅС‚РѕРј РЎРЁРђ?';
      expect(englishQuestions, isNotEmpty);
      expect(yakutQuestions, isNotEmpty);
      expect(russianQuestions, isNotEmpty);
      expect(englishQuestions.first.questionText, expectedQuestion);
      expect(yakutQuestions.first.questionText, expectedQuestion);
      expect(russianQuestions.first.questionText, expectedQuestion);
    });

    test('parses question imageAsset when provided', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(
        questions.first.imageAsset,
        'assets/question_images/russia/dagestan/famous_people/rasul_gamzatov.jpg',
      );
    });

    test('parses question image alias field when imageAsset is missing',
        () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.yakut,
      );

      expect(questions, isNotEmpty);
      expect(
        questions.first.imageAsset,
        'assets/question_images/russia/dagestan/famous_people/rasul_gamzatov_sah.jpg',
      );
    });

    test('parses explanation as plain string', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(
        questions.first.explanationText,
        'Rasul Gamzatov is one of the best-known Dagestani poets.',
      );
    });

    test('parses explanation from localized map for legacy files', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'history',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(
        questions.first.explanationText,
        'Yakutsk was founded in 1632 by Pyotr Beketov.',
      );
    });

    test('question explanation is null when no explanation field exists',
        () async {
      final questions = await QuestionService.loadQuestions(
        country: 'usa',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(questions.first.explanationText, isNull);
    });

    test('question image is null when no image field exists', () async {
      final questions = await QuestionService.loadQuestions(
        country: 'usa',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(questions, isNotEmpty);
      expect(questions.first.imageAsset, isNull);
    });

    test('aggregates mixed regional sources without duplicates', () async {
      final dagestan = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'dagestan',
        category: 'famous_people',
        language: AppLanguage.english,
      );
      final yakutia = await QuestionService.loadQuestions(
        country: 'russia',
        region: 'yakutia',
        category: 'famous_people',
        language: AppLanguage.english,
      );
      final aggregated = await QuestionService.loadQuestions(
        country: 'russia',
        category: 'famous_people',
        language: AppLanguage.english,
      );

      expect(dagestan, isNotEmpty);
      expect(yakutia, isNotEmpty);
      expect(aggregated, isNotEmpty);

      final dagestanSet = _questionSet(dagestan.map((q) => q.questionText));
      final yakutiaSet = _questionSet(yakutia.map((q) => q.questionText));
      final expectedUnion = <String>{...dagestanSet, ...yakutiaSet};
      final aggregatedSet = _questionSet(aggregated.map((q) => q.questionText));

      expect(aggregatedSet.containsAll(dagestanSet), isTrue);
      expect(aggregatedSet.containsAll(yakutiaSet), isTrue);
      expect(aggregatedSet, equals(expectedUnion));
    });
  });
}

Map<String, String> _buildMockAssets() {
  final data = <String, String>{
    'assets/data/russia/dagestan/en/famous_people.json': jsonEncode([
      {
        'question': 'Who is the most famous Dagestani poet?',
        'imageAsset':
            'assets/question_images/russia/dagestan/famous_people/rasul_gamzatov.jpg',
        'explanation':
            'Rasul Gamzatov is one of the best-known Dagestani poets.',
        'answers': [
          {'text': 'Rasul Gamzatov', 'score': 1},
          {'text': 'Other', 'score': 0}
        ]
      }
    ]),
    'assets/data/russia/dagestan/sah/famous_people.json': jsonEncode([
      {
        'question':
            'РЎР°С…Р° С‚С‹Р»С‹РЅР°РЅ СЃСѓРѕР»С‚Р°Р»Р°Р°С… СЃСѓСЂСѓР№Р°Р°С‡С‡С‹ РєРёРјРёР№?',
        'image':
            'assets/question_images/russia/dagestan/famous_people/rasul_gamzatov_sah.jpg',
        'answers': [
          {'text': 'Р Р°СЃСѓР» Р“Р°РјР·Р°С‚РѕРІ', 'score': 1},
          {'text': 'РђС‚С‹РЅ', 'score': 0}
        ]
      }
    ]),
    'assets/data/russia/yakutia/history.json': jsonEncode([
      {
        'question': {
          'en': 'Who founded Yakutsk?',
          'ru': 'РљС‚Рѕ РѕСЃРЅРѕРІР°Р» РЇРєСѓС‚СЃРє?',
          'yakut': 'Р”СЊРѕРєСѓСѓСЃРєР°Р№С‹ РєРёРј С‚СЌСЂРёР№Р±РёС‚РёР№?'
        },
        'explanation': {
          'en': 'Yakutsk was founded in 1632 by Pyotr Beketov.',
          'ru':
              'РЇРєСѓС‚СЃРє РѕСЃРЅРѕРІР°РЅ РІ 1632 РіРѕРґСѓ РџРµС‚СЂРѕРј Р‘РµРєРµС‚РѕРІС‹Рј.',
          'yakut': 'Дьокуускай 1632 сыллаахха Петр Бекетов тэрийбит.'
        },
        'answers': [
          {
            'text': {
              'en': 'Pyotr Beketov',
              'ru': 'РџРµС‚СЂ Р‘РµРєРµС‚РѕРІ',
              'yakut': 'РџРµС‚СЂ Р‘РµРєРµС‚РѕРІ'
            },
            'score': 1
          },
          {
            'text': {'en': 'Other', 'ru': 'Р”СЂСѓРіРѕР№', 'yakut': 'РђС‚С‹РЅ'},
            'score': 0
          }
        ]
      }
    ]),
    'assets/data/russia/yakutia/famous_people.json': jsonEncode([
      {
        'question': {
          'en': 'Who was the first president of the Sakha Republic?',
          'ru':
              'РљС‚Рѕ Р±С‹Р» РїРµСЂРІС‹Рј РїСЂРµР·РёРґРµРЅС‚РѕРј Р РµСЃРїСѓР±Р»РёРєРё РЎР°С…Р°?',
          'yakut':
              'РЎР°С…Р° У©СЂУ©СЃРїТЇТЇР±ТЇР»ТЇРєСЌС‚РёРЅ Р±Р°СЃС‚Р°РєС‹ РїСЂРµР·РёРґРµРЅС‚Р° РєРёРјРёР№?'
        },
        'answers': [
          {
            'text': {
              'en': 'Mikhail Nikolaev',
              'ru': 'РњРёС…Р°РёР» РќРёРєРѕР»Р°РµРІ',
              'yakut': 'РњРёС…Р°РёР» РќРёРєРѕР»Р°РµРІ'
            },
            'score': 1
          },
          {
            'text': {'en': 'Other', 'ru': 'Р”СЂСѓРіРѕР№', 'yakut': 'РђС‚С‹РЅ'},
            'score': 0
          }
        ]
      }
    ]),
    'assets/data/russia/famous_people.json': jsonEncode([
      {
        'question':
            'РљС‚Рѕ Р±С‹Р» РїРµСЂРІС‹Рј С‡РµР»РѕРІРµРєРѕРј РІ РєРѕСЃРјРѕСЃРµ?',
        'answers': [
          {'text': 'Р®СЂРёР№ Р“Р°РіР°СЂРёРЅ', 'score': 1},
          {'text': 'Р”СЂСѓРіРѕР№', 'score': 0}
        ]
      }
    ]),
    'assets/data/usa/famous_people.json': jsonEncode([
      {
        'question': 'РљС‚Рѕ Р±С‹Р» РїРµСЂРІС‹Рј РїСЂРµР·РёРґРµРЅС‚РѕРј РЎРЁРђ?',
        'answers': [
          {'text': 'Р”Р¶РѕСЂРґР¶ Р’Р°С€РёРЅРіС‚РѕРЅ', 'score': 1},
          {'text': 'Р”СЂСѓРіРѕР№', 'score': 0}
        ]
      }
    ]),
  };

  final manifest = <String, List<String>>{
    for (final key in data.keys) key: [key],
  };
  data['AssetManifest.json'] = jsonEncode(manifest);
  return data;
}

Set<String> _questionSet(Iterable<String> questions) {
  return questions.map((value) => value.trim().toLowerCase()).toSet();
}
