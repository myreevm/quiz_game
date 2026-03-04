import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/player_progress.dart';

void main() {
  test('recordRound updates bestRoundPercent and totalRoundPercentSum', () {
    final controller = PlayerProgressController(
      initialProgress: const PlayerProgress(),
    );

    controller.recordRound(
      const RoundRecord(
        country: 'usa',
        totalQuestions: 10,
        correctAnswers: 7,
        timeouts: 0,
        timerWasEnabled: true,
        hintsUsed: 0,
      ),
    );

    expect(controller.progress.totalRoundPercentSum, 70);
    expect(controller.progress.bestRoundPercent, 70);

    controller.recordRound(
      const RoundRecord(
        country: 'usa',
        totalQuestions: 10,
        correctAnswers: 9,
        timeouts: 0,
        timerWasEnabled: true,
        hintsUsed: 0,
      ),
    );

    expect(controller.progress.totalRoundPercentSum, 160);
    expect(controller.progress.bestRoundPercent, 90);
  });

  test('fromJson keeps defaults for new fields with old payload', () {
    final progress = PlayerProgress.fromJson(
      {
        'totalRounds': 3,
        'totalQuestions': 20,
        'totalCorrect': 14,
      },
    );

    expect(progress.totalRounds, 3);
    expect(progress.totalQuestions, 20);
    expect(progress.totalCorrect, 14);
    expect(progress.bestRoundPercent, 0);
    expect(progress.totalRoundPercentSum, 0);
  });
}
