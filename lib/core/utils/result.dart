sealed class Result<T, E> {
  const Result();

  const factory Result.success(T value) = Success<T, E>;
  const factory Result.failure(E error) = Failure<T, E>;

  bool get isSuccess => this is Success<T, E>;

  T? get valueOrNull => switch (this) {
        Success<T, E>(value: final v) => v,
        Failure<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Success<T, E>() => null,
        Failure<T, E>(error: final e) => e,
      };

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success<T, E>(value: final v) => success(v),
      Failure<T, E>(error: final e) => failure(e),
    };
  }
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

enum AppError {
  locationPermissionDenied,
  locationServiceDisabled,
  locationUnavailable,
  notFound,
  unknown,
}

extension AppErrorMessage on AppError {
  String get message => switch (this) {
        AppError.locationPermissionDenied =>
          'Location permission was denied. Enable it in Settings to use your current location.',
        AppError.locationServiceDisabled =>
          'Location services are turned off. Enable them to use your current location.',
        AppError.locationUnavailable =>
          'We couldn\'t determine your current location. Try again.',
        AppError.notFound => 'No matching locations found.',
        AppError.unknown => 'Something went wrong. Please try again.',
      };
}
