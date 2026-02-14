import 'dart:io';

import 'package:flutter/material.dart';

import '../models/app_texts.dart';
import 'about_screen.dart';
import 'country_selection_screen.dart';
import 'settings_screen.dart';
import 'suggest_question_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final texts = AppTexts.of(context);
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(texts.exitDialogTitle),
          content: Text(texts.exitDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(texts.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(texts.confirmExitButton),
            ),
          ],
        );
      },
    );

    if ((shouldExit ?? false) && context.mounted) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(texts.mainMenuTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.65),
              colorScheme.surface,
              colorScheme.secondaryContainer.withValues(alpha: 0.45),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth > 700 ? 48.0 : 20.0;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _MainMenuHeader(
                          colorScheme: colorScheme,
                          texts: texts,
                        ),
                        const SizedBox(height: 18),
                        _MenuActionCard(
                          title: texts.playActionTitle,
                          subtitle: texts.playActionSubtitle,
                          icon: Icons.play_circle_fill_rounded,
                          color: colorScheme.primary,
                          onTap: () => _openScreen(
                            context,
                            const CountrySelectionScreen(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _MenuActionCard(
                          title: texts.settingsActionTitle,
                          subtitle: texts.settingsActionSubtitle,
                          icon: Icons.tune_rounded,
                          color: colorScheme.secondary,
                          onTap: () =>
                              _openScreen(context, const SettingsScreen()),
                        ),
                        const SizedBox(height: 12),
                        _MenuActionCard(
                          title: texts.aboutActionTitle,
                          subtitle: texts.aboutActionSubtitle,
                          icon: Icons.info_rounded,
                          color: colorScheme.tertiary,
                          onTap: () =>
                              _openScreen(context, const AboutScreen()),
                        ),
                        const SizedBox(height: 12),
                        _MenuActionCard(
                          title: texts.suggestActionTitle,
                          subtitle: texts.suggestActionSubtitle,
                          icon: Icons.rate_review_rounded,
                          color: colorScheme.primary,
                          onTap: () => _openScreen(
                            context,
                            const SuggestQuestionScreen(),
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.tonalIcon(
                          onPressed: () => _confirmExit(context),
                          icon: const Icon(Icons.logout_rounded),
                          label: Text(texts.exitActionTitle),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MainMenuHeader extends StatelessWidget {
  final ColorScheme colorScheme;
  final AppTexts texts;

  const _MainMenuHeader({
    required this.colorScheme,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.9),
            colorScheme.secondary.withValues(alpha: 0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.appTitle,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texts.mainMenuHeaderDescription,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderTag(text: texts.mainMenuTagCategories),
              _HeaderTag(text: texts.mainMenuTagProgress),
              _HeaderTag(text: texts.mainMenuTagResults),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderTag extends StatelessWidget {
  final String text;

  const _HeaderTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
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
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
