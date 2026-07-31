import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ShadowCard extends StatelessWidget {
  const ShadowCard({
    super.key,
    required this.child,
    this.rotationDegrees = 0,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final double rotationDegrees;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    final rotated = rotationDegrees == 0
        ? card
        : Transform.rotate(angle: rotationDegrees * math.pi / 180, child: card);

    if (onTap == null) return rotated;
    return GestureDetector(onTap: onTap, child: rotated);
  }
}
