import 'dart:convert';

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

  testWidgets(
      'shows answer feedback, waits for Next, and uses fallback explanation',
      (tester) async {
    await _pumpQuiz(
      tester,
      country: 'testland',
      category: 'famous_people',
      timerEnabled: false,
    );

    await _pumpUntilFound(tester, find.text('First correct'));
    expect(find.text('Question one'), findsOneWidget);
    expect(find.text('Question two'), findsNothing);

    await tester.tap(find.text('First correct'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quiz-answer-feedback')), findsOneWidget);
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Correct answer: First correct'), findsOneWidget);
    expect(find.text('First explanation text.'), findsOneWidget);
    expect(find.text('Question two'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quiz-answer-feedback')), findsNothing);
    expect(find.text('Question two'), findsOneWidget);

    await tester.tap(find.text('Second correct'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quiz-answer-feedback')), findsOneWidget);
    expect(find.text('Explanation is not added yet.'), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);
  });

  testWidgets('shows timeout feedback when timer expires', (tester) async {
    await _pumpQuiz(
      tester,
      country: 'testland',
      category: 'history',
      timerEnabled: true,
    );

    await _pumpUntilFound(tester, find.text('Timed question'));
    expect(find.text('Timed question'), findsOneWidget);

    await tester.pump(const Duration(seconds: 21));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quiz-answer-feedback')), findsOneWidget);
    expect(find.text("Time's up"), findsOneWidget);
    expect(find.text('Correct answer: Timed correct'), findsOneWidget);
  });
}

Future<void> _pumpQuiz(
  WidgetTester tester, {
  required String country,
  required String category,
  required bool timerEnabled,
}) async {
  await tester.binding.setSurfaceSize(const Size(430, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final settingsController = AppSettingsController(
    initialSettings: AppSettings(
      appLanguage: AppLanguage.english,
      questionTimerEnabled: timerEnabled,
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

  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      break;
    }
  }
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTicks = 40,
}) async {
  for (var i = 0; i < maxTicks; i++) {
    if (finder.evaluate().isNotEmpty) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }

  expect(finder, findsWidgets);
}

Map<String, Uint8List> _buildMockAssets() {
  final data = <String, Uint8List>{
    'assets/data/testland/en/famous_people.json': _utf8(
      jsonEncode([
        {
          'question': 'Question one',
          'explanation': 'First explanation text.',
          'answers': [
            {'text': 'First correct', 'score': 1},
            {'text': 'First wrong', 'score': 0},
          ],
        },
        {
          'question': 'Question two',
          'answers': [
            {'text': 'Second correct', 'score': 1},
            {'text': 'Second wrong', 'score': 0},
          ],
        },
      ]),
    ),
    'assets/data/testland/en/history.json': _utf8(
      jsonEncode([
        {
          'question': 'Timed question',
          'answers': [
            {'text': 'Timed correct', 'score': 1},
            {'text': 'Timed wrong', 'score': 0},
          ],
        },
      ]),
    ),
  };

  final manifest = <String, List<String>>{
    for (final key in data.keys) key: [key],
  };
  data['AssetManifest.json'] = _utf8(jsonEncode(manifest));

  return data;
}

Uint8List _utf8(String value) => Uint8List.fromList(utf8.encode(value));
