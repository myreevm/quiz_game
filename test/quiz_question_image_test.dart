import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/models/player_progress.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

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

        return ByteData.sublistView(content);
      },
    );
  });

  tearDownAll(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler('flutter/assets', null);
  });

  testWidgets('shows question image when imageAsset is valid', (tester) async {
    await _pumpQuiz(
      tester,
      country: 'testland',
      category: 'famous_people',
    );

    expect(find.byKey(const ValueKey('quiz-question-image')), findsOneWidget);
    expect(find.text('Question with image'), findsOneWidget);
  });

  testWidgets('does not show image block when imageAsset is missing',
      (tester) async {
    await _pumpQuiz(
      tester,
      country: 'testland',
      category: 'history',
    );

    expect(find.byKey(const ValueKey('quiz-question-image')), findsNothing);
    expect(find.text('Question without image'), findsOneWidget);
  });

  testWidgets('hides image block when image asset cannot be loaded',
      (tester) async {
    await _pumpQuiz(
      tester,
      country: 'testland',
      category: 'movies',
    );

    expect(find.text('Question with missing image'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz-question-image')), findsNothing);
  });
}

Future<void> _pumpQuiz(
  WidgetTester tester, {
  required String country,
  required String category,
}) async {
  await tester.binding.setSurfaceSize(const Size(430, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final settingsController = AppSettingsController(
    initialSettings: const AppSettings(
      appLanguage: AppLanguage.english,
      questionTimerEnabled: false,
      shuffleQuestions: false,
      shuffleAnswers: false,
    ),
  );
  final progressController = PlayerProgressController(
    initialProgress: const PlayerProgress(),
  );

  await tester.pumpWidget(
    AppSettingsScope(
      controller: settingsController,
      child: PlayerProgressScope(
        controller: progressController,
        child: MaterialApp(
          home: QuizScreen(
            country: country,
            region: null,
            category: category,
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Map<String, Uint8List> _buildMockAssets() {
  final data = <String, Uint8List>{
    'assets/data/testland/en/famous_people.json': _utf8(
      jsonEncode([
        {
          'question': 'Question with image',
          'imageAsset': 'assets/question_images/testland/famous_people/one.png',
          'answers': [
            {'text': 'Correct', 'score': 1},
            {'text': 'Wrong', 'score': 0},
          ],
        }
      ]),
    ),
    'assets/data/testland/en/history.json': _utf8(
      jsonEncode([
        {
          'question': 'Question without image',
          'answers': [
            {'text': 'Correct', 'score': 1},
            {'text': 'Wrong', 'score': 0},
          ],
        }
      ]),
    ),
    'assets/data/testland/en/movies.json': _utf8(
      jsonEncode([
        {
          'question': 'Question with missing image',
          'imageAsset': 'assets/question_images/testland/movies/missing.png',
          'answers': [
            {'text': 'Correct', 'score': 1},
            {'text': 'Wrong', 'score': 0},
          ],
        }
      ]),
    ),
    'assets/question_images/testland/famous_people/one.png':
        File('assets/flags/usa.png').readAsBytesSync(),
  };

  final manifest = <String, List<String>>{
    for (final key in data.keys) key: [key],
  };
  data['AssetManifest.json'] = _utf8(jsonEncode(manifest));

  return data;
}

Uint8List _utf8(String value) => Uint8List.fromList(utf8.encode(value));
