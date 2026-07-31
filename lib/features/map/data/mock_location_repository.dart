import 'dart:math' as math;
import '../../../core/utils/result.dart';
import '../domain/geo_point.dart';
import '../domain/location_pin.dart';
import '../domain/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  /// FNV-1a over [id] so the boundary shape is stable across app runs and
  /// devices (unlike `String.hashCode`, which the language spec does not
  /// guarantee to be stable) while still being deterministic per pin.
  static int _stableSeed(String id) {
    var hash = 0x811c9dc5;
    for (final unit in id.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  /// Generates an irregular polygon footprint around a lot's center —
  /// deterministic per [id], sized proportionally to [totalSpots] so bigger
  /// lots visibly look bigger, and jittered in both angle and radius so it
  /// reads as a traced-out lot rather than a generic rectangle. This is a
  /// stand-in for real survey/backend polygon geometry — pins built with it
  /// leave [LocationPin.boundaryIsPrecise] at its default `false`, so the
  /// outline renders as dashed/estimated rather than solid.
  static List<GeoPoint> _generateBoundary(
    String id,
    double lat,
    double lng,
    int totalSpots,
  ) {
    final random = math.Random(_stableSeed(id));

    // ~0.00012deg ≈ 9-13m at this latitude; scale up per spot, capped so
    // very large lots don't sprawl into neighboring streets.
    final baseRadius = (0.00012 + totalSpots * 0.0000032).clamp(
      0.00012,
      0.00035,
    );
    final latRad = lat * math.pi / 180;
    final lngCorrection = math.cos(latRad).abs().clamp(0.3, 1.0);

    const vertexCount = 6;
    return List.generate(vertexCount, (i) {
      final baseAngle = 2 * math.pi * i / vertexCount;
      final angleJitter = (random.nextDouble() - 0.5) * (math.pi / vertexCount);
      final radiusJitter = 0.6 + random.nextDouble() * 0.6; // 0.6x-1.2x
      final r = baseRadius * radiusJitter;
      final angle = baseAngle + angleJitter;
      return GeoPoint(
        lat + r * math.sin(angle),
        lng + (r * math.cos(angle)) / lngCorrection,
      );
    });
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
      boundary: _generateBoundary(id, lat, lng, totalSpots),
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
