import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.35 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.textPrimary,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.place_rounded,
          size: 18,
          color: selected ? AppColors.accentText : AppColors.surface,
        ),
      ),
    );
  }
}
