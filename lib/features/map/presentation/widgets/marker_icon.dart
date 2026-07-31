import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/location_pin.dart';

/// Flat 2D parking-spot marker: a rounded "P" badge with a small
/// availability-count badge overflowing its top-right corner.
class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key, required this.pin, required this.selected});

  final LocationPin pin;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final full = pin.isParkingSpot && pin.availableSpots == 0;

    return AnimatedScale(
      scale: selected ? 1.35 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accent
                    : (full ? AppColors.textSecondary : AppColors.textPrimary),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.surface, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                'P',
                style: AppTextStyles.title.copyWith(
                  fontSize: 16,
                  height: 1,
                  color: selected ? AppColors.accentText : AppColors.surface,
                ),
              ),
            ),
            if (pin.isParkingSpot)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: full ? AppColors.error : AppColors.accent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.surface, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 16),
                  child: Text(
                    '${pin.availableSpots}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: full ? AppColors.surface : AppColors.accentText,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
