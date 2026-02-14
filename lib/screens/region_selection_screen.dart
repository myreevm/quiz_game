import 'package:flutter/material.dart';

import 'category_selection_screen.dart';

class RegionSelectionScreen extends StatelessWidget {
  final String country;

  const RegionSelectionScreen({super.key, required this.country});

  static const countryNames = {
    'russia': 'Россия',
    'usa': 'США',
    'china': 'Китай',
    'poland': 'Польша',
    'france': 'Франция',
  };

  static const regionsByCountry = {
    'russia': [
      _RegionOption(
        code: 'yakutia',
        title: 'Якутия',
        subtitle: 'Северный регион с богатой историей',
        icon: Icons.ac_unit_rounded,
      ),
      _RegionOption(
        code: 'dagestan',
        title: 'Дагестан',
        subtitle: 'Культура, традиции и известные события',
        icon: Icons.terrain_rounded,
      ),
    ],
    'usa': [
      _RegionOption(
        code: 'texas',
        title: 'Техас',
        subtitle: 'История и культура одного из крупнейших штатов',
        icon: Icons.landscape_rounded,
      ),
      _RegionOption(
        code: 'oklahoma',
        title: 'Оклахома',
        subtitle: 'Факты о музыке, кино и прошлом штата',
        icon: Icons.location_city_rounded,
      ),
    ],
  };

  void _openCategories(BuildContext context, String? region) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySelectionScreen(
          country: country,
          region: region,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countryName = countryNames[country] ?? country.toUpperCase();
    final regions = regionsByCountry[country] ?? const <_RegionOption>[];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Выбор региона'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.62),
              colorScheme.surface,
              colorScheme.tertiaryContainer.withValues(alpha: 0.35),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
            children: [
              _RegionHeader(
                countryName: countryName,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 14),
              _RegionCard(
                title: 'Вся страна',
                subtitle: 'Вопросы без выбора конкретного региона',
                icon: Icons.map_rounded,
                color: colorScheme.primary,
                onTap: () => _openCategories(context, null),
              ),
              const SizedBox(height: 10),
              ...regions.map(
                (region) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RegionCard(
                    title: region.title,
                    subtitle: region.subtitle,
                    icon: region.icon,
                    color: colorScheme.secondary,
                    onTap: () => _openCategories(context, region.code),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionHeader extends StatelessWidget {
  final String countryName;
  final ColorScheme colorScheme;

  const _RegionHeader({
    required this.countryName,
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
            colorScheme.primary.withValues(alpha: 0.92),
            colorScheme.tertiary.withValues(alpha: 0.84),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите регион',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Страна: $countryName',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Можно играть как по всей стране, так и по отдельным регионам.',
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

class _RegionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RegionCard({
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
                  color: color.withValues(alpha: 0.14),
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
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionOption {
  final String code;
  final String title;
  final String subtitle;
  final IconData icon;

  const _RegionOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
