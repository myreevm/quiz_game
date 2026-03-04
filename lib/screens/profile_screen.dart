import 'package:flutter/material.dart';

import '../models/app_texts.dart';
import '../models/game_catalog.dart';
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
    final averageRoundPercent = progress.totalRounds <= 0
        ? 0
        : (progress.totalRoundPercentSum / progress.totalRounds).round();
    final collectedCount = playableCountryCodes
        .where((code) => (progress.countries[code]?.rounds ?? 0) > 0)
        .length;
    final collectionProgress = playableCountryCodes.isEmpty
        ? 0.0
        : collectedCount / playableCountryCodes.length;
    final colorScheme = Theme.of(context).colorScheme;

    final countryEntries = progress.countries.entries.toList()
      ..sort((a, b) {
        final byRounds = b.value.rounds.compareTo(a.value.rounds);
        if (byRounds != 0) {
          return byRounds;
        }
        return texts.countryName(a.key).compareTo(texts.countryName(b.key));
      });

    final topAccuracyCountries = progress.countries.entries
        .where((entry) => entry.value.questions > 0)
        .toList()
      ..sort((a, b) {
        final aAccuracy = a.value.correct / a.value.questions;
        final bAccuracy = b.value.correct / b.value.questions;
        final byAccuracy = bAccuracy.compareTo(aAccuracy);
        if (byAccuracy != 0) {
          return byAccuracy;
        }

        final byRounds = b.value.rounds.compareTo(a.value.rounds);
        if (byRounds != 0) {
          return byRounds;
        }

        return texts.countryName(a.key).compareTo(texts.countryName(b.key));
      });
    final topFiveCountries = topAccuracyCountries.take(5).toList();

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
                    texts.profileAdvancedStatsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _StatChip(
                        label: texts.profileAverageRoundPercentLabel,
                        value: '$averageRoundPercent%',
                        color: colorScheme.primary,
                      ),
                      _StatChip(
                        label: texts.profileBestRoundPercentLabel,
                        value: '${progress.bestRoundPercent}%',
                        color: colorScheme.secondary,
                      ),
                      _StatChip(
                        label: texts.profileCollectedCountriesLabel,
                        value: texts.profileCollectionProgress(
                          collectedCount,
                          playableCountryCodes.length,
                        ),
                        color: colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                    texts.profileCollectionTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    texts.profileCollectionProgress(
                      collectedCount,
                      playableCountryCodes.length,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: collectionProgress,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: playableCountryCodes.map((countryCode) {
                      final isCollected =
                          (progress.countries[countryCode]?.rounds ?? 0) > 0;
                      return _CollectionFlag(
                        countryCode: countryCode,
                        isCollected: isCollected,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texts.profileTopAccuracyTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          if (topFiveCountries.isEmpty)
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
            ...topFiveCountries.asMap().entries.map((entry) {
              final index = entry.key;
              final countryCode = entry.value.key;
              final countryProgress = entry.value.value;
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
                        Text(
                          '${index + 1}.',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        FlagBadge(
                          code: countryCode,
                          width: 42,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            texts.countryName(countryCode),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
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
          const SizedBox(height: 4),
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

class _CollectionFlag extends StatelessWidget {
  final String countryCode;
  final bool isCollected;

  const _CollectionFlag({
    required this.countryCode,
    required this.isCollected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey('profile-collection-flag-$countryCode'),
      width: 48,
      height: 36,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: isCollected ? 1.0 : 0.3,
            child: FlagBadge(
              code: countryCode,
              width: 48,
              height: 36,
            ),
          ),
          if (!isCollected)
            Container(
              key: ValueKey('profile-collection-lock-$countryCode'),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withValues(alpha: 0.16),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.lock_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
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
