import 'package:flutter/material.dart';

import '../models/app_texts.dart';
import '../models/player_progress.dart';
import 'flag_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final progressController = PlayerProgressScope.of(context);
    final progress = progressController.progress;
    final unlockedCount = progressController.unlockedAchievements.length;
    final totalAchievements = AchievementId.values.length;
    final accuracy = _percent(progress.totalCorrect, progress.totalQuestions);
    final colorScheme = Theme.of(context).colorScheme;

    final countryEntries = progress.countries.entries.toList()
      ..sort((a, b) {
        final byRounds = b.value.rounds.compareTo(a.value.rounds);
        if (byRounds != 0) {
          return byRounds;
        }
        return texts.countryName(a.key).compareTo(texts.countryName(b.key));
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.profileTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        children: [
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    texts.profileSummaryTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _StatChip(
                        label: texts.profileTotalRoundsLabel,
                        value: '${progress.totalRounds}',
                        color: colorScheme.primary,
                      ),
                      _StatChip(
                        label: texts.profileTotalQuestionsLabel,
                        value: '${progress.totalQuestions}',
                        color: colorScheme.secondary,
                      ),
                      _StatChip(
                        label: texts.profileTotalCorrectLabel,
                        value: '${progress.totalCorrect}',
                        color: colorScheme.tertiary,
                      ),
                      _StatChip(
                        label: texts.profileAccuracyLabel,
                        value: '$accuracy%',
                        color: colorScheme.primary,
                      ),
                      _StatChip(
                        label: texts.profileHintBalanceLabel,
                        value: '${progress.hintBalance}',
                        color: colorScheme.secondary,
                      ),
                      _StatChip(
                        label: texts.profileAchievementsLabel,
                        value: '$unlockedCount/$totalAchievements',
                        color: colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texts.profileByCountriesTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          if (countryEntries.isEmpty)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  texts.profileEmptyCountries,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            )
          else
            ...countryEntries.map((entry) {
              final countryCode = entry.key;
              final countryProgress = entry.value;
              final countryAccuracy =
                  _percent(countryProgress.correct, countryProgress.questions);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        FlagBadge(
                          code: countryCode,
                          width: 42,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                texts.countryName(countryCode),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                texts.profileCountryRoundsLabel(
                                  countryProgress.rounds,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          texts.profileCountryAccuracyLabel(countryAccuracy),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  int _percent(int correct, int total) {
    if (total <= 0) {
      return 0;
    }
    return ((correct / total) * 100).round();
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
