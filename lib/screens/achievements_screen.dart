import 'package:flutter/material.dart';

import '../models/app_texts.dart';
import '../models/player_progress.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final progressController = PlayerProgressScope.of(context);
    final unlocked = progressController.unlockedAchievements;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.achievementsTitle),
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
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      texts.achievementsProgressLabel(
                        unlocked.length,
                        AchievementId.values.length,
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...AchievementId.values.map((id) {
            final isUnlocked = unlocked.contains(id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AchievementTile(
                icon: _achievementIcon(id),
                title: texts.achievementTitle(id),
                description: texts.achievementDescription(id),
                isUnlocked: isUnlocked,
                doneLabel: texts.achievementDoneLabel,
                progressLabel: texts.achievementInProgressLabel,
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _achievementIcon(AchievementId id) {
    switch (id) {
      case AchievementId.firstRound:
        return Icons.play_circle_rounded;
      case AchievementId.fiveRounds:
        return Icons.looks_5_rounded;
      case AchievementId.twentyRounds:
        return Icons.workspace_premium_rounded;
      case AchievementId.perfectRound:
        return Icons.stars_rounded;
      case AchievementId.accuracyMaster:
        return Icons.track_changes_rounded;
      case AchievementId.worldExplorer:
        return Icons.travel_explore_rounded;
      case AchievementId.hintTactician:
        return Icons.lightbulb_rounded;
      case AchievementId.speedClean:
        return Icons.bolt_rounded;
    }
  }
}

class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final String doneLabel;
  final String progressLabel;

  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.doneLabel,
    required this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final accent = isUnlocked ? colorScheme.primary : colorScheme.outline;
    final background = isUnlocked
        ? colorScheme.primary.withValues(alpha: 0.08)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
          color: background,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.16),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isUnlocked ? doneLabel : progressLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
