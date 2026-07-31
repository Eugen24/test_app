import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/utils/result.dart';
import 'package:test_app/features/map/domain/geo_position.dart';
import 'package:test_app/features/map/domain/geolocation_service.dart';
import 'package:test_app/features/map/presentation/providers/current_location_provider.dart';

class MockGeolocationService extends Mock implements GeolocationService {}

const _samplePosition = GeoPosition(lat: 37.7749, lng: -122.4194);

void main() {
  setUpAll(() {
    registerFallbackValue(LocationPermissionStatus.denied);
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
      ).thenAnswer((_) async => LocationPermissionStatus.denied);
      when(
        () => mockService.requestPermission(),
      ).thenAnswer((_) async => LocationPermissionStatus.denied);

      await container.read(currentLocationProvider.notifier).determine();

      final state = container.read(currentLocationProvider);
      expect(state.value?.errorOrNull, AppError.locationPermissionDenied);
    },
  );

  test('permission granted resolves to a successful position', () async {
    when(
      () => mockService.isLocationServiceEnabled(),
    ).thenAnswer((_) async => true);
    when(
      () => mockService.checkPermission(),
    ).thenAnswer((_) async => LocationPermissionStatus.granted);
    when(
      () => mockService.getCurrentPosition(),
    ).thenAnswer((_) async => _samplePosition);

    await container.read(currentLocationProvider.notifier).determine();

    final state = container.read(currentLocationProvider);
    expect(state.value?.valueOrNull, _samplePosition);
    verify(() => mockService.getCurrentPosition()).called(1);
  });

  test('getCurrentPosition throwing results in failure state', () async {
    when(
      () => mockService.isLocationServiceEnabled(),
    ).thenAnswer((_) async => true);
    when(
      () => mockService.checkPermission(),
    ).thenAnswer((_) async => LocationPermissionStatus.granted);
    when(() => mockService.getCurrentPosition()).thenThrow(Exception('boom'));

    await container.read(currentLocationProvider.notifier).determine();

    final state = container.read(currentLocationProvider);
    expect(state.value?.errorOrNull, AppError.locationUnavailable);
  });
}
