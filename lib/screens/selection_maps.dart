import 'package:flutter/material.dart';

import 'flag_badge.dart';

const _worldMapAssetPath = 'assets/world-map-clickable.gif';

class MapPinData {
  final String code;
  final Offset position;

  const MapPinData({
    required this.code,
    required this.position,
  });
}

class WorldSelectionMap extends StatelessWidget {
  final String hint;
  final List<MapPinData> countries;
  final String Function(String code) labelBuilder;
  final ValueChanged<String> onTap;

  const WorldSelectionMap({
    super.key,
    required this.hint,
    required this.countries,
    required this.labelBuilder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SelectionMapCard(
      hint: hint,
      pins: countries,
      labelBuilder: labelBuilder,
      onTap: onTap,
      backgroundBuilder: (_) => const _WorldMapBackground(),
    );
  }
}

class RegionSelectionMap extends StatelessWidget {
  final String country;
  final String hint;
  final List<MapPinData> regions;
  final String Function(String code) labelBuilder;
  final ValueChanged<String> onTap;

  const RegionSelectionMap({
    super.key,
    required this.country,
    required this.hint,
    required this.regions,
    required this.labelBuilder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SelectionMapCard(
      hint: hint,
      pins: regions,
      labelBuilder: labelBuilder,
      onTap: onTap,
      backgroundBuilder: (_) => _CountryZoomMapBackground(country: country),
    );
  }
}

class _SelectionMapCard extends StatelessWidget {
  final String hint;
  final List<MapPinData> pins;
  final String Function(String code) labelBuilder;
  final ValueChanged<String> onTap;
  final WidgetBuilder backgroundBuilder;

  const _SelectionMapCard({
    required this.hint,
    required this.pins,
    required this.labelBuilder,
    required this.onTap,
    required this.backgroundBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: AspectRatio(
        aspectRatio: 1.62,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(child: backgroundBuilder(context)),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      hint,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...pins.map(
                  (pin) => Positioned(
                    left: constraints.maxWidth * pin.position.dx,
                    top: constraints.maxHeight * pin.position.dy,
                    child: Transform.translate(
                      offset: const Offset(-24, -20),
                      child: _MapPin(
                        code: pin.code,
                        label: labelBuilder(pin.code),
                        onTap: () => onTap(pin.code),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WorldMapBackground extends StatelessWidget {
  const _WorldMapBackground();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _worldMapAssetPath,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => const _MapFallbackBackground(),
    );
  }
}

class _CountryZoomMapBackground extends StatelessWidget {
  final String country;

  const _CountryZoomMapBackground({required this.country});

  @override
  Widget build(BuildContext context) {
    final viewport = _CountryMapViewport.forCode(country);

    return ClipRect(
      child: Transform.scale(
        scale: viewport.scale,
        alignment: viewport.alignment,
        child: Image.asset(
          _worldMapAssetPath,
          fit: BoxFit.cover,
          alignment: viewport.alignment,
          errorBuilder: (_, __, ___) => const _MapFallbackBackground(),
        ),
      ),
    );
  }
}

class _CountryMapViewport {
  final Alignment alignment;
  final double scale;

  const _CountryMapViewport({
    required this.alignment,
    required this.scale,
  });

  static _CountryMapViewport forCode(String country) {
    switch (country) {
      case 'russia':
        return const _CountryMapViewport(
          alignment: Alignment(0.72, -0.58),
          scale: 2.45,
        );
      case 'usa':
        return const _CountryMapViewport(
          alignment: Alignment(-0.82, -0.18),
          scale: 2.9,
        );
      case 'china':
        return const _CountryMapViewport(
          alignment: Alignment(0.74, -0.08),
          scale: 3.3,
        );
      case 'poland':
        return const _CountryMapViewport(
          alignment: Alignment(0.06, -0.35),
          scale: 4.7,
        );
      case 'france':
        return const _CountryMapViewport(
          alignment: Alignment(-0.02, -0.22),
          scale: 4.8,
        );
      case 'australia':
        return const _CountryMapViewport(
          alignment: Alignment(0.82, 0.54),
          scale: 4.2,
        );
      case 'egypt':
        return const _CountryMapViewport(
          alignment: Alignment(0.34, -0.02),
          scale: 5.0,
        );
      case 'brazil':
        return const _CountryMapViewport(
          alignment: Alignment(-0.34, 0.26),
          scale: 4.0,
        );
      case 'uk':
        return const _CountryMapViewport(
          alignment: Alignment(-0.05, -0.36),
          scale: 6.0,
        );
      default:
        return const _CountryMapViewport(
          alignment: Alignment.center,
          scale: 1.0,
        );
    }
  }
}

class _MapFallbackBackground extends StatelessWidget {
  const _MapFallbackBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.78),
            colorScheme.surface,
            colorScheme.tertiaryContainer.withValues(alpha: 0.45),
          ],
        ),
      ),
      child: const CustomPaint(
        painter: _SimpleWorldPainter(),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final String code;
  final String label;
  final VoidCallback onTap;

  const _MapPin({
    required this.code,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: FlagBadge(
              code: code,
              width: 30,
              height: 22,
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 86),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.64),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleWorldPainter extends CustomPainter {
  const _SimpleWorldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final land = Paint()
      ..color = const Color(0xFF6CA37C).withValues(alpha: 0.72)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.18, size.width * 0.23,
          size.height * 0.34),
      land,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.40, size.height * 0.14, size.width * 0.40,
          size.height * 0.34),
      land,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.51, size.height * 0.45, size.width * 0.15,
          size.height * 0.30),
      land,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
