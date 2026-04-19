import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/game_catalog.dart';
import 'package:quiz_app/screens/country_selection_screen.dart';

void main() {
  group('continent-country mapping', () {
    final mapping = CountrySelectionScreen.continentCountries;
    final counts = <String, int>{};
    final worldPositions = {
      for (final pin in CountrySelectionScreen.mapPins) pin.code: pin.position,
    };

    for (final countries in mapping.values) {
      for (final code in countries) {
        counts.update(code, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    test('each playable country is assigned to at least one continent', () {
      for (final code in playableCountryCodes) {
        expect(
          counts[code],
          isNotNull,
          reason: 'Missing continent assignment for $code',
        );
      }
    });

    test('only russia, turkey, and kazakhstan appear in two continents', () {
      const expectedDuplicates = {'russia', 'turkey', 'kazakhstan'};
      final duplicates = counts.entries
          .where((entry) => entry.value > 1)
          .map((entry) => entry.key)
          .toSet();

      expect(duplicates, expectedDuplicates);
    });

    test('all other countries appear exactly once', () {
      const expectedDuplicates = {'russia', 'turkey', 'kazakhstan'};

      for (final code in playableCountryCodes) {
        final expectedCount = expectedDuplicates.contains(code) ? 2 : 1;
        expect(
          counts[code],
          expectedCount,
          reason: 'Unexpected continent count for $code',
        );
      }
    });

    test('all continent countries use positions from global world map pins',
        () {
      for (final entry in mapping.entries) {
        final continent = entry.key;
        for (final code in entry.value) {
          expect(
            worldPositions[code],
            isNotNull,
            reason: 'Missing world-map position for $code in $continent',
          );
        }
      }
    });
  });
}
