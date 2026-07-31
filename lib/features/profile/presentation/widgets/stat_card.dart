import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/shadow_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.rotationDegrees = 0,
  });

  final String value;
  final String label;
  final double rotationDegrees;

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      rotationDegrees: rotationDegrees,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppTextStyles.statNumber),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
