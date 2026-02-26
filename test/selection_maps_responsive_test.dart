import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/screens/selection_maps.dart';

const _pinWidth = 92.0;
const _pinAnchorDx = _pinWidth / 2;
const _pinAnchorDy = 20.0;

void main() {
  testWidgets('WorldSelectionMap scales pins on narrow screens',
      (tester) async {
    const pin = MapPinData(code: 'canada', position: Offset(0.23, 0.18));

    await _pumpMap(
      tester,
      mapWidth: 1000,
      child: const WorldSelectionMap(
        hint: 'Tap country',
        countries: [pin],
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final wide = _readPinSnapshot(
      tester,
      mapFinder: find.byType(WorldSelectionMap),
      pinCode: pin.code,
    );

    await _pumpMap(
      tester,
      mapWidth: 330,
      child: const WorldSelectionMap(
        hint: 'Tap country',
        countries: [pin],
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final narrow = _readPinSnapshot(
      tester,
      mapFinder: find.byType(WorldSelectionMap),
      pinCode: pin.code,
    );

    expect(narrow.pinRect.width, lessThan(wide.pinRect.width));
    expect(wide.scale, closeTo(1.0, 0.01));
    expect(narrow.scale, closeTo(0.62, 0.02));
  });

  testWidgets('WorldSelectionMap keeps anchor coordinates stable',
      (tester) async {
    const pin = MapPinData(code: 'canada', position: Offset(0.23, 0.18));

    await _pumpMap(
      tester,
      mapWidth: 1000,
      child: const WorldSelectionMap(
        hint: 'Tap country',
        countries: [pin],
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final wide = _readPinSnapshot(
      tester,
      mapFinder: find.byType(WorldSelectionMap),
      pinCode: pin.code,
    );

    await _pumpMap(
      tester,
      mapWidth: 330,
      child: const WorldSelectionMap(
        hint: 'Tap country',
        countries: [pin],
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final narrow = _readPinSnapshot(
      tester,
      mapFinder: find.byType(WorldSelectionMap),
      pinCode: pin.code,
    );

    expect(
      (wide.normalizedAnchor.dx - pin.position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (wide.normalizedAnchor.dy - pin.position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrow.normalizedAnchor.dx - pin.position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrow.normalizedAnchor.dy - pin.position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
  });

  testWidgets('RegionSelectionMap uses the same responsive positioning',
      (tester) async {
    const regions = [
      MapPinData(code: 'all', position: Offset(0.24, 0.30)),
      MapPinData(code: 'texas', position: Offset(0.49, 0.50)),
    ];

    await _pumpMap(
      tester,
      mapWidth: 1000,
      child: const RegionSelectionMap(
        country: 'usa',
        hint: 'Tap region',
        regions: regions,
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final wideAll = _readPinSnapshot(
      tester,
      mapFinder: find.byType(RegionSelectionMap),
      pinCode: 'all',
    );
    final wideTexas = _readPinSnapshot(
      tester,
      mapFinder: find.byType(RegionSelectionMap),
      pinCode: 'texas',
    );

    await _pumpMap(
      tester,
      mapWidth: 330,
      child: const RegionSelectionMap(
        country: 'usa',
        hint: 'Tap region',
        regions: regions,
        labelBuilder: _label,
        onTap: _onTap,
      ),
    );
    final narrowAll = _readPinSnapshot(
      tester,
      mapFinder: find.byType(RegionSelectionMap),
      pinCode: 'all',
    );
    final narrowTexas = _readPinSnapshot(
      tester,
      mapFinder: find.byType(RegionSelectionMap),
      pinCode: 'texas',
    );

    expect(narrowAll.scale, closeTo(0.62, 0.02));

    expect(
      (wideAll.normalizedAnchor.dx - regions[0].position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (wideAll.normalizedAnchor.dy - regions[0].position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrowAll.normalizedAnchor.dx - regions[0].position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrowAll.normalizedAnchor.dy - regions[0].position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (wideTexas.normalizedAnchor.dx - regions[1].position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (wideTexas.normalizedAnchor.dy - regions[1].position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrowTexas.normalizedAnchor.dx - regions[1].position.dx).abs(),
      lessThanOrEqualTo(0.01),
    );
    expect(
      (narrowTexas.normalizedAnchor.dy - regions[1].position.dy).abs(),
      lessThanOrEqualTo(0.01),
    );
  });
}

Future<void> _pumpMap(
  WidgetTester tester, {
  required double mapWidth,
  required Widget child,
}) async {
  final surfaceWidth = math.max(mapWidth + 80, 420.0);
  await tester.binding.setSurfaceSize(Size(surfaceWidth, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final controller = AppSettingsController(
    initialSettings: const AppSettings(appLanguage: AppLanguage.english),
  );

  await tester.pumpWidget(
    AppSettingsScope(
      controller: controller,
      child: MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: mapWidth,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

_PinSnapshot _readPinSnapshot(
  WidgetTester tester, {
  required Finder mapFinder,
  required String pinCode,
}) {
  final mapRect = tester.getRect(mapFinder);
  final pinFinder = find.byKey(ValueKey('map-pin-$pinCode'));
  expect(pinFinder, findsOneWidget);
  final pinRect = tester.getRect(pinFinder);
  final scale = pinRect.width / _pinWidth;

  final anchor = Offset(
    pinRect.left + _pinAnchorDx * scale,
    pinRect.top + _pinAnchorDy * scale,
  );

  final normalizedAnchor = Offset(
    (anchor.dx - mapRect.left) / mapRect.width,
    (anchor.dy - mapRect.top) / mapRect.height,
  );

  return _PinSnapshot(
    pinRect: pinRect,
    scale: scale,
    normalizedAnchor: normalizedAnchor,
  );
}

String _label(String code) => code;

void _onTap(String _) {}

class _PinSnapshot {
  final Rect pinRect;
  final double scale;
  final Offset normalizedAnchor;

  const _PinSnapshot({
    required this.pinRect,
    required this.scale,
    required this.normalizedAnchor,
  });
}
