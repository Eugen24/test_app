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

  bool get isParkingSpot => totalSpots != null && availableSpots != null;
}
