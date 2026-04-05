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
    _CountryOption(code: 'kazakhstan'),
    _CountryOption(code: 'japan'),
    _CountryOption(code: 'uzbekistan'),
    _CountryOption(code: 'kyrgyzstan'),
    _CountryOption(code: 'tajikistan'),
    _CountryOption(code: 'vietnam'),
    _CountryOption(code: 'malaysia'),
    _CountryOption(code: 'singapore'),
    _CountryOption(code: 'indonesia'),
    _CountryOption(code: 'papua_new_guinea'),
    _CountryOption(code: 'india'),
    _CountryOption(code: 'myanmar'),
    _CountryOption(code: 'laos'),
    _CountryOption(code: 'thailand'),
    _CountryOption(code: 'tunisia'),
    _CountryOption(code: 'morocco'),
    _CountryOption(code: 'libya'),
    _CountryOption(code: 'algeria'),
    _CountryOption(code: 'mongolia'),
    _CountryOption(code: 'azerbaijan'),
    _CountryOption(code: 'armenia'),
    _CountryOption(code: 'georgia'),
    _CountryOption(code: 'poland'),
    _CountryOption(code: 'france'),
    _CountryOption(code: 'czechia'),
    _CountryOption(code: 'slovakia'),
    _CountryOption(code: 'hungary'),
    _CountryOption(code: 'serbia'),
    _CountryOption(code: 'bosnia_and_herzegovina'),
    _CountryOption(code: 'albania'),
    _CountryOption(code: 'montenegro'),
    _CountryOption(code: 'norway'),
    _CountryOption(code: 'sweden'),
    _CountryOption(code: 'finland'),
    _CountryOption(code: 'iceland'),
    _CountryOption(code: 'romania'),
    _CountryOption(code: 'bulgaria'),
    _CountryOption(code: 'greece'),
    _CountryOption(code: 'portugal'),
    _CountryOption(code: 'austria'),
    _CountryOption(code: 'slovenia'),
    _CountryOption(code: 'croatia'),
    _CountryOption(code: 'australia'),
    _CountryOption(code: 'egypt'),
    _CountryOption(code: 'brazil'),
    _CountryOption(code: 'bolivia'),
    _CountryOption(code: 'cuba'),
    _CountryOption(code: 'panama'),
    _CountryOption(code: 'ecuador'),
    _CountryOption(code: 'colombia'),
    _CountryOption(code: 'el_salvador'),
    _CountryOption(code: 'nicaragua'),
    _CountryOption(code: 'guatemala'),
    _CountryOption(code: 'haiti'),
    _CountryOption(code: 'bhutan'),
    _CountryOption(code: 'philippines'),
    _CountryOption(code: 'maldives'),
    _CountryOption(code: 'sri_lanka'),
    _CountryOption(code: 'uk'),
    _CountryOption(code: 'belarus'),
    _CountryOption(code: 'estonia'),
    _CountryOption(code: 'latvia'),
    _CountryOption(code: 'lithuania'),
    _CountryOption(code: 'moldova'),
    _CountryOption(code: 'uae'),
    _CountryOption(code: 'bahrain'),
    _CountryOption(code: 'qatar'),
    _CountryOption(code: 'saudi_arabia'),
    _CountryOption(code: 'belgium'),
    _CountryOption(code: 'denmark'),
    _CountryOption(code: 'ireland'),
    _CountryOption(code: 'netherlands'),
    _CountryOption(code: 'malta'),
    _CountryOption(code: 'monaco'),
    _CountryOption(code: 'liechtenstein'),
    _CountryOption(code: 'luxembourg'),
    _CountryOption(code: 'dr_congo'),
    _CountryOption(code: 'congo_republic'),
    _CountryOption(code: 'zambia'),
    _CountryOption(code: 'namibia'),
    _CountryOption(code: 'cambodia'),
    _CountryOption(code: 'madagascar'),
    _CountryOption(code: 'turkmenistan'),
    _CountryOption(code: 'oman'),
    _CountryOption(code: 'mali'),
    _CountryOption(code: 'mauritania'),
    _CountryOption(code: 'kuwait'),
    _CountryOption(code: 'angola'),
    _CountryOption(code: 'nigeria'),
    _CountryOption(code: 'nepal'),
    _CountryOption(code: 'uruguay'),
    _CountryOption(code: 'north_macedonia'),
    _CountryOption(code: 'samoa'),
    _CountryOption(code: 'mozambique'),
    _CountryOption(code: 'nauru'),
    _CountryOption(code: 'niger'),
    _CountryOption(code: 'chad'),
    _CountryOption(code: 'tuvalu'),
    _CountryOption(code: 'micronesia'),
    _CountryOption(code: 'mauritius'),
    _CountryOption(code: 'argentina'),
    _CountryOption(code: 'chile'),
    _CountryOption(code: 'paraguay'),
    _CountryOption(code: 'peru'),
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
    MapPinData(code: 'uk', position: Offset(0.49, 0.20)),
    MapPinData(code: 'ireland', position: Offset(0.472, 0.217)),
    MapPinData(code: 'iceland', position: Offset(0.445, 0.145)),
    MapPinData(code: 'norway', position: Offset(0.521, 0.17)),
    MapPinData(code: 'sweden', position: Offset(0.541, 0.17)),
    MapPinData(code: 'finland', position: Offset(0.57, 0.16)),
    MapPinData(code: 'estonia', position: Offset(0.569, 0.185)),
    MapPinData(code: 'latvia', position: Offset(0.568, 0.201)),
    MapPinData(code: 'lithuania', position: Offset(0.565, 0.219)),
    MapPinData(code: 'denmark', position: Offset(0.545, 0.191)),
    MapPinData(code: 'france', position: Offset(0.505, 0.245)),
    MapPinData(code: 'italy', position: Offset(0.535, 0.27)),
    MapPinData(code: 'spain', position: Offset(0.49, 0.28)),
    MapPinData(code: 'portugal', position: Offset(0.475, 0.287)),
    MapPinData(code: 'belgium', position: Offset(0.516, 0.235)),
    MapPinData(code: 'netherlands', position: Offset(0.525, 0.212)),
    MapPinData(code: 'luxembourg', position: Offset(0.519, 0.228)),
    MapPinData(code: 'liechtenstein', position: Offset(0.533, 0.252)),
    MapPinData(code: 'monaco', position: Offset(0.528, 0.263)),
    MapPinData(code: 'germany', position: Offset(0.53, 0.22)),
    MapPinData(code: 'switzerland', position: Offset(0.522, 0.25)),
    MapPinData(code: 'poland', position: Offset(0.55, 0.215)),
    MapPinData(code: 'czechia', position: Offset(0.543, 0.235)),
    MapPinData(code: 'austria', position: Offset(0.54, 0.245)),
    MapPinData(code: 'slovakia', position: Offset(0.555, 0.24)),
    MapPinData(code: 'slovenia', position: Offset(0.541, 0.254)),
    MapPinData(code: 'hungary', position: Offset(0.554, 0.246)),
    MapPinData(code: 'croatia', position: Offset(0.545, 0.255)),
    MapPinData(code: 'serbia', position: Offset(0.558, 0.267)),
    MapPinData(code: 'bosnia_and_herzegovina', position: Offset(0.55, 0.267)),
    MapPinData(code: 'montenegro', position: Offset(0.553, 0.274)),
    MapPinData(code: 'albania', position: Offset(0.554, 0.28)),
    MapPinData(code: 'belarus', position: Offset(0.58, 0.21)),
    MapPinData(code: 'moldova', position: Offset(0.582, 0.259)),
    MapPinData(code: 'romania', position: Offset(0.57, 0.25)),
    MapPinData(code: 'bulgaria', position: Offset(0.569, 0.273)),
    MapPinData(code: 'greece', position: Offset(0.563, 0.297)),
    MapPinData(code: 'north_macedonia', position: Offset(0.561, 0.284)),
    MapPinData(code: 'turkey', position: Offset(0.595, 0.29)),
    MapPinData(code: 'georgia', position: Offset(0.62, 0.275)),
    MapPinData(code: 'armenia', position: Offset(0.623, 0.285)),
    MapPinData(code: 'azerbaijan', position: Offset(0.63, 0.282)),
    MapPinData(code: 'morocco', position: Offset(0.47, 0.34)),
    MapPinData(code: 'mauritania', position: Offset(0.458, 0.389)),
    MapPinData(code: 'mali', position: Offset(0.497, 0.418)),
    MapPinData(code: 'niger', position: Offset(0.533, 0.401)),
    MapPinData(code: 'chad', position: Offset(0.557, 0.421)),
    MapPinData(code: 'nigeria', position: Offset(0.533, 0.454)),
    MapPinData(code: 'algeria', position: Offset(0.51, 0.35)),
    MapPinData(code: 'tunisia', position: Offset(0.525, 0.32)),
    MapPinData(code: 'libya', position: Offset(0.55, 0.35)),
    MapPinData(code: 'egypt', position: Offset(0.58, 0.35)),
    MapPinData(code: 'malta', position: Offset(0.547, 0.324)),
    MapPinData(code: 'congo_republic', position: Offset(0.571, 0.476)),
    MapPinData(code: 'dr_congo', position: Offset(0.589, 0.500)),
    MapPinData(code: 'zambia', position: Offset(0.582, 0.560)),
    MapPinData(code: 'namibia', position: Offset(0.545, 0.608)),
    MapPinData(code: 'angola', position: Offset(0.565, 0.566)),
    MapPinData(code: 'mozambique', position: Offset(0.607, 0.592)),
    MapPinData(code: 'madagascar', position: Offset(0.629, 0.607)),
    MapPinData(code: 'mauritius', position: Offset(0.666, 0.621)),
    MapPinData(code: 'saudi_arabia', position: Offset(0.629, 0.367)),
    MapPinData(code: 'qatar', position: Offset(0.648, 0.352)),
    MapPinData(code: 'bahrain', position: Offset(0.642, 0.349)),
    MapPinData(code: 'kuwait', position: Offset(0.633, 0.336)),
    MapPinData(code: 'uae', position: Offset(0.666, 0.359)),
    MapPinData(code: 'oman', position: Offset(0.681, 0.382)),
    MapPinData(code: 'russia', position: Offset(0.75, 0.15)),
    MapPinData(code: 'china', position: Offset(0.79, 0.32)),
    MapPinData(code: 'kazakhstan', position: Offset(0.69, 0.247)),
    MapPinData(code: 'turkmenistan', position: Offset(0.654, 0.295)),
    MapPinData(code: 'uzbekistan', position: Offset(0.67, 0.27)),
    MapPinData(code: 'kyrgyzstan', position: Offset(0.71, 0.272)),
    MapPinData(code: 'tajikistan', position: Offset(0.696, 0.29)),
    MapPinData(code: 'mongolia', position: Offset(0.785, 0.25)),
    MapPinData(code: 'india', position: Offset(0.71, 0.4)),
    MapPinData(code: 'nepal', position: Offset(0.736, 0.358)),
    MapPinData(code: 'bhutan', position: Offset(0.748, 0.351)),
    MapPinData(code: 'myanmar', position: Offset(0.76, 0.39)),
    MapPinData(code: 'laos', position: Offset(0.78, 0.39)),
    MapPinData(code: 'cambodia', position: Offset(0.787, 0.439)),
    MapPinData(code: 'thailand', position: Offset(0.778, 0.419)),
    MapPinData(code: 'philippines', position: Offset(0.835, 0.43)),
    MapPinData(code: 'vietnam', position: Offset(0.795, 0.423)),
    MapPinData(code: 'sri_lanka', position: Offset(0.72, 0.455)),
    MapPinData(code: 'maldives', position: Offset(0.71, 0.485)),
    MapPinData(code: 'malaysia', position: Offset(0.78, 0.474)),
    MapPinData(code: 'singapore', position: Offset(0.784, 0.49)),
    MapPinData(code: 'indonesia', position: Offset(0.84, 0.52)),
    MapPinData(code: 'papua_new_guinea', position: Offset(0.89, 0.53)),
    MapPinData(code: 'nauru', position: Offset(0.927, 0.496)),
    MapPinData(code: 'micronesia', position: Offset(0.900, 0.462)),
    MapPinData(code: 'tuvalu', position: Offset(0.955, 0.561)),
    MapPinData(code: 'samoa', position: Offset(0.972, 0.593)),
    MapPinData(code: 'south_korea', position: Offset(0.85, 0.31)),
    MapPinData(code: 'japan', position: Offset(0.88, 0.30)),
    MapPinData(code: 'australia', position: Offset(0.86, 0.64)),
    MapPinData(code: 'cuba', position: Offset(0.285, 0.382)),
    MapPinData(code: 'haiti', position: Offset(0.31, 0.398)),
    MapPinData(code: 'guatemala', position: Offset(0.252, 0.42)),
    MapPinData(code: 'el_salvador', position: Offset(0.256, 0.426)),
    MapPinData(code: 'nicaragua', position: Offset(0.267, 0.43)),
    MapPinData(code: 'panama', position: Offset(0.28, 0.455)),
    MapPinData(code: 'colombia', position: Offset(0.305, 0.48)),
    MapPinData(code: 'ecuador', position: Offset(0.286, 0.51)),
    MapPinData(code: 'peru', position: Offset(0.295, 0.56)),
    MapPinData(code: 'chile', position: Offset(0.308, 0.65)),
    MapPinData(code: 'bolivia', position: Offset(0.325, 0.582)),
    MapPinData(code: 'paraguay', position: Offset(0.342, 0.62)),
    MapPinData(code: 'uruguay', position: Offset(0.351, 0.654)),
    MapPinData(code: 'argentina', position: Offset(0.32, 0.69)),
    MapPinData(code: 'south_africa', position: Offset(0.57, 0.67)),
    MapPinData(code: 'new_zealand', position: Offset(0.97, 0.73)),
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
    'kazakhstan': 2724900,
    'mexico': 1964375,
    'peru': 1285216,
    'south_africa': 1221037,
    'colombia': 1141748,
    'bolivia': 1098581,
    'egypt': 1002450,
    'turkey': 783562,
    'chile': 756102,
    'philippines': 300000,
    'germany': 357588,
    'france': 551695,
    'paraguay': 406752,
    'ecuador': 283561,
    'nicaragua': 130373,
    'czechia': 78871,
    'sri_lanka': 65610,
    'panama': 75417,
    'slovakia': 49035,
    'bhutan': 38394,
    'guatemala': 108889,
    'hungary': 93030,
    'serbia': 88361,
    'bosnia_and_herzegovina': 51209,
    'albania': 28748,
    'montenegro': 13812,
    'norway': 385207,
    'sweden': 450295,
    'finland': 338455,
    'iceland': 103000,
    'romania': 238397,
    'bulgaria': 110994,
    'cuba': 109884,
    'greece': 131957,
    'portugal': 92090,
    'austria': 83879,
    'croatia': 56594,
    'slovenia': 20273,
    'spain': 505990,
    'japan': 377975,
    'vietnam': 331212,
    'malaysia': 330803,
    'papua_new_guinea': 462840,
    'indonesia': 1904569,
    'india': 3287263,
    'myanmar': 676578,
    'laos': 236800,
    'thailand': 513120,
    'tunisia': 163610,
    'morocco': 446550,
    'libya': 1759540,
    'algeria': 2381741,
    'mongolia': 1564116,
    'azerbaijan': 86600,
    'armenia': 29743,
    'haiti': 27750,
    'el_salvador': 21041,
    'georgia': 69700,
    'poland': 312696,
    'italy': 301340,
    'new_zealand': 268838,
    'uk': 243610,
    'belarus': 207600,
    'estonia': 45227,
    'latvia': 64589,
    'lithuania': 65300,
    'moldova': 33846,
    'uae': 83600,
    'bahrain': 765,
    'qatar': 11586,
    'saudi_arabia': 2149690,
    'belgium': 30528,
    'denmark': 43094,
    'ireland': 70273,
    'netherlands': 41543,
    'malta': 316,
    'monaco': 2.02,
    'liechtenstein': 160,
    'luxembourg': 2586,
    'dr_congo': 2344858,
    'congo_republic': 342000,
    'zambia': 752612,
    'namibia': 825615,
    'cambodia': 181035,
    'madagascar': 587041,
    'turkmenistan': 488100,
    'oman': 309500,
    'mali': 1240192,
    'mauritania': 1030700,
    'kuwait': 17818,
    'angola': 1246700,
    'nigeria': 923768,
    'nepal': 147516,
    'uruguay': 176215,
    'north_macedonia': 25713,
    'samoa': 2842,
    'mozambique': 801590,
    'nauru': 21,
    'niger': 1267000,
    'chad': 1284000,
    'tuvalu': 26,
    'micronesia': 702,
    'mauritius': 2040,
    'kyrgyzstan': 199951,
    'tajikistan': 143100,
    'uzbekistan': 448978,
    'south_korea': 100210,
    'switzerland': 41285,
    'singapore': 734,
    'maldives': 300,
  };

  static const Map<String, List<String>> _regionsByCountry = {
    'russia': <String>['yakutia', 'dagestan'],
    'usa': <String>['texas', 'oklahoma'],
    'canada': <String>['all'],
    'mexico': <String>['all'],
    'china': <String>['all'],
    'kazakhstan': <String>['all'],
    'japan': <String>['all'],
    'uzbekistan': <String>['all'],
    'kyrgyzstan': <String>['all'],
    'tajikistan': <String>['all'],
    'vietnam': <String>['all'],
    'malaysia': <String>['all'],
    'singapore': <String>['all'],
    'indonesia': <String>['all'],
    'papua_new_guinea': <String>['all'],
    'india': <String>['all'],
    'myanmar': <String>['all'],
    'laos': <String>['all'],
    'thailand': <String>['all'],
    'tunisia': <String>['all'],
    'morocco': <String>['all'],
    'libya': <String>['all'],
    'algeria': <String>['all'],
    'mongolia': <String>['all'],
    'azerbaijan': <String>['all'],
    'armenia': <String>['all'],
    'georgia': <String>['all'],
    'poland': <String>['all'],
    'france': <String>['all'],
    'czechia': <String>['all'],
    'slovakia': <String>['all'],
    'hungary': <String>['all'],
    'serbia': <String>['all'],
    'bosnia_and_herzegovina': <String>['all'],
    'albania': <String>['all'],
    'montenegro': <String>['all'],
    'norway': <String>['all'],
    'sweden': <String>['all'],
    'finland': <String>['all'],
    'iceland': <String>['all'],
    'romania': <String>['all'],
    'bulgaria': <String>['all'],
    'greece': <String>['all'],
    'portugal': <String>['all'],
    'austria': <String>['all'],
    'croatia': <String>['all'],
    'slovenia': <String>['all'],
    'australia': <String>['all'],
    'egypt': <String>['all'],
    'brazil': <String>['all'],
    'bolivia': <String>['all'],
    'cuba': <String>['all'],
    'panama': <String>['all'],
    'ecuador': <String>['all'],
    'colombia': <String>['all'],
    'el_salvador': <String>['all'],
    'nicaragua': <String>['all'],
    'guatemala': <String>['all'],
    'haiti': <String>['all'],
    'bhutan': <String>['all'],
    'philippines': <String>['all'],
    'maldives': <String>['all'],
    'sri_lanka': <String>['all'],
    'uk': <String>['all'],
    'belarus': <String>['all'],
    'estonia': <String>['all'],
    'latvia': <String>['all'],
    'lithuania': <String>['all'],
    'moldova': <String>['all'],
    'uae': <String>['all'],
    'bahrain': <String>['all'],
    'qatar': <String>['all'],
    'saudi_arabia': <String>['all'],
    'belgium': <String>['all'],
    'denmark': <String>['all'],
    'ireland': <String>['all'],
    'netherlands': <String>['all'],
    'malta': <String>['all'],
    'monaco': <String>['all'],
    'liechtenstein': <String>['all'],
    'luxembourg': <String>['all'],
    'dr_congo': <String>['all'],
    'congo_republic': <String>['all'],
    'zambia': <String>['all'],
    'namibia': <String>['all'],
    'cambodia': <String>['all'],
    'madagascar': <String>['all'],
    'turkmenistan': <String>['all'],
    'oman': <String>['all'],
    'mali': <String>['all'],
    'mauritania': <String>['all'],
    'kuwait': <String>['all'],
    'angola': <String>['all'],
    'nigeria': <String>['all'],
    'nepal': <String>['all'],
    'uruguay': <String>['all'],
    'north_macedonia': <String>['all'],
    'samoa': <String>['all'],
    'mozambique': <String>['all'],
    'nauru': <String>['all'],
    'niger': <String>['all'],
    'chad': <String>['all'],
    'tuvalu': <String>['all'],
    'micronesia': <String>['all'],
    'mauritius': <String>['all'],
    'argentina': <String>['all'],
    'chile': <String>['all'],
    'paraguay': <String>['all'],
    'peru': <String>['all'],
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
  _CountrySortCriterion _sortCriterion = _CountrySortCriterion.alphabet;
  final Map<_CountrySortCriterion, _CountrySortOrder> _sortOrderByCriterion = {
    _CountrySortCriterion.alphabet: _CountrySortOrder.ascending,
    _CountrySortCriterion.area: _CountrySortOrder.descending,
  };

  _CountrySortOrder get _activeSortOrder =>
      _sortOrderByCriterion[_sortCriterion] ?? _CountrySortOrder.ascending;

  void _openRegions(BuildContext context, String country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegionSelectionScreen(country: country),
      ),
    );
  }

  Future<void> _openWorldMapPicker() async {
    final texts = AppTexts.of(context);
    final selectedCountry = await openWorldMapPicker(
      context,
      hint: texts.countryMapHint,
      countries: CountrySelectionScreen.mapPins,
      labelBuilder: texts.countryName,
    );

    if (!mounted || selectedCountry == null) {
      return;
    }

    _openRegions(context, selectedCountry);
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

    int compareByName(_CountryOption a, _CountryOption b) {
      final nameA = texts.countryName(a.code);
      final nameB = texts.countryName(b.code);
      return nameA.compareTo(nameB);
    }

    int compareByArea(_CountryOption a, _CountryOption b) {
      final aArea = _countryAreaKm2[a.code] ?? 0;
      final bArea = _countryAreaKm2[b.code] ?? 0;
      final areaCompare = aArea.compareTo(bArea);
      if (areaCompare != 0) {
        return areaCompare;
      }
      return compareByName(a, b);
    }

    final baseCompare = _sortCriterion == _CountrySortCriterion.alphabet
        ? compareByName
        : compareByArea;
    final order = _activeSortOrder;

    countries.sort((a, b) {
      final result = baseCompare(a, b);
      return order == _CountrySortOrder.ascending ? result : -result;
    });

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
              _MapPickerButton(
                texts: texts,
                onPressed: _openWorldMapPicker,
              ),
              const SizedBox(height: 12),
              WorldSelectionMap(
                hint: texts.countryMapHint,
                countries: CountrySelectionScreen.mapPins,
                labelBuilder: texts.countryName,
                onTap: (code) => _openRegions(context, code),
              ),
              const SizedBox(height: 14),
              _CountrySortControls(
                texts: texts,
                criterion: _sortCriterion,
                order: _activeSortOrder,
                onCriterionChanged: (criterion) {
                  if (criterion == null) {
                    return;
                  }
                  setState(() {
                    _sortCriterion = criterion;
                  });
                },
                onOrderChanged: (order) {
                  if (order == null) {
                    return;
                  }
                  setState(() {
                    _sortOrderByCriterion[_sortCriterion] = order;
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

class _MapPickerButton extends StatelessWidget {
  final AppTexts texts;
  final VoidCallback onPressed;

  const _MapPickerButton({
    required this.texts,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        key: const ValueKey('country-map-picker-button'),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.map_rounded,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.countryMapPickerActionTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      texts.countryMapPickerActionSubtitle,
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
  final _CountrySortCriterion criterion;
  final _CountrySortOrder order;
  final ValueChanged<_CountrySortCriterion?> onCriterionChanged;
  final ValueChanged<_CountrySortOrder?> onOrderChanged;

  const _CountrySortControls({
    required this.texts,
    required this.criterion,
    required this.order,
    required this.onCriterionChanged,
    required this.onOrderChanged,
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
        SegmentedButton<_CountrySortCriterion>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<_CountrySortCriterion>(
              value: _CountrySortCriterion.alphabet,
              icon: const Icon(Icons.sort_by_alpha_rounded),
              label: Text(texts.countrySortAlphabet),
            ),
            ButtonSegment<_CountrySortCriterion>(
              value: _CountrySortCriterion.area,
              icon: const Icon(Icons.public_rounded),
              label: Text(texts.countrySortArea),
            ),
          ],
          selected: {criterion},
          onSelectionChanged: (selected) {
            onCriterionChanged(selected.isEmpty ? null : selected.first);
          },
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            texts.countrySortOrderLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<_CountrySortOrder>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<_CountrySortOrder>(
              value: _CountrySortOrder.ascending,
              icon: const Icon(Icons.arrow_upward_rounded),
              label: Text(texts.countrySortAscending),
            ),
            ButtonSegment<_CountrySortOrder>(
              value: _CountrySortOrder.descending,
              icon: const Icon(Icons.arrow_downward_rounded),
              label: Text(texts.countrySortDescending),
            ),
          ],
          selected: {order},
          onSelectionChanged: (selected) {
            onOrderChanged(selected.isEmpty ? null : selected.first);
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

enum _CountrySortCriterion {
  alphabet,
  area,
}

enum _CountrySortOrder {
  ascending,
  descending,
}
