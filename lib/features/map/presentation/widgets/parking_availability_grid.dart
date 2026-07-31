import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Flat 2D layout of a parking lot's occupancy: one cell per spot (capped),
/// green = available, dark = taken. A compact visual stand-in for "how full
/// is this lot right now" that reads faster than a raw fraction.
class ParkingAvailabilityGrid extends StatelessWidget {
  const ParkingAvailabilityGrid({
    super.key,
    required this.totalSpots,
    required this.availableSpots,
    this.maxCells = 10,
    this.cellSize = 7,
  });

  final int totalSpots;
  final int availableSpots;
  final int maxCells;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    final cellCount = totalSpots.clamp(1, maxCells);
    final availableCells = totalSpots == 0
        ? 0
        : (availableSpots / totalSpots * cellCount).round().clamp(
            0,
            cellCount,
          );

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(cellCount, (index) {
        final isAvailable = index < availableCells;
        return Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.accent : AppColors.textSecondary,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
