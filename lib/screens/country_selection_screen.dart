import 'dart:math';

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/app_texts.dart';
import '../services/question_service.dart';
import 'flag_badge.dart';
import 'quiz_screen.dart';
import 'region_selection_screen.dart';
import 'selection_maps.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  static const countries = [
    _CountryOption(code: 'russia'),
    _CountryOption(code: 'usa'),
    _CountryOption(code: 'canada'),
    _CountryOption(code: 'mexico'),
    _CountryOption(code: 'china'),
    _CountryOption(code: 'japan'),
    _CountryOption(code: 'vietnam'),
    _CountryOption(code: 'poland'),
    _CountryOption(code: 'france'),
    _CountryOption(code: 'australia'),
    _CountryOption(code: 'egypt'),
    _CountryOption(code: 'brazil'),
    _CountryOption(code: 'uk'),
    _CountryOption(code: 'belarus'),
    _CountryOption(code: 'argentina'),
    _CountryOption(code: 'turkey'),
    _CountryOption(code: 'south_africa'),
    _CountryOption(code: 'italy'),
    _CountryOption(code: 'germany'),
    _CountryOption(code: 'switzerland'),
    _CountryOption(code: 'spain'),
    _CountryOption(code: 'south_korea'),
    _CountryOption(code: 'new_zealand'),
  ];

  static const mapPins = [
    MapPinData(code: 'canada', position: Offset(0.23, 0.18)),
    MapPinData(code: 'usa', position: Offset(0.24, 0.29)),
    MapPinData(code: 'mexico', position: Offset(0.22, 0.38)),
    MapPinData(code: 'brazil', position: Offset(0.36, 0.55)),
    MapPinData(code: 'uk', position: Offset(0.47, 0.20)),
    MapPinData(code: 'france', position: Offset(0.51, 0.24)),
    MapPinData(code: 'italy', position: Offset(0.53, 0.28)),
    MapPinData(code: 'spain', position: Offset(0.45, 0.29)),
    MapPinData(code: 'germany', position: Offset(0.54, 0.22)),
    MapPinData(code: 'switzerland', position: Offset(0.53, 0.25)),
    MapPinData(code: 'poland', position: Offset(0.55, 0.21)),
    MapPinData(code: 'belarus', position: Offset(0.58, 0.20)),
    MapPinData(code: 'turkey', position: Offset(0.60, 0.30)),
    MapPinData(code: 'egypt', position: Offset(0.58, 0.34)),
    MapPinData(code: 'russia', position: Offset(0.75, 0.15)),
    MapPinData(code: 'china', position: Offset(0.79, 0.32)),
    MapPinData(code: 'vietnam', position: Offset(0.79, 0.42)),
    MapPinData(code: 'south_korea', position: Offset(0.86, 0.29)),
    MapPinData(code: 'japan', position: Offset(0.88, 0.30)),
    MapPinData(code: 'australia', position: Offset(0.86, 0.64)),
    MapPinData(code: 'argentina', position: Offset(0.34, 0.75)),
    MapPinData(code: 'south_africa', position: Offset(0.58, 0.68)),
    MapPinData(code: 'new_zealand', position: Offset(0.92, 0.77)),
  ];

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  static const Map<String, double> _countryAreaKm2 = {
    'russia': 17098246,
    'canada': 9984670,
    'usa': 9833517,
    'china': 9596961,
    'brazil': 8515767,
    'australia': 7692024,
    'argentina': 2780400,
    'mexico': 1964375,
    'south_africa': 1221037,
    'egypt': 1002450,
    'turkey': 783562,
    'germany': 357588,
    'france': 551695,
    'spain': 505990,
    'japan': 377975,
    'vietnam': 331212,
    'poland': 312696,
    'italy': 301340,
    'new_zealand': 268838,
    'uk': 243610,
    'belarus': 207600,
    'south_korea': 100210,
    'switzerland': 41285,
  };

  static const Map<String, List<String>> _regionsByCountry = {
    'russia': <String>['yakutia', 'dagestan'],
    'usa': <String>['texas', 'oklahoma'],
    'canada': <String>['all'],
    'mexico': <String>['all'],
    'china': <String>['all'],
    'japan': <String>['all'],
    'vietnam': <String>['all'],
    'poland': <String>['all'],
    'france': <String>['all'],
    'australia': <String>['all'],
    'egypt': <String>['all'],
    'brazil': <String>['all'],
    'uk': <String>['all'],
    'belarus': <String>['all'],
    'argentina': <String>['all'],
    'turkey': <String>['all'],
    'south_africa': <String>['all'],
    'italy': <String>['all'],
    'germany': <String>['all'],
    'switzerland': <String>['all'],
    'spain': <String>['all'],
    'south_korea': <String>['all'],
    'new_zealand': <String>['all'],
  };

  static const List<String> _categories = [
    'famous_people',
    'history',
    'movies',
    'music',
  ];

  bool _isQuickGameLoading = false;
  List<_QuickGameRoute>? _cachedQuickGameRoutes;
  _CountrySortMode _sortMode = _CountrySortMode.alphabet;

  void _openRegions(BuildContext context, String country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegionSelectionScreen(country: country),
      ),
    );
  }

  Future<void> _startQuickGame() async {
    if (_isQuickGameLoading) {
      return;
    }

    setState(() {
      _isQuickGameLoading = true;
    });

    final routes = await _loadQuickGameRoutes();
    if (!mounted) {
      return;
    }

    final texts = AppTexts.of(context);
    if (routes.isEmpty) {
      setState(() {
        _isQuickGameLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texts.quickGameNoQuestions),
        ),
      );
      return;
    }

    final selectedRoute = routes[Random().nextInt(routes.length)];
    setState(() {
      _isQuickGameLoading = false;
    });

    final countryText = texts.countryName(selectedRoute.country);
    final regionText = texts.regionName(selectedRoute.region);
    final categoryText = texts.categoryName(selectedRoute.category);
    final selectedRegion =
        selectedRoute.region == 'all' ? null : selectedRoute.region;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          texts.quickGameStarted(
            country: countryText,
            region: regionText,
            category: categoryText,
          ),
        ),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          country: selectedRoute.country,
          region: selectedRegion,
          category: selectedRoute.category,
        ),
      ),
    );
  }

  Future<List<_QuickGameRoute>> _loadQuickGameRoutes() async {
    final cached = _cachedQuickGameRoutes;
    if (cached != null) {
      return cached;
    }

    final language = AppSettingsScope.of(context).settings.appLanguage;
    final validRoutes = <_QuickGameRoute>[];

    for (final country in CountrySelectionScreen.countries) {
      final regions = _regionsByCountry[country.code] ?? const <String>[];

      for (final region in regions) {
        final selectedRegion = region == 'all' ? null : region;

        for (final category in _categories) {
          final questions = await QuestionService.loadQuestions(
            country: country.code,
            region: selectedRegion,
            category: category,
            language: language,
          );

          if (questions.isEmpty) {
            continue;
          }

          validRoutes.add(
            _QuickGameRoute(
              country: country.code,
              region: region,
              category: category,
            ),
          );
        }
      }
    }

    _cachedQuickGameRoutes = validRoutes;
    return validRoutes;
  }

  List<_CountryOption> _sortedCountries(AppTexts texts) {
    final countries = [...CountrySelectionScreen.countries];

    if (_sortMode == _CountrySortMode.alphabet) {
      countries.sort(
        (a, b) =>
            texts.countryName(a.code).compareTo(texts.countryName(b.code)),
      );
    } else {
      countries.sort((a, b) {
        final aArea = _countryAreaKm2[a.code] ?? 0;
        final bArea = _countryAreaKm2[b.code] ?? 0;
        return bArea.compareTo(aArea);
      });
    }

    return countries;
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(texts.countrySelectionTitle),
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
              colorScheme.secondaryContainer.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
            children: [
              _QuickPlayButton(
                texts: texts,
                isLoading: _isQuickGameLoading,
                onPressed: _startQuickGame,
              ),
              const SizedBox(height: 12),
              _HeaderCard(
                texts: texts,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 14),
              WorldSelectionMap(
                hint: texts.countryMapHint,
                countries: CountrySelectionScreen.mapPins,
                labelBuilder: texts.countryName,
                onTap: (code) => _openRegions(context, code),
              ),
              const SizedBox(height: 14),
              _CountrySortControls(
                texts: texts,
                mode: _sortMode,
                onChanged: (mode) {
                  if (mode == null) {
                    return;
                  }
                  setState(() {
                    _sortMode = mode;
                  });
                },
              ),
              const SizedBox(height: 12),
              ..._sortedCountries(texts).map(
                (country) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CountryCard(
                    flagCode: country.code,
                    title: texts.countryName(country.code),
                    subtitle: texts.countrySelectionSubtitle(country.code),
                    onTap: () => _openRegions(context, country.code),
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

class _QuickPlayButton extends StatelessWidget {
  final AppTexts texts;
  final bool isLoading;
  final VoidCallback onPressed;

  const _QuickPlayButton({
    required this.texts,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          : const Icon(Icons.bolt_rounded),
      label: Text(
        isLoading ? texts.quickGameLoadingTitle : texts.quickGameTitle,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final AppTexts texts;
  final ColorScheme colorScheme;

  const _HeaderCard({
    required this.texts,
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
            colorScheme.secondary.withValues(alpha: 0.84),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.countrySelectionHeaderTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texts.countrySelectionHeaderDescription,
            style: const TextStyle(
              color: Colors.white,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountrySortControls extends StatelessWidget {
  final AppTexts texts;
  final _CountrySortMode mode;
  final ValueChanged<_CountrySortMode?> onChanged;

  const _CountrySortControls({
    required this.texts,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            texts.countrySortLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<_CountrySortMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<_CountrySortMode>(
              value: _CountrySortMode.alphabet,
              icon: const Icon(Icons.sort_by_alpha_rounded),
              label: Text(texts.countrySortAlphabet),
            ),
            ButtonSegment<_CountrySortMode>(
              value: _CountrySortMode.area,
              icon: const Icon(Icons.public_rounded),
              label: Text(texts.countrySortArea),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (selected) {
            onChanged(selected.isEmpty ? null : selected.first);
          },
        ),
      ],
    );
  }
}

class _CountryCard extends StatelessWidget {
  final String flagCode;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CountryCard({
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

class _CountryOption {
  final String code;

  const _CountryOption({
    required this.code,
  });
}

class _QuickGameRoute {
  final String country;
  final String region;
  final String category;

  const _QuickGameRoute({
    required this.country,
    required this.region,
    required this.category,
  });
}

enum _CountrySortMode {
  alphabet,
  area,
}
