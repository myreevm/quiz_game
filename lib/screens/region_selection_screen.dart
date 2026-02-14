import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/app_texts.dart';
import 'category_selection_screen.dart';
import 'flag_badge.dart';
import 'selection_maps.dart';

class RegionSelectionScreen extends StatelessWidget {
  final String country;

  const RegionSelectionScreen({super.key, required this.country});

  static const regionsByCountry = {
    'russia': [
      _RegionOption(code: 'yakutia'),
      _RegionOption(code: 'dagestan'),
    ],
    'usa': [
      _RegionOption(code: 'texas'),
      _RegionOption(code: 'oklahoma'),
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

  String _mapHint(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'Tap a region on the map';
      case AppLanguage.russian:
        return 'Нажмите на регион на карте';
      case AppLanguage.yakut:
        return 'Картаҕа региону баттаа';
    }
  }

  List<MapPinData> _mapPinsForCountry() {
    switch (country) {
      case 'russia':
        return const [
          MapPinData(code: 'all', position: Offset(0.46, 0.25)),
          MapPinData(code: 'yakutia', position: Offset(0.72, 0.46)),
          MapPinData(code: 'dagestan', position: Offset(0.30, 0.62)),
        ];
      case 'usa':
        return const [
          MapPinData(code: 'all', position: Offset(0.46, 0.28)),
          MapPinData(code: 'texas', position: Offset(0.44, 0.58)),
          MapPinData(code: 'oklahoma', position: Offset(0.48, 0.46)),
        ];
      default:
        return const [
          MapPinData(code: 'all', position: Offset(0.50, 0.50)),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final countryName = texts.countryName(country);
    final regions = regionsByCountry[country] ?? const <_RegionOption>[];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(texts.regionSelectionTitle),
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
                texts: texts,
                countryName: countryName,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 14),
              RegionSelectionMap(
                country: country,
                hint: _mapHint(texts.language),
                regions: _mapPinsForCountry(),
                labelBuilder: texts.regionName,
                onTap: (code) =>
                    _openCategories(context, code == 'all' ? null : code),
              ),
              const SizedBox(height: 14),
              _RegionCard(
                flagCode: 'all',
                title: texts.regionAllCountryTitle,
                subtitle: texts.regionAllCountrySubtitle,
                onTap: () => _openCategories(context, null),
              ),
              const SizedBox(height: 10),
              ...regions.map(
                (region) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RegionCard(
                    flagCode: region.code,
                    title: texts.regionName(region.code),
                    subtitle: texts.regionSubtitle(
                      country: country,
                      region: region.code,
                    ),
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
  final AppTexts texts;
  final String countryName;
  final ColorScheme colorScheme;

  const _RegionHeader({
    required this.texts,
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
          Text(
            texts.regionSelectionHeaderTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texts.regionSelectionCountryLabel(countryName),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            texts.regionSelectionHeaderDescription,
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

class _RegionCard extends StatelessWidget {
  final String flagCode;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RegionCard({
    required this.flagCode,
    required this.title,
    required this.subtitle,
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
              FlagBadge(code: flagCode),
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

  const _RegionOption({
    required this.code,
  });
}
