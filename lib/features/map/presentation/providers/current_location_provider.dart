import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/result.dart';
import '../../data/geolocator_service.dart';
import '../../domain/geolocation_service.dart';

final geolocationServiceProvider = Provider<GeolocationService>((ref) {
  return GeolocatorService();
});

class CurrentLocationController
    extends StateNotifier<AsyncValue<Result<Position, AppError>?>> {
  CurrentLocationController(this._service) : super(const AsyncValue.data(null));

  final GeolocationService _service;

  Future<void> determine() async {
    state = const AsyncValue.loading();
    try {
      final serviceEnabled = await _service.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = const AsyncValue.data(
          Result<Position, AppError>.failure(AppError.locationServiceDisabled),
        );
        return;
      }

      var permission = await _service.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _service.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = const AsyncValue.data(
          Result<Position, AppError>.failure(AppError.locationPermissionDenied),
        );
        return;
      }

      final position = await _service.getCurrentPosition();
      state = AsyncValue.data(Result<Position, AppError>.success(position));
    } catch (_) {
      state = const AsyncValue.data(
        Result<Position, AppError>.failure(AppError.locationUnavailable),
      );
    }
  }
}

final currentLocationProvider =
    StateNotifierProvider<
      CurrentLocationController,
      AsyncValue<Result<Position, AppError>?>
    >((ref) {
      return CurrentLocationController(ref.watch(geolocationServiceProvider));
    });
