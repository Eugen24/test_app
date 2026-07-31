import '../../../core/utils/result.dart';
import '../domain/location_pin.dart';
import '../domain/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  static final _seed = <LocationPin>[
    const LocationPin(
      id: 'loc-1',
      name: 'Nobil Tower Office Parking',
      description: 'Secure underground lot beneath a Class A office tower.',
      category: 'office',
      address: 'Bd. Ștefan cel Mare 202, Chișinău',
      lat: 47.0245,
      lng: 28.8324,
      totalSpots: 40,
      availableSpots: 12,
      pricePerHour: 15,
    ),
    const LocationPin(
      id: 'loc-2',
      name: 'Hotel Codru Guest Parking',
      description: 'Covered hotel lot, open to guests and drivers passing through.',
      category: 'hotel',
      address: 'Bd. Negruzzi 4, Chișinău',
      lat: 47.0169,
      lng: 28.8497,
      totalSpots: 25,
      availableSpots: 6,
      pricePerHour: 20,
    ),
    const LocationPin(
      id: 'loc-3',
      name: 'Botanica Residence Yard',
      description: 'Gated residential complex parking, unused spots reserved by neighbors.',
      category: 'residential',
      address: 'Str. Independenței 15, Chișinău',
      lat: 46.9897,
      lng: 28.8394,
      totalSpots: 18,
      availableSpots: 9,
      pricePerHour: 10,
    ),
    const LocationPin(
      id: 'loc-4',
      name: 'Centru Business Hub Lot',
      description: 'Open-air lot behind a downtown coworking building.',
      category: 'office',
      address: 'Str. Columna 65, Chișinău',
      lat: 47.0245,
      lng: 28.8261,
      totalSpots: 30,
      availableSpots: 0,
      pricePerHour: 18,
    ),
    const LocationPin(
      id: 'loc-5',
      name: 'Riverside Hotel Parking',
      description: 'Riverside hotel lot with easy access to the Bâc embankment.',
      category: 'hotel',
      address: 'Str. Bănulescu-Bodoni 57, Chișinău',
      lat: 47.0129,
      lng: 28.8353,
      totalSpots: 22,
      availableSpots: 14,
      pricePerHour: 16,
    ),
    const LocationPin(
      id: 'loc-6',
      name: 'Telecentru Complex Yard',
      description: 'Residential complex yard, reservable evenings and weekends.',
      category: 'residential',
      address: 'Str. Alba Iulia 75, Chișinău',
      lat: 47.0079,
      lng: 28.8127,
      totalSpots: 20,
      availableSpots: 5,
      pricePerHour: 8,
    ),
  ];

  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return Result.success(List.unmodifiable(_seed));
  }
}
