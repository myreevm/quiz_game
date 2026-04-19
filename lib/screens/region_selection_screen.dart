import 'package:flutter/material.dart';

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
      _RegionOption(code: 'adygea'),
      _RegionOption(code: 'bashkortostan'),
      _RegionOption(code: 'altai'),
      _RegionOption(code: 'buryatia'),
      _RegionOption(code: 'kalmykia'),
      _RegionOption(code: 'kabardino_balkaria'),
      _RegionOption(code: 'ingushetia'),
      _RegionOption(code: 'kamchatka'),
      _RegionOption(code: 'mari_el'),
      _RegionOption(code: 'komi'),
      _RegionOption(code: 'karelia'),
      _RegionOption(code: 'karachay_cherkessia'),
      _RegionOption(code: 'tuva'),
      _RegionOption(code: 'tatarstan'),
      _RegionOption(code: 'north_ossetia'),
      _RegionOption(code: 'mordovia'),
      _RegionOption(code: 'chuvashia'),
      _RegionOption(code: 'chechnya'),
      _RegionOption(code: 'khakassia'),
      _RegionOption(code: 'udmurtia'),
      _RegionOption(code: 'krasnoyarsk_krai'),
      _RegionOption(code: 'krasnodar_krai'),
      _RegionOption(code: 'zabaykalsky_krai'),
      _RegionOption(code: 'altai_krai'),
    ],
    'usa': [
      _RegionOption(code: 'texas'),
      _RegionOption(code: 'oklahoma'),
      _RegionOption(code: 'alaska'),
      _RegionOption(code: 'alabama'),
      _RegionOption(code: 'iowa'),
      _RegionOption(code: 'idaho'),
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

  List<MapPinData> _mapPinsForCountry() {
    switch (country) {
      case 'russia':
        return const [
          MapPinData(code: 'all', position: Offset(0.46, 0.25)),
          MapPinData(code: 'yakutia', position: Offset(0.65, 0.30)),
          MapPinData(code: 'dagestan', position: Offset(0.12, 0.48)),
          MapPinData(code: 'adygea', position: Offset(0.08, 0.47)),
          MapPinData(code: 'bashkortostan', position: Offset(0.31, 0.37)),
          MapPinData(code: 'altai', position: Offset(0.44, 0.42)),
          MapPinData(code: 'buryatia', position: Offset(0.56, 0.36)),
          MapPinData(code: 'kalmykia', position: Offset(0.17, 0.52)),
          MapPinData(
            code: 'kabardino_balkaria',
            position: Offset(0.10, 0.44),
          ),
          MapPinData(code: 'ingushetia', position: Offset(0.14, 0.45)),
          MapPinData(code: 'kamchatka', position: Offset(0.84, 0.31)),
          MapPinData(code: 'mari_el', position: Offset(0.26, 0.33)),
          MapPinData(code: 'komi', position: Offset(0.28, 0.24)),
          MapPinData(code: 'karelia', position: Offset(0.18, 0.22)),
          MapPinData(
            code: 'karachay_cherkessia',
            position: Offset(0.09, 0.42),
          ),
          MapPinData(code: 'tuva', position: Offset(0.50, 0.44)),
          MapPinData(code: 'tatarstan', position: Offset(0.28, 0.35)),
          MapPinData(code: 'north_ossetia', position: Offset(0.11, 0.46)),
          MapPinData(code: 'mordovia', position: Offset(0.23, 0.36)),
          MapPinData(code: 'chuvashia', position: Offset(0.24, 0.33)),
          MapPinData(code: 'chechnya', position: Offset(0.16, 0.47)),
          MapPinData(code: 'khakassia', position: Offset(0.52, 0.39)),
          MapPinData(code: 'udmurtia', position: Offset(0.33, 0.31)),
          MapPinData(code: 'krasnoyarsk_krai', position: Offset(0.54, 0.32)),
          MapPinData(code: 'krasnodar_krai', position: Offset(0.07, 0.50)),
          MapPinData(code: 'zabaykalsky_krai', position: Offset(0.61, 0.39)),
          MapPinData(code: 'altai_krai', position: Offset(0.41, 0.45)),
        ];
      case 'usa':
        return const [
          MapPinData(code: 'all', position: Offset(0.24, 0.30)),
          MapPinData(code: 'texas', position: Offset(0.49, 0.50)),
          MapPinData(code: 'oklahoma', position: Offset(0.48, 0.40)),
          MapPinData(code: 'alaska', position: Offset(0.12, 0.76)),
          MapPinData(code: 'alabama', position: Offset(0.62, 0.57)),
          MapPinData(code: 'iowa', position: Offset(0.56, 0.34)),
          MapPinData(code: 'idaho', position: Offset(0.36, 0.30)),
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
                countryCode: country,
                countryName: countryName,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 14),
              RegionSelectionMap(
                country: country,
                hint: texts.regionMapHint,
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
  final String countryCode;
  final String countryName;
  final ColorScheme colorScheme;

  const _RegionHeader({
    required this.texts,
    required this.countryCode,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlagBadge(
            key: const ValueKey('region-header-country-flag'),
            code: countryCode,
            width: 54,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
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
