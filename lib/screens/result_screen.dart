import 'package:flutter/material.dart';

import '../models/app_texts.dart';
import '../models/player_progress.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<AchievementId> newlyUnlocked;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    this.newlyUnlocked = const [],
  });

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final percent = ((score / total) * 100).round();
    final ratio = score / total;

    return Scaffold(
      appBar: AppBar(title: Text(texts.resultTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                texts.resultScoreText(score, total),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                texts.resultMessageForPercent(ratio),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (newlyUnlocked.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts.resultNewAchievementsTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ...newlyUnlocked.map(
                          (achievement) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• ${texts.achievementTitle(achievement)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(texts.resultToMainMenu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
