import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SuggestQuestionScreen extends StatelessWidget {
  const SuggestQuestionScreen({super.key});

  static final Uri _instagramUri =
      Uri.parse('https://www.instagram.com/quiz_game_app');
  static final Uri _telegramUri = Uri.parse('https://t.me/myreev1');
  static final Uri _gmailUri = Uri(
    scheme: 'mailto',
    path: 'myreevmark06@gmail.com',
    queryParameters: <String, String>{
      'subject': 'Предложение вопроса для Quiz Game',
      'body': 'Здравствуйте!\n\n'
          'Хочу предложить новый вопрос:\n'
          '- Страна:\n'
          '- Категория:\n'
          '- Вопрос:\n'
          '- Варианты ответов:\n'
          '- Правильный ответ:\n',
    },
  );

  Future<void> _openLink(BuildContext context, Uri uri) async {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (launched || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Не удалось открыть ссылку. Попробуйте позже.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Предложить вопрос')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.55),
              colorScheme.surface,
              colorScheme.secondaryContainer.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
          children: [
            _InfoCard(colorScheme: colorScheme),
            const SizedBox(height: 14),
            _ContactCard(
              title: 'Instagram',
              subtitle: '@quiz_game_app',
              icon: Icons.camera_alt_rounded,
              color: colorScheme.secondary,
              onTap: () => _openLink(context, _instagramUri),
            ),
            const SizedBox(height: 10),
            _ContactCard(
              title: 'Telegram',
              subtitle: '@myreev1',
              icon: Icons.send_rounded,
              color: colorScheme.primary,
              onTap: () => _openLink(context, _telegramUri),
            ),
            const SizedBox(height: 10),
            _ContactCard(
              title: 'Gmail',
              subtitle: 'myreevmark06@gmail.com',
              icon: Icons.mail_rounded,
              color: colorScheme.tertiary,
              onTap: () => _openLink(context, _gmailUri),
            ),
            const SizedBox(height: 16),
            Text(
              'Можно прислать вопрос, 4 варианта ответа и указать правильный вариант.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ColorScheme colorScheme;

  const _InfoCard({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.9),
            colorScheme.secondary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Предложите свой вопрос',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Вы можете отправить свои идеи через Instagram, Telegram или Gmail. '
            'Лучшие вопросы добавим в следующие обновления.',
            style: TextStyle(
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: color),
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
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
