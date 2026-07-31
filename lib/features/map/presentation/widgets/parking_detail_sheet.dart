import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../domain/location_pin.dart';
import 'parking_availability_grid.dart';

/// Demo detail view for a single parking spot, opened by tapping a
/// [LocationCard] or marker. "Reserve" is a mocked action — there is no
/// backend, per the assignment brief — it just confirms with a snackbar.
class ParkingDetailSheet extends StatelessWidget {
  const ParkingDetailSheet({super.key, required this.pin});

  final LocationPin pin;

  static Future<void> show(BuildContext context, LocationPin pin) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ParkingDetailSheet(pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final full = pin.isParkingSpot && pin.availableSpots == 0;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    pin.name,
                    style: AppTextStyles.headline.copyWith(fontSize: 24),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: pin.category == 'office'
                        ? AppColors.accent
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    pin.category,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (pin.address != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(pin.address!, style: AppTextStyles.caption),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Text(pin.description, style: AppTextStyles.body),
            if (pin.isParkingSpot) ...[
              const SizedBox(height: 24),
              Text('Availability', style: AppTextStyles.title.copyWith(fontSize: 14)),
              const SizedBox(height: 10),
              ParkingAvailabilityGrid(
                totalSpots: pin.totalSpots!,
                availableSpots: pin.availableSpots!,
                cellSize: 12,
              ),
              const SizedBox(height: 10),
              Text(
                full
                    ? 'Fully booked right now'
                    : '${pin.availableSpots} of ${pin.totalSpots} spots free',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: full ? AppColors.error : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              if (pin.pricePerHour != null)
                Row(
                  children: [
                    Text(
                      '${pin.pricePerHour!.toStringAsFixed(0)} MDL',
                      style: AppTextStyles.headline.copyWith(fontSize: 22),
                    ),
                    Text(' / hour', style: AppTextStyles.caption),
                  ],
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: PillButton(
                    label: full ? 'Fully Booked' : 'Reserve Spot',
                    icon: full ? Icons.block_rounded : Icons.qr_code_2_rounded,
                    onPressed: full
                        ? () {}
                        : () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Reserved "${pin.name}" — demo only, no real booking.',
                                ),
                              ),
                            );
                          },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
