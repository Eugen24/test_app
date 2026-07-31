import '../../../core/utils/result.dart';
import 'location_pin.dart';

abstract class LocationRepository {
  Future<Result<List<LocationPin>, AppError>> getLocations();
}
