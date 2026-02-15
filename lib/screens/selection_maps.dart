import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'flag_badge.dart';

const _worldMapAssetPath = 'output/imagegen/world_map_no_labels_8k.png';
const _mapAspectRatio = 2.0;
const _mapMinScale = 1.0;
const _mapMaxScale = 6.0;
const _mapZoomStep = 1.25;

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

class _SelectionMapCard extends StatefulWidget {
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
  State<_SelectionMapCard> createState() => _SelectionMapCardState();
}

class _SelectionMapCardState extends State<_SelectionMapCard> {
  Future<void> _openFullscreenMap() async {
    final selectedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _FullscreenMapScreen(
          hint: widget.hint,
          pins: widget.pins,
          labelBuilder: widget.labelBuilder,
          backgroundBuilder: widget.backgroundBuilder,
        ),
      ),
    );

    if (!mounted || selectedCode == null) {
      return;
    }

    widget.onTap(selectedCode);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: AspectRatio(
        aspectRatio: _mapAspectRatio,
        child: Stack(
          children: [
            Positioned.fill(
              child: _MapCanvas(
                pins: widget.pins,
                labelBuilder: widget.labelBuilder,
                onTap: widget.onTap,
                backgroundBuilder: widget.backgroundBuilder,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: _MapHintBadge(hint: widget.hint),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _MapOverlayIconButton(
                icon: Icons.open_in_full_rounded,
                tooltip: 'Open fullscreen map',
                onPressed: _openFullscreenMap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCanvas extends StatelessWidget {
  final List<MapPinData> pins;
  final String Function(String code) labelBuilder;
  final ValueChanged<String> onTap;
  final WidgetBuilder backgroundBuilder;
  final double pinScale;

  const _MapCanvas({
    required this.pins,
    required this.labelBuilder,
    required this.onTap,
    required this.backgroundBuilder,
    this.pinScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(child: backgroundBuilder(context)),
            ...pins.map(
              (pin) => Positioned(
                left: constraints.maxWidth * pin.position.dx,
                top: constraints.maxHeight * pin.position.dy,
                child: Transform.translate(
                  offset: const Offset(-24, -20),
                  child: Transform.scale(
                    scale: pinScale,
                    child: _MapPin(
                      code: pin.code,
                      label: labelBuilder(pin.code),
                      onTap: () => onTap(pin.code),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FullscreenMapScreen extends StatefulWidget {
  final String hint;
  final List<MapPinData> pins;
  final String Function(String code) labelBuilder;
  final WidgetBuilder backgroundBuilder;

  const _FullscreenMapScreen({
    required this.hint,
    required this.pins,
    required this.labelBuilder,
    required this.backgroundBuilder,
  });

  @override
  State<_FullscreenMapScreen> createState() => _FullscreenMapScreenState();
}

class _FullscreenMapScreenState extends State<_FullscreenMapScreen> {
  final TransformationController _transformController =
      TransformationController();
  double _currentScale = 1.0;

  double get _pinScale {
    final scaled = math.pow(_currentScale, -1.2).toDouble();
    return scaled.clamp(0.14, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _transformController.addListener(_handleTransformChanged);
  }

  void _handleTransformChanged() {
    final nextScale = _transformController.value.getMaxScaleOnAxis();
    if ((nextScale - _currentScale).abs() < 0.001) {
      return;
    }
    setState(() {
      _currentScale = nextScale;
    });
  }

  void _zoomBy(double factor) {
    final currentScale = _currentScale;
    final targetScale =
        (currentScale * factor).clamp(_mapMinScale, _mapMaxScale);
    if (targetScale == currentScale) {
      return;
    }

    final scaleDelta = targetScale / currentScale;
    _transformController.value = _transformController.value.clone()
      ..scaleByDouble(scaleDelta, scaleDelta, scaleDelta, 1);
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  Size _fitMap(Size availableSpace) {
    var width = availableSpace.width;
    var height = width / _mapAspectRatio;

    if (height > availableSpace.height) {
      height = availableSpace.height;
      width = height * _mapAspectRatio;
    }

    return Size(width, height);
  }

  @override
  void dispose() {
    _transformController.removeListener(_handleTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 66, 12, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mapSize = _fitMap(constraints.biggest);

                    return InteractiveViewer(
                      transformationController: _transformController,
                      minScale: _mapMinScale,
                      maxScale: _mapMaxScale,
                      boundaryMargin: const EdgeInsets.all(260),
                      child: Center(
                        child: SizedBox(
                          width: mapSize.width,
                          height: mapSize.height,
                          child: _MapCanvas(
                            pins: widget.pins,
                            labelBuilder: widget.labelBuilder,
                            onTap: (code) => Navigator.of(context).pop(code),
                            backgroundBuilder: widget.backgroundBuilder,
                            pinScale: _pinScale,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  _MapOverlayIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Close fullscreen map',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MapHintBadge(hint: widget.hint),
                  ),
                  const SizedBox(width: 8),
                  _MapOverlayIconButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Zoom out',
                    onPressed: () => _zoomBy(1 / _mapZoomStep),
                  ),
                  const SizedBox(width: 6),
                  _MapOverlayIconButton(
                    icon: Icons.center_focus_strong_rounded,
                    tooltip: 'Reset zoom',
                    onPressed: _resetZoom,
                  ),
                  const SizedBox(width: 6),
                  _MapOverlayIconButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Zoom in',
                    onPressed: () => _zoomBy(_mapZoomStep),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapHintBadge extends StatelessWidget {
  final String hint;

  const _MapHintBadge({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        hint,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapOverlayIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _MapOverlayIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.62),
      borderRadius: BorderRadius.circular(999),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
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
      case 'canada':
        return const _CountryMapViewport(
          alignment: Alignment(-0.82, -0.52),
          scale: 2.7,
        );
      case 'mexico':
        return const _CountryMapViewport(
          alignment: Alignment(-0.76, 0.08),
          scale: 3.6,
        );
      case 'china':
        return const _CountryMapViewport(
          alignment: Alignment(0.74, -0.08),
          scale: 3.3,
        );
      case 'japan':
        return const _CountryMapViewport(
          alignment: Alignment(0.92, -0.08),
          scale: 5.1,
        );
      case 'vietnam':
        return const _CountryMapViewport(
          alignment: Alignment(0.72, 0.20),
          scale: 5.0,
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
