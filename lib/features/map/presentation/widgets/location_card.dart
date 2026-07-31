import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/shadow_card.dart';
import '../../domain/location_pin.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.pin,
    required this.selected,
    required this.onTap,
    this.rotationDegrees = 0,
  });

  final LocationPin pin;
  final bool selected;
  final VoidCallback onTap;
  final double rotationDegrees;

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      onTap: onTap,
      rotationDegrees: rotationDegrees,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pin.name,
                    style: AppTextStyles.title.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              pin.description,
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
