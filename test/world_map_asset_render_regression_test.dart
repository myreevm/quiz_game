import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/screens/selection_maps.dart';

const _worldMapAssetPath = 'assets/world-map-no-labels.svg';

void main() {
  testWidgets('world map SVG parses with flutter_svg loader', (tester) async {
    final pictureInfo = await vg.loadPicture(
      const SvgAssetLoader(_worldMapAssetPath),
      null,
    );
    addTearDown(pictureInfo.picture.dispose);
  });

  testWidgets('WorldSelectionMap does not render painter fallback background',
      (tester) async {
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

    final fallbackPainter = find.byWidgetPredicate((widget) {
      if (widget is! CustomPaint) {
        return false;
      }
      final painter = widget.painter;
      return painter != null &&
          painter.runtimeType.toString() == '_SimpleWorldPainter';
    });

    expect(fallbackPainter, findsNothing);
  });
}
