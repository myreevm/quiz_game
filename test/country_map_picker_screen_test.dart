import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/screens/country_selection_screen.dart';
import 'package:quiz_app/screens/region_selection_screen.dart';

void main() {
  testWidgets('CountrySelectionScreen shows map picker button', (tester) async {
    await _pumpCountrySelection(tester);

    expect(find.byKey(const ValueKey('country-map-picker-button')),
        findsOneWidget);
  });

  testWidgets('tapping map picker button opens separate fullscreen map screen',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('tapping continent then country pin opens region selection',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

    await tester.tap(
      find.byKey(const ValueKey('map-pin-north_america')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('map-pin-canada')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(RegionSelectionScreen), findsOneWidget);
    final screen = tester.widget<RegionSelectionScreen>(
      find.byType(RegionSelectionScreen),
    );
    expect(screen.country, isNotEmpty);
  });

  testWidgets('back from region selection returns to selected continent map',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

    await tester.tap(
      find.byKey(const ValueKey('map-pin-europe')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('map-pin-poland')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(RegionSelectionScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(RegionSelectionScreen), findsNothing);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byKey(const ValueKey('map-pin-poland')), findsOneWidget);
  });

  testWidgets('separate map supports zoom and pan with clamped scale bounds',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

    final viewerFinder = find.byType(InteractiveViewer);
    final controller = _viewerController(tester);
    expect(controller.value.getMaxScaleOnAxis(), closeTo(1.0, 0.001));

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    final zoomedScale = controller.value.getMaxScaleOnAxis();
    expect(zoomedScale, greaterThan(1.0));

    final matrixAfterZoom = controller.value.clone();
    await tester.drag(viewerFinder, const Offset(-120, -80));
    await tester.pumpAndSettle();

    final matrixAfterDrag = controller.value;
    final movedX =
        (matrixAfterDrag.storage[12] - matrixAfterZoom.storage[12]).abs();
    final movedY =
        (matrixAfterDrag.storage[13] - matrixAfterZoom.storage[13]).abs();
    expect(movedX + movedY, greaterThan(0.1));

    for (var i = 0; i < 20; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(controller.value.getMaxScaleOnAxis(), lessThanOrEqualTo(10.0));

    for (var i = 0; i < 40; i++) {
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(controller.value.getMaxScaleOnAxis(), greaterThanOrEqualTo(1.0));
  });

  testWidgets(
      'continent country pins keep world-map coordinates (no local overrides)',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

    await tester.tap(
      find.byKey(const ValueKey('map-pin-europe')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    final mapRect = _fullscreenMapRect(tester);
    final russiaAnchor = _readNormalizedAnchor(
      tester,
      mapRect: mapRect,
      pinCode: 'russia',
    );
    final kazakhstanAnchor = _readNormalizedAnchor(
      tester,
      mapRect: mapRect,
      pinCode: 'kazakhstan',
    );
    final worldPins = {
      for (final pin in CountrySelectionScreen.mapPins) pin.code: pin.position,
    };

    expect(russiaAnchor.dx, closeTo(worldPins['russia']!.dx, 0.02));
    expect(russiaAnchor.dy, closeTo(worldPins['russia']!.dy, 0.02));
    expect(kazakhstanAnchor.dx, closeTo(worldPins['kazakhstan']!.dx, 0.02));
    expect(kazakhstanAnchor.dy, closeTo(worldPins['kazakhstan']!.dy, 0.02));
  });
}

Future<void> _pumpCountrySelection(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final controller = AppSettingsController(
    initialSettings: const AppSettings(appLanguage: AppLanguage.english),
  );

  await tester.pumpWidget(
    AppSettingsScope(
      controller: controller,
      child: const MaterialApp(
        home: CountrySelectionScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<void> _openMapPickerFromButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('country-map-picker-button')));
  await tester.pumpAndSettle();
}

TransformationController _viewerController(WidgetTester tester) {
  final viewer =
      tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
  final controller = viewer.transformationController;
  expect(controller, isNotNull);
  return controller!;
}

Rect _fullscreenMapRect(WidgetTester tester) {
  const expectedMapWidth = 396.0;
  const expectedMapHeight = 198.0;
  final mapFinder = find.descendant(
    of: find.byType(InteractiveViewer),
    matching: find.byWidgetPredicate((widget) {
      if (widget is! SizedBox) {
        return false;
      }
      final width = widget.width;
      final height = widget.height;
      if (width == null || height == null) {
        return false;
      }
      return (width - expectedMapWidth).abs() <= 0.1 &&
          (height - expectedMapHeight).abs() <= 0.1;
    }),
  );
  expect(mapFinder, findsOneWidget);
  return tester.getRect(mapFinder);
}

Offset _readNormalizedAnchor(
  WidgetTester tester, {
  required Rect mapRect,
  required String pinCode,
}) {
  const pinWidth = 92.0;
  const pinAnchorDx = pinWidth / 2;
  const pinAnchorDy = 20.0;

  final pinFinder = find.byKey(ValueKey('map-pin-$pinCode'));
  expect(pinFinder, findsOneWidget);
  final pinRect = tester.getRect(pinFinder);
  final scale = pinRect.width / pinWidth;
  final anchor = Offset(
    pinRect.left + pinAnchorDx * scale,
    pinRect.top + pinAnchorDy * scale,
  );
  return Offset(
    (anchor.dx - mapRect.left) / mapRect.width,
    (anchor.dy - mapRect.top) / mapRect.height,
  );
}
