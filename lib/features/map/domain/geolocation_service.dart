import 'package:geolocator/geolocator.dart';

/// Abstraction over the device location APIs so the presentation layer
/// never calls `Geolocator` statics directly, keeping it testable.
abstract class GeolocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition();
}
