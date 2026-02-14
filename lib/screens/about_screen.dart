import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Об игре')),
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
                  isWide ? 30 : 18, 16, isWide ? 30 : 18, 24),
              children: [
                _AboutHero(colorScheme: colorScheme),
                const SizedBox(height: 16),
                const _SectionCard(
                  title: 'Что это за приложение',
                  icon: Icons.quiz_rounded,
                  child: Text(
                    'Quiz Game — это обучающая викторина, где вы отвечаете на вопросы по разным темам: история, музыка, кино и известные личности. '
                    'Приложение подходит для коротких игровых сессий, тренировки памяти и проверки эрудиции.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: 'Как играть',
                  icon: Icons.flag_rounded,
                  child: Column(
                    children: [
                      _StepTile(
                        step: '1',
                        text: 'Выберите страну и при необходимости регион.',
                      ),
                      SizedBox(height: 10),
                      _StepTile(
                        step: '2',
                        text: 'Откройте категорию и начните раунд.',
                      ),
                      SizedBox(height: 10),
                      _StepTile(
                        step: '3',
                        text: 'Отвечайте на вопросы и следите за прогрессом.',
                      ),
                      SizedBox(height: 10),
                      _StepTile(
                        step: '4',
                        text:
                            'В конце получите итог, процент правильных ответов и обратную связь.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: 'Возможности',
                  icon: Icons.auto_awesome_rounded,
                  child: Column(
                    children: [
                      _FeatureTile(
                        icon: Icons.shuffle_rounded,
                        text: 'Перемешивание вопросов и вариантов ответов',
                      ),
                      SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.palette_rounded,
                        text: 'Светлая и тёмная тема',
                      ),
                      SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.tune_rounded,
                        text: 'Настройка количества вопросов в раунде',
                      ),
                      SizedBox(height: 8),
                      _FeatureTile(
                        icon: Icons.insights_rounded,
                        text: 'Экран результата с процентом и комментариями',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: 'Советы для лучшего результата',
                  icon: Icons.lightbulb_rounded,
                  child: Column(
                    children: [
                      _TipTile(
                          text:
                              'Запускайте разные категории — так знания закрепляются лучше.'),
                      SizedBox(height: 8),
                      _TipTile(
                          text:
                              'Попробуйте уменьшить время на ответ для дополнительной сложности.'),
                      SizedBox(height: 8),
                      _TipTile(
                          text:
                              'Повторяйте раунды и сравнивайте свой прогресс.'),
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
                      Icon(Icons.info_outline_rounded,
                          color: colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Версия приложения: 1.1',
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
  final ColorScheme colorScheme;

  const _AboutHero({required this.colorScheme});

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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school_rounded, color: Colors.white, size: 36),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'О проекте Quiz Game',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Простая и увлекательная викторина для тренировки кругозора, внимания и скорости мышления.',
                  style: TextStyle(
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
