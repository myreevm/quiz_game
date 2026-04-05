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

  testWidgets('tapping country pin on separate map opens region selection',
      (tester) async {
    await _pumpCountrySelection(tester);
    await _openMapPickerFromButton(tester);

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
