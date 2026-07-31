import '../../../core/utils/result.dart';
import '../domain/geo_point.dart';
import '../domain/location_pin.dart';
import '../domain/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  /// Generates a rectangular footprint around a lot's center, sized
  /// proportionally to its capacity so bigger lots visibly look bigger on
  /// the map. This is a stand-in for real survey/backend polygon geometry —
  /// pins built with it leave [LocationPin.boundaryIsPrecise] at its default
  /// `false`, so the outline renders as dashed/estimated rather than solid.
  static List<GeoPoint> _generateBoundary(double lat, double lng, int totalSpots) {
    // ~0.00015deg ≈ 12-17m at this latitude; scale up slightly per spot,
    // capped so very large lots don't sprawl into neighboring streets.
    final halfWidth = (0.00015 + totalSpots * 0.0000035).clamp(0.00015, 0.00045);
    final halfHeight = halfWidth * 0.7;
    return [
      GeoPoint(lat - halfHeight, lng - halfWidth),
      GeoPoint(lat - halfHeight, lng + halfWidth),
      GeoPoint(lat + halfHeight, lng + halfWidth),
      GeoPoint(lat + halfHeight, lng - halfWidth),
    ];
  }

  static LocationPin _pin({
    required String id,
    required String name,
    required String description,
    required String category,
    required String address,
    required double lat,
    required double lng,
    required int totalSpots,
    required int availableSpots,
    required double pricePerHour,
  }) {
    return LocationPin(
      id: id,
      name: name,
      description: description,
      category: category,
      address: address,
      lat: lat,
      lng: lng,
      totalSpots: totalSpots,
      availableSpots: availableSpots,
      pricePerHour: pricePerHour,
      boundary: _generateBoundary(lat, lng, totalSpots),
    );
  }

  static final _seed = <LocationPin>[
    _pin(
      id: 'loc-1',
      name: 'Nobil Tower Office Parking',
      description: 'Secure underground lot beneath a Class A office tower.',
      category: 'office',
      address: 'Bd. Ștefan cel Mare 202, Chișinău',
      lat: 47.0245,
      lng: 28.8324,
      totalSpots: 40,
      availableSpots: 12,
      pricePerHour: 15,
    ),
    _pin(
      id: 'loc-2',
      name: 'Hotel Codru Guest Parking',
      description: 'Covered hotel lot, open to guests and drivers passing through.',
      category: 'hotel',
      address: 'Bd. Negruzzi 4, Chișinău',
      lat: 47.0169,
      lng: 28.8497,
      totalSpots: 25,
      availableSpots: 6,
      pricePerHour: 20,
    ),
    _pin(
      id: 'loc-3',
      name: 'Botanica Residence Yard',
      description: 'Gated residential complex parking, unused spots reserved by neighbors.',
      category: 'residential',
      address: 'Str. Independenței 15, Chișinău',
      lat: 46.9897,
      lng: 28.8394,
      totalSpots: 18,
      availableSpots: 9,
      pricePerHour: 10,
    ),
    _pin(
      id: 'loc-4',
      name: 'Centru Business Hub Lot',
      description: 'Open-air lot behind a downtown coworking building.',
      category: 'office',
      address: 'Str. Columna 65, Chișinău',
      lat: 47.0245,
      lng: 28.8261,
      totalSpots: 30,
      availableSpots: 0,
      pricePerHour: 18,
    ),
    _pin(
      id: 'loc-5',
      name: 'Riverside Hotel Parking',
      description: 'Riverside hotel lot with easy access to the Bâc embankment.',
      category: 'hotel',
      address: 'Str. Bănulescu-Bodoni 57, Chișinău',
      lat: 47.0129,
      lng: 28.8353,
      totalSpots: 22,
      availableSpots: 14,
      pricePerHour: 16,
    ),
    _pin(
      id: 'loc-6',
      name: 'Telecentru Complex Yard',
      description: 'Residential complex yard, reservable evenings and weekends.',
      category: 'residential',
      address: 'Str. Alba Iulia 75, Chișinău',
      lat: 47.0079,
      lng: 28.8127,
      totalSpots: 20,
      availableSpots: 5,
      pricePerHour: 8,
    ),
  ];

  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return Result.success(List.unmodifiable(_seed));
  }
}
