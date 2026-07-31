import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/location_pin.dart';
import 'providers/location_providers.dart';
import 'widgets/bottom_panel.dart';
import 'widgets/marker_icon.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  static const _initialCenter = LatLng(37.7768, -122.4210);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(filteredLocationsProvider);
    final selectedId = ref.watch(selectedLocationIdProvider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 14,
              minZoom: 3,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                        onTap: () =>
                            ref
                                    .read(selectedLocationIdProvider.notifier)
                                    .state =
                                pin.id,
                        child: MarkerIcon(selected: pin.id == selectedId),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: _ProfileButton(),
          ),
          const Align(alignment: Alignment.bottomCenter, child: BottomPanel()),
        ],
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
