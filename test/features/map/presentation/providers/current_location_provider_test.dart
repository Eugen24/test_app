import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/utils/result.dart';
import 'package:test_app/features/map/domain/geolocation_service.dart';
import 'package:test_app/features/map/presentation/providers/current_location_provider.dart';

class MockGeolocationService extends Mock implements GeolocationService {}

Position _samplePosition() => Position(
  latitude: 37.7749,
  longitude: -122.4194,
  timestamp: DateTime.fromMillisecondsSinceEpoch(0),
  accuracy: 5,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

void main() {
  setUpAll(() {
    registerFallbackValue(LocationPermission.denied);
  });

  late MockGeolocationService mockService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockGeolocationService();
    container = ProviderContainer(
      overrides: [geolocationServiceProvider.overrideWithValue(mockService)],
    );
    addTearDown(container.dispose);
  });

  test('location services disabled results in failure state', () async {
    when(
      () => mockService.isLocationServiceEnabled(),
    ).thenAnswer((_) async => false);

    await container.read(currentLocationProvider.notifier).determine();

    final state = container.read(currentLocationProvider);
    expect(state.value?.errorOrNull, AppError.locationServiceDisabled);
  });

  test(
    'permission denied and re-request also denied results in failure state',
    () async {
      when(
        () => mockService.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockService.checkPermission(),
      ).thenAnswer((_) async => LocationPermission.denied);
      when(
        () => mockService.requestPermission(),
      ).thenAnswer((_) async => LocationPermission.denied);

      await container.read(currentLocationProvider.notifier).determine();

      final state = container.read(currentLocationProvider);
      expect(state.value?.errorOrNull, AppError.locationPermissionDenied);
    },
  );

  test('permission granted resolves to a successful position', () async {
    final position = _samplePosition();
    when(
      () => mockService.isLocationServiceEnabled(),
    ).thenAnswer((_) async => true);
    when(
      () => mockService.checkPermission(),
    ).thenAnswer((_) async => LocationPermission.always);
    when(
      () => mockService.getCurrentPosition(),
    ).thenAnswer((_) async => position);

    await container.read(currentLocationProvider.notifier).determine();

    final state = container.read(currentLocationProvider);
    expect(state.value?.valueOrNull, position);
    verify(() => mockService.getCurrentPosition()).called(1);
  });

  test('getCurrentPosition throwing results in failure state', () async {
    when(
      () => mockService.isLocationServiceEnabled(),
    ).thenAnswer((_) async => true);
    when(
      () => mockService.checkPermission(),
    ).thenAnswer((_) async => LocationPermission.always);
    when(() => mockService.getCurrentPosition()).thenThrow(Exception('boom'));

    await container.read(currentLocationProvider.notifier).determine();

    final state = container.read(currentLocationProvider);
    expect(state.value?.errorOrNull, AppError.locationUnavailable);
  });
}
