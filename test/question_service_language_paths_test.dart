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
          'Саха тылынан суолталаах суруйааччы кимий?');
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

      const expectedQuestion = 'Кто был первым президентом США?';
      expect(englishQuestions, isNotEmpty);
      expect(yakutQuestions, isNotEmpty);
      expect(russianQuestions, isNotEmpty);
      expect(englishQuestions.first.questionText, expectedQuestion);
      expect(yakutQuestions.first.questionText, expectedQuestion);
      expect(russianQuestions.first.questionText, expectedQuestion);
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
        'answers': [
          {'text': 'Rasul Gamzatov', 'score': 1},
          {'text': 'Other', 'score': 0}
        ]
      }
    ]),
    'assets/data/russia/dagestan/sah/famous_people.json': jsonEncode([
      {
        'question': 'Саха тылынан суолталаах суруйааччы кимий?',
        'answers': [
          {'text': 'Расул Гамзатов', 'score': 1},
          {'text': 'Атын', 'score': 0}
        ]
      }
    ]),
    'assets/data/russia/yakutia/history.json': jsonEncode([
      {
        'question': {
          'en': 'Who founded Yakutsk?',
          'ru': 'Кто основал Якутск?',
          'yakut': 'Дьокуускайы ким тэрийбитий?'
        },
        'answers': [
          {
            'text': {
              'en': 'Pyotr Beketov',
              'ru': 'Петр Бекетов',
              'yakut': 'Петр Бекетов'
            },
            'score': 1
          },
          {
            'text': {'en': 'Other', 'ru': 'Другой', 'yakut': 'Атын'},
            'score': 0
          }
        ]
      }
    ]),
    'assets/data/russia/yakutia/famous_people.json': jsonEncode([
      {
        'question': {
          'en': 'Who was the first president of the Sakha Republic?',
          'ru': 'Кто был первым президентом Республики Саха?',
          'yakut': 'Саха өрөспүүбүлүкэтин бастакы президента кимий?'
        },
        'answers': [
          {
            'text': {
              'en': 'Mikhail Nikolaev',
              'ru': 'Михаил Николаев',
              'yakut': 'Михаил Николаев'
            },
            'score': 1
          },
          {
            'text': {'en': 'Other', 'ru': 'Другой', 'yakut': 'Атын'},
            'score': 0
          }
        ]
      }
    ]),
    'assets/data/russia/famous_people.json': jsonEncode([
      {
        'question': 'Кто был первым человеком в космосе?',
        'answers': [
          {'text': 'Юрий Гагарин', 'score': 1},
          {'text': 'Другой', 'score': 0}
        ]
      }
    ]),
    'assets/data/usa/famous_people.json': jsonEncode([
      {
        'question': 'Кто был первым президентом США?',
        'answers': [
          {'text': 'Джордж Вашингтон', 'score': 1},
          {'text': 'Другой', 'score': 0}
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
