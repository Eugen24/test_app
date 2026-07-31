import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/location_pin.dart';

const _distance = Distance();

/// Game-style "radar" arrow: for a [pin] currently outside the map's visible
/// bounds, points from the edge of [canvasSize] toward the pin's real-world
/// bearing from [center], clamped inside a margin so it never sits under the
/// bottom sheet or the status bar.
class OffScreenIndicator extends StatelessWidget {
  const OffScreenIndicator({
    super.key,
    required this.pin,
    required this.center,
    required this.canvasSize,
    required this.onTap,
  });

  final LocationPin pin;
  final LatLng center;
  final Size canvasSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final target = LatLng(pin.lat, pin.lng);
    final bearingDeg = _distance.bearing(center, target);
    final bearingRad = bearingDeg * math.pi / 180;
    final km = _distance.as(LengthUnit.Kilometer, center, target);

    // North-up screen vector for this bearing (0deg = up, clockwise).
    final dx = math.sin(bearingRad);
    final dy = -math.cos(bearingRad);

    final halfW = canvasSize.width / 2;
    const topMargin = 90.0;
    final bottomMargin = canvasSize.height * 0.34;
    const sideMargin = 24.0;
    final usableHalfH =
        (canvasSize.height - topMargin - bottomMargin) / 2;
    final centerY = topMargin + usableHalfH;

    final tx = dx == 0
        ? double.infinity
        : (halfW - sideMargin) / dx.abs();
    final ty = dy == 0
        ? double.infinity
        : (usableHalfH) / dy.abs();
    final t = math.min(tx, ty);

    final x = halfW + dx * t;
    final y = centerY + dy * t;

    return Positioned(
      left: x - 20,
      top: y - 20,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: bearingRad,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.navigation_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 3),
                ],
              ),
              child: Text(
                km < 1
                    ? '${(km * 1000).round()} m'
                    : '${km.toStringAsFixed(1)} km',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
