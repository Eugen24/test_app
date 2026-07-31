import '../../../core/utils/result.dart';
import '../domain/location_pin.dart';
import '../domain/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  static final _seed = <LocationPin>[
    const LocationPin(
      id: 'loc-1',
      name: 'Riverside Park',
      description: 'Open green space along the river, great for a walk.',
      category: 'park',
      lat: 37.7749,
      lng: -122.4194,
    ),
    const LocationPin(
      id: 'loc-2',
      name: 'Downtown Coffee Co.',
      description: 'Cozy coffee shop with rotating single-origin beans.',
      category: 'cafe',
      lat: 37.7793,
      lng: -122.4193,
    ),
    const LocationPin(
      id: 'loc-3',
      name: 'Central Library',
      description: 'Public library with a large reading room.',
      category: 'library',
      lat: 37.7789,
      lng: -122.4162,
    ),
    const LocationPin(
      id: 'loc-4',
      name: 'Sunset Diner',
      description: 'Classic American diner, open until midnight.',
      category: 'restaurant',
      lat: 37.7712,
      lng: -122.4240,
    ),
    const LocationPin(
      id: 'loc-5',
      name: 'Harbor View Point',
      description: 'Scenic overlook of the harbor and bridge.',
      category: 'landmark',
      lat: 37.7827,
      lng: -122.4108,
    ),
    const LocationPin(
      id: 'loc-6',
      name: 'Green Market',
      description: 'Weekend farmers market with local produce.',
      category: 'market',
      lat: 37.7735,
      lng: -122.4310,
    ),
  ];

  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return Result.success(List.unmodifiable(_seed));
  }
}
