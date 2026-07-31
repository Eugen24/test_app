import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/location_pin.dart';
import 'providers/current_location_provider.dart';
import 'providers/location_providers.dart';
import 'widgets/bottom_panel.dart';
import 'widgets/current_location_marker.dart';
import 'widgets/marker_icon.dart';
import 'widgets/off_screen_indicator.dart';
import 'widgets/parking_detail_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static const _initialCenter = LatLng(47.0105, 28.8638); // Chișinău

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  MapCamera? _camera;

  @override
  void initState() {
    super.initState();
    // onPositionChanged only fires on subsequent moves, not the initial
    // placement, so read the camera once the map has attached.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _camera = _mapController.camera);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _selectAndShow(LocationPin pin) {
    ref.read(selectedLocationIdProvider.notifier).state = pin.id;
    ParkingDetailSheet.show(context, pin);
  }

  void _zoomBy(double delta) {
    final camera = _camera;
    if (camera == null) return;
    _mapController.move(camera.center, camera.zoom + delta);
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(filteredLocationsProvider);
    final selectedId = ref.watch(selectedLocationIdProvider);
    final currentLocationState = ref.watch(currentLocationProvider);
    final currentPosition = currentLocationState.asData?.value?.valueOrNull;

    ref.listen<String?>(selectedLocationIdProvider, (previous, next) {
      if (next == null) return;
      final pins = ref.read(filteredLocationsProvider);
      final match = pins.where((pin) => pin.id == next);
      if (match.isEmpty) return;
      final pin = match.first;
      _mapController.move(LatLng(pin.lat, pin.lng), 15);
    });

    // Zoom in on the user's position as soon as a fix is acquired.
    ref.listen(currentLocationProvider, (previous, next) {
      final wasNull = previous?.asData?.value?.valueOrNull == null;
      final position = next.asData?.value?.valueOrNull;
      if (wasNull && position != null) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          16,
        );
      }
    });

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasSize = constraints.biggest;
          final camera = _camera;
          final offScreenPins = camera == null
              ? const <LocationPin>[]
              : locations
                    .where(
                      (pin) =>
                          !camera.visibleBounds.contains(
                            LatLng(pin.lat, pin.lng),
                          ),
                    )
                    .toList();

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: MapScreen._initialCenter,
                  initialZoom: 14,
                  minZoom: 3,
                  maxZoom: 18,
                  onPositionChanged: (camera, hasGesture) {
                    setState(() => _camera = camera);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.test_app',
                  ),
                  MarkerLayer(
                    markers: [
                      for (final LocationPin pin in locations)
                        Marker(
                          point: LatLng(pin.lat, pin.lng),
                          width: 44,
                          height: 44,
                          child: GestureDetector(
                            onTap: () => _selectAndShow(pin),
                            child: MarkerIcon(
                              pin: pin,
                              selected: pin.id == selectedId,
                            ),
                          ),
                        ),
                      if (currentPosition != null)
                        Marker(
                          point: LatLng(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          width: 48,
                          height: 48,
                          child: const CurrentLocationMarker(),
                        ),
                    ],
                  ),
                ],
              ),
              if (camera != null)
                for (final pin in offScreenPins)
                  OffScreenIndicator(
                    key: ValueKey('offscreen-${pin.id}'),
                    pin: pin,
                    center: camera.center,
                    canvasSize: canvasSize,
                    onTap: () =>
                        ref.read(selectedLocationIdProvider.notifier).state =
                            pin.id,
                  ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16,
                child: _ProfileButton(),
              ),
              Positioned(
                right: 16,
                bottom: canvasSize.height * 0.4,
                child: _ZoomControls(
                  onZoomIn: () => _zoomBy(1),
                  onZoomOut: () => _zoomBy(-1),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomPanel(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => GoRouter.of(context).push('/map/profile'),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.person_rounded, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({required this.onZoomIn, required this.onZoomOut});

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(icon: Icons.add_rounded, onTap: onZoomIn),
          Container(height: 1, width: 28, color: AppColors.background),
          _ZoomButton(icon: Icons.remove_rounded, onTap: onZoomOut),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
