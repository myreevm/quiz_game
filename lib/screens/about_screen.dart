import 'package:flutter/material.dart';

import '../models/app_texts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: Text(texts.aboutTitle)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.5),
              colorScheme.surface,
              colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                isWide ? 30 : 18,
                16,
                isWide ? 30 : 18,
                24,
              ),
              children: [
                _AboutHero(
                  texts: texts,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: texts.aboutSectionWhatTitle,
                  icon: Icons.quiz_rounded,
                  child: Text(
                    texts.aboutSectionWhatBody,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: texts.aboutSectionHowTitle,
                  icon: Icons.flag_rounded,
                  child: Column(
                    children: [
                      _StepTile(step: '1', text: texts.aboutStep1),
                      const SizedBox(height: 10),
                      _StepTile(step: '2', text: texts.aboutStep2),
                      const SizedBox(height: 10),
                      _StepTile(step: '3', text: texts.aboutStep3),
                      const SizedBox(height: 10),
                      _StepTile(step: '4', text: texts.aboutStep4),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: texts.aboutSectionFeaturesTitle,
                  icon: Icons.auto_awesome_rounded,
                  child: Column(
                    children: [
                      _FeatureTile(
                        icon: Icons.shuffle_rounded,
                        text: texts.aboutFeature1,
                      ),
                      const SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.palette_rounded,
                        text: texts.aboutFeature2,
                      ),
                      const SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.tune_rounded,
                        text: texts.aboutFeature3,
                      ),
                      const SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.insights_rounded,
                        text: texts.aboutFeature4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: texts.aboutSectionTipsTitle,
                  icon: Icons.lightbulb_rounded,
                  child: Column(
                    children: [
                      _TipTile(text: texts.aboutTip1),
                      const SizedBox(height: 8),
                      _TipTile(text: texts.aboutTip2),
                      const SizedBox(height: 8),
                      _TipTile(text: texts.aboutTip3),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.65,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        texts.appVersionLabel('1.1'),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  final AppTexts texts;
  final ColorScheme colorScheme;

  const _AboutHero({
    required this.texts,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.9),
            colorScheme.tertiary.withValues(alpha: 0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texts.aboutHeroTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  texts.aboutHeroDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String step;
  final String text;

  const _StepTile({
    required this.step,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withValues(alpha: 0.14),
          ),
          child: Text(
            step,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureTile({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.secondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _TipTile extends StatelessWidget {
  final String text;

  const _TipTile({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, size: 20, color: colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.45),
          ),
        ),
      ],
    );
  }
}
