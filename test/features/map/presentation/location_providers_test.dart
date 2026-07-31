import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/map/presentation/providers/location_providers.dart';

void main() {
  test(
    'filteredLocationsProvider returns all locations when query is empty',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(locationsProvider.future);
      final filtered = container.read(filteredLocationsProvider);

      expect(filtered.length, greaterThanOrEqualTo(5));
    },
  );

  test(
    'filteredLocationsProvider filters by case-insensitive name substring',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(locationsProvider.future);
      container.read(searchQueryProvider.notifier).state = 'codru';
      final filtered = container.read(filteredLocationsProvider);

      expect(filtered.length, 1);
      expect(filtered.first.name, 'Hotel Codru Guest Parking');
    },
  );

  test('selectedLocationIdProvider defaults to null and is settable', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(selectedLocationIdProvider), isNull);
    container.read(selectedLocationIdProvider.notifier).state = 'loc-1';
    expect(container.read(selectedLocationIdProvider), 'loc-1');
  });
}
