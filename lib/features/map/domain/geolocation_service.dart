import 'geo_position.dart';

/// Abstraction over the device location APIs so the presentation layer
/// never calls `Geolocator` statics (or its types) directly, keeping it
/// testable and free of a concrete location-plugin dependency.
abstract class GeolocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermissionStatus> checkPermission();
  Future<LocationPermissionStatus> requestPermission();
  Future<GeoPosition> getCurrentPosition();
}
