import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/models/game_catalog.dart';
import 'package:quiz_app/models/player_progress.dart';
import 'package:quiz_app/screens/profile_screen.dart';

void main() {
  testWidgets('shows advanced stats, top countries, and collection progress',
      (tester) async {
    final settingsController = AppSettingsController(
      initialSettings: const AppSettings(appLanguage: AppLanguage.english),
    );
    final progressController = PlayerProgressController(
      initialProgress: PlayerProgress(
        totalRounds: 2,
        totalQuestions: 20,
        totalCorrect: 15,
        bestRoundPercent: 90,
        totalRoundPercentSum: 150,
        hintBalance: 3,
        countries: {
          'usa': CountryProgress(rounds: 2, questions: 10, correct: 8),
          'japan': CountryProgress(rounds: 1, questions: 10, correct: 7),
        },
      ),
    );

    await tester.pumpWidget(
      AppSettingsScope(
        controller: settingsController,
        child: PlayerProgressScope(
          controller: progressController,
          child: const MaterialApp(home: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Advanced stats'), findsOneWidget);
    expect(find.text('Average round %'), findsOneWidget);
    expect(find.text('75%'), findsWidgets);
    expect(find.text('Best round'), findsOneWidget);
    expect(find.text('90%'), findsOneWidget);

    expect(find.text('Country collection'), findsOneWidget);
    expect(
      find.text('2 / ${playableCountryCodes.length}'),
      findsWidgets,
    );

    expect(find.byKey(const ValueKey('profile-collection-lock-usa')),
        findsNothing);
    expect(find.byKey(const ValueKey('profile-collection-lock-canada')),
        findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Top-5 countries by accuracy'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Top-5 countries by accuracy'), findsOneWidget);
  });
}
