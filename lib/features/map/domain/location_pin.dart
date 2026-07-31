import 'geo_point.dart';

class LocationPin {
  const LocationPin({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.lat,
    required this.lng,
    this.address,
    this.totalSpots,
    this.availableSpots,
    this.pricePerHour,
    this.boundary,
    this.boundaryIsPrecise = false,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double lat;
  final double lng;

  /// Parking-specific fields, null for non-parking mock pins (e.g. in tests).
  final String? address;
  final int? totalSpots;
  final int? availableSpots;
  final double? pricePerHour;

  /// The lot's footprint, null when unknown. Estimated/generated shapes
  /// (the default) should leave [boundaryIsPrecise] false so the UI renders
  /// them as a dashed, approximate outline; a real surveyed/backend polygon
  /// should set it true to render as a solid, authoritative outline.
  final List<GeoPoint>? boundary;
  final bool boundaryIsPrecise;

  bool get isParkingSpot => totalSpots != null && availableSpots != null;
}
