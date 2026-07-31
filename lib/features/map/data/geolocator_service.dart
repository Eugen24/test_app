import 'package:geolocator/geolocator.dart' as geolocator;
import '../domain/geo_position.dart';
import '../domain/geolocation_service.dart';

/// [GeolocationService] implementation that delegates to the `geolocator`
/// plugin and maps its types to the domain's own — the only file in this
/// feature allowed to import `geolocator`.
class GeolocatorService implements GeolocationService {
  @override
  Future<bool> isLocationServiceEnabled() =>
      geolocator.Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    return _mapPermission(await geolocator.Geolocator.checkPermission());
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    return _mapPermission(await geolocator.Geolocator.requestPermission());
  }

  @override
  Future<GeoPosition> getCurrentPosition() async {
    final position = await geolocator.Geolocator.getCurrentPosition();
    return GeoPosition(lat: position.latitude, lng: position.longitude);
  }

  LocationPermissionStatus _mapPermission(
    geolocator.LocationPermission permission,
  ) {
    return switch (permission) {
      geolocator.LocationPermission.always ||
      geolocator.LocationPermission.whileInUse =>
        LocationPermissionStatus.granted,
      geolocator.LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      geolocator.LocationPermission.denied ||
      geolocator.LocationPermission.unableToDetermine =>
        LocationPermissionStatus.denied,
    };
  }
}
