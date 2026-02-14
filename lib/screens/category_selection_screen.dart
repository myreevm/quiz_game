import 'package:flutter/material.dart';

import 'quiz_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final String country;
  final String? region;

  const CategorySelectionScreen({
    super.key,
    required this.country,
    required this.region,
  });

  static const countryNames = {
    'russia': 'Россия',
    'usa': 'США',
    'china': 'Китай',
    'poland': 'Польша',
    'france': 'Франция',
  };

  static const regionNames = {
    'yakutia': 'Якутия',
    'dagestan': 'Дагестан',
    'texas': 'Техас',
    'oklahoma': 'Оклахома',
  };

  static const categories = [
    _CategoryOption(
      id: 'famous_people',
      title: 'Известные личности',
      subtitle: 'Выдающиеся люди, биографии и достижения',
      icon: Icons.person_rounded,
    ),
    _CategoryOption(
      id: 'history',
      title: 'История',
      subtitle: 'Ключевые события, даты и факты',
      icon: Icons.history_edu_rounded,
    ),
    _CategoryOption(
      id: 'movies',
      title: 'Фильмы',
      subtitle: 'Кино, режиссёры и знаковые сцены',
      icon: Icons.movie_rounded,
    ),
    _CategoryOption(
      id: 'music',
      title: 'Музыка',
      subtitle: 'Жанры, исполнители и популярные треки',
      icon: Icons.music_note_rounded,
    ),
  ];

  void _openQuiz(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          country: country,
          region: region,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countryName = countryNames[country] ?? country.toUpperCase();
    final regionName = region == null ? null : regionNames[region!] ?? region;
    final locationTitle = regionName ?? countryName;
    final locationSubtitle =
        regionName == null ? 'Страна целиком' : 'Страна: $countryName';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Выбор категории'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.secondaryContainer.withValues(alpha: 0.62),
              colorScheme.surface,
              colorScheme.primaryContainer.withValues(alpha: 0.35),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
            children: [
              _CategoryHeader(
                locationTitle: locationTitle,
                locationSubtitle: locationSubtitle,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 14),
              ...categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final iconColor = _cardColor(index, colorScheme);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CategoryCard(
                    title: category.title,
                    subtitle: category.subtitle,
                    icon: category.icon,
                    iconColor: iconColor,
                    onTap: () => _openQuiz(context, category.id),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color _cardColor(int index, ColorScheme colorScheme) {
    switch (index % 4) {
      case 0:
        return colorScheme.primary;
      case 1:
        return colorScheme.secondary;
      case 2:
        return colorScheme.tertiary;
      default:
        return colorScheme.error;
    }
  }
}

class _CategoryHeader extends StatelessWidget {
  final String locationTitle;
  final String locationSubtitle;
  final ColorScheme colorScheme;

  const _CategoryHeader({
    required this.locationTitle,
    required this.locationSubtitle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary.withValues(alpha: 0.92),
            colorScheme.primary.withValues(alpha: 0.84),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите категорию',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            locationTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            locationSubtitle,
            style: const TextStyle(
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
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
                  color: iconColor.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: iconColor),
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
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const _CategoryOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
