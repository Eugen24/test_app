/// A resolved device position, independent of any location-plugin package —
/// mirrors why [LocationPin]/[GeoPoint] carry no plugin dependency either.
class GeoPosition {
  const GeoPosition({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

/// Domain-owned mirror of the location-plugin's permission states, so
/// [GeolocationService] callers never depend on that package's types.
enum LocationPermissionStatus { granted, denied, deniedForever }
