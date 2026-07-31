import 'package:geolocator/geolocator.dart';
import '../domain/geolocation_service.dart';

/// [GeolocationService] implementation that delegates straight to the
/// `geolocator` plugin's static methods.
class GeolocatorService implements GeolocationService {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition();
}
