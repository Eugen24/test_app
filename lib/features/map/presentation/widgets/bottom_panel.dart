import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/location_providers.dart';
import 'current_location_button.dart';
import 'location_card.dart';
import 'search_bar.dart';

class BottomPanel extends ConsumerWidget {
  const BottomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(filteredLocationsProvider);
    final selectedId = ref.watch(selectedLocationIdProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.36,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: Offset(0, -6)),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
              const SizedBox(height: 16),
              Text('Nearby', style: AppTextStyles.headline.copyWith(fontSize: 26)),
              const SizedBox(height: 16),
              AppSearchBar(
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: 16),
              const CurrentLocationButton(),
              const SizedBox(height: 20),
              if (locations.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('No matching locations found.', style: AppTextStyles.caption),
                )
              else
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: locations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final pin = locations[index];
                      return LocationCard(
                        pin: pin,
                        selected: pin.id == selectedId,
                        rotationDegrees: index.isEven ? -1.5 : 1.5,
                        onTap: () =>
                            ref.read(selectedLocationIdProvider.notifier).state = pin.id,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
