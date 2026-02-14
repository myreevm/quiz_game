import 'dart:math';

import 'package:flutter/material.dart';

import '../services/question_service.dart';
import 'quiz_screen.dart';
import 'region_selection_screen.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  static const countries = [
    _CountryOption(
      code: 'russia',
      title: 'Россия',
      subtitle: 'Вопросы по стране и регионам',
      icon: Icons.public_rounded,
    ),
    _CountryOption(
      code: 'usa',
      title: 'США',
      subtitle: 'Категории по США и штатам',
      icon: Icons.flag_rounded,
    ),
    _CountryOption(
      code: 'china',
      title: 'Китай',
      subtitle: 'История, культура и современные факты',
      icon: Icons.temple_buddhist_rounded,
    ),
    _CountryOption(
      code: 'poland',
      title: 'Польша',
      subtitle: 'Вопросы по Польше и её известным людям',
      icon: Icons.account_balance_rounded,
    ),
    _CountryOption(
      code: 'france',
      title: 'Франция',
      subtitle: 'Французская история, кино, музыка и личности',
      icon: Icons.park_rounded,
    ),
  ];

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  static const Map<String, List<String>> _regionsByCountry = {
    'russia': <String>['yakutia', 'dagestan'],
    'usa': <String>['texas', 'oklahoma'],
    'china': <String>['all'],
    'poland': <String>['all'],
    'france': <String>['all'],
  };

  static const List<String> _categories = [
    'famous_people',
    'history',
    'movies',
    'music',
  ];

  static const Map<String, String> _countryNames = {
    'russia': 'Россия',
    'usa': 'США',
    'china': 'Китай',
    'poland': 'Польша',
    'france': 'Франция',
  };

  static const Map<String, String> _regionNames = {
    'all': 'Вся страна',
    'yakutia': 'Якутия',
    'dagestan': 'Дагестан',
    'texas': 'Техас',
    'oklahoma': 'Оклахома',
  };

  static const Map<String, String> _categoryNames = {
    'famous_people': 'Известные личности',
    'history': 'История',
    'movies': 'Фильмы',
    'music': 'Музыка',
  };

  bool _isQuickGameLoading = false;
  List<_QuickGameRoute>? _cachedQuickGameRoutes;

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

    if (routes.isEmpty) {
      setState(() {
        _isQuickGameLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось найти вопросы для быстрой игры.'),
        ),
      );
      return;
    }

    final selectedRoute = routes[Random().nextInt(routes.length)];
    setState(() {
      _isQuickGameLoading = false;
    });

    final regionText =
        _regionNames[selectedRoute.region] ?? selectedRoute.region;
    final categoryText =
        _categoryNames[selectedRoute.category] ?? selectedRoute.category;
    final countryText =
        _countryNames[selectedRoute.country] ?? selectedRoute.country;
    final selectedRegion =
        selectedRoute.region == 'all' ? null : selectedRoute.region;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          'Быстрая игра: $countryText, $regionText, $categoryText',
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Выбор страны'),
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
                isLoading: _isQuickGameLoading,
                onPressed: _startQuickGame,
              ),
              const SizedBox(height: 12),
              _HeaderCard(colorScheme: colorScheme),
              const SizedBox(height: 14),
              ...CountrySelectionScreen.countries.map(
                (country) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CountryCard(
                    title: country.title,
                    subtitle: country.subtitle,
                    icon: country.icon,
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
  final bool isLoading;
  final VoidCallback onPressed;

  const _QuickPlayButton({
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
        isLoading ? 'Подбор случайной игры...' : 'Быстрая игра',
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeaderCard({required this.colorScheme});

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'С чего начнем?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Выберите страну, затем регион и категорию. Либо нажмите "Быстрая игра", чтобы сразу запустить случайный раунд.',
            style: TextStyle(
              color: Colors.white,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CountryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
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
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: colorScheme.primary),
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

class _CountryOption {
  final String code;
  final String title;
  final String subtitle;
  final IconData icon;

  const _CountryOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.icon,
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
