import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/screens/selection_maps.dart';

void main() {
  testWidgets('zoom-in button clamps at 10x', (tester) async {
    await _pumpWorldMap(tester);
    await _openFullscreenMap(tester);

    for (var i = 0; i < 20; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    final scale = _viewerController(tester).value.getMaxScaleOnAxis();
    expect(scale, closeTo(10.0, 0.001));
    expect(scale, lessThanOrEqualTo(10.0));
  });

  testWidgets('zoom buttons keep viewport center stable', (tester) async {
    await _pumpWorldMap(tester);
    await _openFullscreenMap(tester);

    final viewerFinder = find.byType(InteractiveViewer);
    final viewerBox = tester.renderObject<RenderBox>(viewerFinder);
    final localCenter = viewerBox.size.center(Offset.zero);
    final initialScale = _viewerController(tester).value.getMaxScaleOnAxis();

    final sceneBeforeZoomIn = _viewerController(tester).toScene(localCenter);
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    final scaleAfterZoomIn =
        _viewerController(tester).value.getMaxScaleOnAxis();
    final sceneAfterZoomIn = _viewerController(tester).toScene(localCenter);

    expect(scaleAfterZoomIn, greaterThan(initialScale));
    expect(sceneAfterZoomIn.dx, closeTo(sceneBeforeZoomIn.dx, 0.01));
    expect(sceneAfterZoomIn.dy, closeTo(sceneBeforeZoomIn.dy, 0.01));

    final sceneBeforeZoomOut = _viewerController(tester).toScene(localCenter);
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    final scaleAfterZoomOut =
        _viewerController(tester).value.getMaxScaleOnAxis();
    final sceneAfterZoomOut = _viewerController(tester).toScene(localCenter);

    expect(scaleAfterZoomOut, lessThan(scaleAfterZoomIn));
    expect(sceneAfterZoomOut.dx, closeTo(sceneBeforeZoomOut.dx, 0.01));
    expect(sceneAfterZoomOut.dy, closeTo(sceneBeforeZoomOut.dy, 0.01));
  });
}

Future<void> _pumpWorldMap(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
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
              width: 360,
              child: WorldSelectionMap(
                hint: 'Tap country',
                countries: const [
                  MapPinData(code: 'canada', position: Offset(0.23, 0.18)),
                ],
                labelBuilder: (code) => code,
                onTap: (_) {},
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<void> _openFullscreenMap(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.open_in_full_rounded));
  await tester.pumpAndSettle();
  expect(find.byType(InteractiveViewer), findsOneWidget);
}

TransformationController _viewerController(WidgetTester tester) {
  final viewer =
      tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
  final controller = viewer.transformationController;
  expect(controller, isNotNull);
  return controller!;
}
