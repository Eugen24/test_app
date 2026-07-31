import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/result.dart';

class CurrentLocationController
    extends StateNotifier<AsyncValue<Result<Position, AppError>?>> {
  CurrentLocationController() : super(const AsyncValue.data(null));

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

final currentLocationProvider =
    StateNotifierProvider<
      CurrentLocationController,
      AsyncValue<Result<Position, AppError>?>
    >((ref) {
      return CurrentLocationController();
    });
