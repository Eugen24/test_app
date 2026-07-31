import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
import '../../data/mock_location_repository.dart';
import '../../domain/location_pin.dart';
import '../../domain/location_repository.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});

final locationsProvider =
    FutureProvider<Result<List<LocationPin>, AppError>>((ref) async {
  final repo = ref.watch(locationRepositoryProvider);
  return repo.getLocations();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedLocationIdProvider = StateProvider<String?>((ref) => null);

final filteredLocationsProvider = Provider<List<LocationPin>>((ref) {
  final asyncResult = ref.watch(locationsProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  final locations = asyncResult.maybeWhen(
    data: (result) => result.valueOrNull ?? const <LocationPin>[],
    orElse: () => const <LocationPin>[],
  );

  if (query.isEmpty) return locations;
  return locations
      .where((l) => l.name.toLowerCase().contains(query))
      .toList(growable: false);
});
