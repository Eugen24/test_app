import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/result.dart';

class CurrentLocationController
    extends StateNotifier<AsyncValue<Result<Position, AppError>>> {
  CurrentLocationController() : super(AsyncValue.data(Success(_idle)));

  static final _idle = _IdlePosition();

  Future<void> determine() async {
    state = const AsyncValue.loading();
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = const AsyncValue.data(
          Result<Position, AppError>.failure(AppError.locationServiceDisabled),
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = const AsyncValue.data(
          Result<Position, AppError>.failure(AppError.locationPermissionDenied),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      state = AsyncValue.data(Result<Position, AppError>.success(position));
    } catch (_) {
      state = const AsyncValue.data(
        Result<Position, AppError>.failure(AppError.locationUnavailable),
      );
    }
  }
}

class _IdlePosition extends Position {
  _IdlePosition()
      : super(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(0),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
}

final currentLocationProvider = StateNotifierProvider<CurrentLocationController,
    AsyncValue<Result<Position, AppError>>>((ref) {
  return CurrentLocationController();
});
