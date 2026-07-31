/// A plain lat/lng pair, independent of any map-rendering package. Used for
/// [LocationPin.boundary] so the domain layer never depends on `latlong2` or
/// `flutter_map` — those live only at the presentation edge that draws them.
class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;
}
