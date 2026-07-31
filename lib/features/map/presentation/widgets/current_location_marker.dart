import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A distinct, animated marker showing the user's acquired current-location
/// position: a pulsing outer ring plus a solid dot, visually different from
/// the [MarkerIcon] pins used for parking results.
class CurrentLocationMarker extends StatefulWidget {
  const CurrentLocationMarker({super.key});

  @override
  State<CurrentLocationMarker> createState() => _CurrentLocationMarkerState();
}

class _CurrentLocationMarkerState extends State<CurrentLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - t).clamp(0.0, 1.0),
                child: Container(
                  width: 16 + t * 32,
                  height: 16 + t * 32,
                  decoration: BoxDecoration(
                    color: AppColors.userLocation.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.userLocation,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
