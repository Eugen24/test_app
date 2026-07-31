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
}
