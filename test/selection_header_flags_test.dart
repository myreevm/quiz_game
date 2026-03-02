import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/screens/category_selection_screen.dart';
import 'package:quiz_app/screens/flag_badge.dart';
import 'package:quiz_app/screens/region_selection_screen.dart';

void main() {
  testWidgets('RegionSelectionScreen header shows selected country flag',
      (tester) async {
    await _pumpScreen(
      tester,
      child: const RegionSelectionScreen(country: 'usa'),
    );

    final headerFlagFinder =
        find.byKey(const ValueKey('region-header-country-flag'));
    expect(headerFlagFinder, findsOneWidget);

    final headerFlag = tester.widget<FlagBadge>(headerFlagFinder);
    expect(headerFlag.code, 'usa');
  });

  testWidgets('CategorySelectionScreen header shows selected region flag',
      (tester) async {
    await _pumpScreen(
      tester,
      child: const CategorySelectionScreen(
        country: 'usa',
        region: 'texas',
      ),
    );

    final headerFlagFinder =
        find.byKey(const ValueKey('category-header-location-flag'));
    expect(headerFlagFinder, findsOneWidget);

    final headerFlag = tester.widget<FlagBadge>(headerFlagFinder);
    expect(headerFlag.code, 'texas');
  });

  testWidgets(
      'CategorySelectionScreen header falls back to country flag for whole country',
      (tester) async {
    await _pumpScreen(
      tester,
      child: const CategorySelectionScreen(
        country: 'usa',
        region: null,
      ),
    );

    final headerFlagFinder =
        find.byKey(const ValueKey('category-header-location-flag'));
    expect(headerFlagFinder, findsOneWidget);

    final headerFlag = tester.widget<FlagBadge>(headerFlagFinder);
    expect(headerFlag.code, 'usa');
  });
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required Widget child,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final controller = AppSettingsController(
    initialSettings: const AppSettings(appLanguage: AppLanguage.english),
  );

  await tester.pumpWidget(
    AppSettingsScope(
      controller: controller,
      child: MaterialApp(home: child),
    ),
  );

  await tester.pumpAndSettle();
}
