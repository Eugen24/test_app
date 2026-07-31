import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/map/data/mock_location_repository.dart';

void main() {
  test('MockLocationRepository returns a non-empty successful list', () async {
    final repo = MockLocationRepository();
    final result = await repo.getLocations();

    expect(result.isSuccess, isTrue);
    final locations = result.valueOrNull!;
    expect(locations.length, greaterThanOrEqualTo(5));
    expect(
      locations.map((l) => l.id).toSet().length,
      locations.length,
      reason: 'ids must be unique',
    );
  });

  test('every parking pin has a generated, non-empty boundary', () async {
    final repo = MockLocationRepository();
    final result = await repo.getLocations();
    final locations = result.valueOrNull!;

    for (final pin in locations) {
      expect(pin.boundary, isNotNull, reason: '${pin.id} missing boundary');
      expect(
        pin.boundary!.length,
        greaterThanOrEqualTo(3),
        reason: '${pin.id} boundary must form a shape',
      );
      expect(
        pin.boundaryIsPrecise,
        isFalse,
        reason: 'generated demo boundaries are estimates, not surveyed data',
      );
    }
  });
}
