import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlagBadge extends StatelessWidget {
  final String code;
  final double width;
  final double height;

  const FlagBadge({
    super.key,
    required this.code,
    this.width = 48,
    this.height = 36,
  });

  static const Map<String, String> _countryFlagAssets = {
    'russia': 'assets/flags/russia.png',
    'china': 'assets/flags/china.png',
    'usa': 'assets/flags/usa.png',
    'canada': 'assets/flags/canada.png',
    'mexico': 'assets/flags/mexico.png',
    'japan': 'assets/flags/japan.png',
    'vietnam': 'assets/flags/vietnam.png',
    'texas': 'assets/flags/texas.png',
    'oklahoma': 'assets/flags/oklahoma.png',
    'dagestan': 'assets/flags/dagestan.png',
    'yakutia': 'assets/flags/yakutia.png',
    'france': 'assets/flags/france.png',
    'poland': 'assets/flags/poland.png',
    'australia': 'assets/flags/australia.png',
    'egypt': 'assets/flags/egypt.png',
    'brazil': 'assets/flags/brazil.png',
    'uk': 'assets/flags/uk.png',
    'belarus': 'assets/flags/belarus.svg',
    'argentina': 'assets/flags/argentina.png',
    'turkey': 'assets/flags/turkey.png',
    'south_africa': 'assets/flags/south_africa.png',
    'italy': 'assets/flags/italy.png',
    'germany': 'assets/flags/germany.svg',
    'switzerland': 'assets/flags/switzerland.svg',
    'spain': 'assets/flags/spain.svg',
    'south_korea': 'assets/flags/south_korea.svg',
    'new_zealand': 'assets/flags/new_zealand.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildFlag(context),
    );
  }

  Widget _buildFlag(BuildContext context) {
    final assetPath = _countryFlagAssets[code];
    if (assetPath != null) {
      if (assetPath.endsWith('.svg')) {
        return SvgPicture.asset(
          assetPath,
          fit: BoxFit.cover,
          placeholderBuilder: (_) => _buildFallbackFlag(context),
        );
      }

      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackFlag(context),
      );
    }

    return _buildFallbackFlag(context);
  }

  Widget _buildFallbackFlag(BuildContext context) {
    switch (code) {
      case 'yakutia':
        return _yakutiaFlag();
      case 'vietnam':
        return _vietnamFlag();
      case 'japan':
        return _japanFlag();
      case 'mexico':
        return _mexicoFlag();
      case 'canada':
        return _canadaFlag();
      case 'dagestan':
        return _horizontalStripes(
          const [
            Color(0xFF00843D),
            Color(0xFF0072C6),
            Color(0xFFD52B1E),
          ],
        );
      case 'texas':
        return _texasFlag();
      case 'oklahoma':
        return Container(
          color: const Color(0xFF6CB4EE),
          child: const Center(
            child: Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
        );
      case 'all':
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          color: colorScheme.primaryContainer,
          child: Icon(Icons.public_rounded, color: colorScheme.primary),
        );
      default:
        return _textFallback();
    }
  }

  Widget _horizontalStripes(List<Color> colors) {
    return Column(
      children: [
        for (final color in colors)
          Expanded(
            child: ColoredBox(color: color),
          ),
      ],
    );
  }

  Widget _yakutiaFlag() {
    return Stack(
      children: [
        Column(
          children: const [
            Expanded(flex: 6, child: ColoredBox(color: Color(0xFF0099D9))),
            Expanded(flex: 1, child: ColoredBox(color: Colors.white)),
            Expanded(flex: 1, child: ColoredBox(color: Color(0xFFED2939))),
            Expanded(flex: 2, child: ColoredBox(color: Color(0xFF009A49))),
          ],
        ),
        const Align(
          alignment: Alignment(-0.25, -0.35),
          child: CircleAvatar(
            radius: 5.5,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _texasFlag() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: const Color(0xFF002868),
            alignment: Alignment.center,
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
        const Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(child: ColoredBox(color: Colors.white)),
              Expanded(child: ColoredBox(color: Color(0xFFBF0A30))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _vietnamFlag() {
    return Container(
      color: const Color(0xFFDA251D),
      alignment: Alignment.center,
      child: const Icon(
        Icons.star_rounded,
        color: Color(0xFFFFE000),
        size: 19,
      ),
    );
  }

  Widget _japanFlag() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: Color(0xFFBC002D),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _mexicoFlag() {
    return Row(
      children: [
        const Expanded(child: ColoredBox(color: Color(0xFF006847))),
        Expanded(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC0932B),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
      ],
    );
  }

  Widget _canadaFlag() {
    return Row(
      children: [
        const Expanded(child: ColoredBox(color: Color(0xFFD80621))),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const Icon(
              Icons.eco,
              color: Color(0xFFD80621),
              size: 14,
            ),
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFD80621))),
      ],
    );
  }

  Widget _textFallback() {
    final short = code.length >= 2 ? code.substring(0, 2).toUpperCase() : code;

    return Container(
      color: const Color(0xFFE0E0E0),
      alignment: Alignment.center,
      child: Text(
        short,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
}
