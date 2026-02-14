import 'package:flutter/material.dart';

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
    switch (code) {
      case 'russia':
        return _horizontalStripes(
          const [
            Colors.white,
            Color(0xFF0A4EA1),
            Color(0xFFD52B1E),
          ],
        );
      case 'usa':
        return _usaFlag();
      case 'china':
        return Container(
          color: const Color(0xFFDE2910),
          child: const Align(
            alignment: Alignment(-0.55, -0.55),
            child: Text(
              '★',
              style: TextStyle(
                color: Color(0xFFFFDE00),
                fontSize: 18,
                height: 1,
              ),
            ),
          ),
        );
      case 'poland':
        return _horizontalStripes(
          const [
            Colors.white,
            Color(0xFFDC143C),
          ],
        );
      case 'france':
        return _verticalStripes(
          const [
            Color(0xFF0055A4),
            Colors.white,
            Color(0xFFEF4135),
          ],
        );
      case 'yakutia':
        return _yakutiaFlag();
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
        return _fallbackFlag();
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

  Widget _verticalStripes(List<Color> colors) {
    return Row(
      children: [
        for (final color in colors)
          Expanded(
            child: ColoredBox(color: color),
          ),
      ],
    );
  }

  Widget _usaFlag() {
    return Stack(
      children: [
        Column(
          children: List.generate(
            13,
            (index) => Expanded(
              child: ColoredBox(
                color: index.isEven ? const Color(0xFFB22234) : Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width * 0.45,
            height: height * 0.55,
            child: const ColoredBox(
              color: Color(0xFF3C3B6E),
              child: Center(
                child: Text(
                  '★',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
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
            child: const Text(
              '★',
              style: TextStyle(color: Colors.white, fontSize: 12),
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

  Widget _fallbackFlag() {
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
