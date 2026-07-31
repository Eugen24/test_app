import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../domain/location_pin.dart';
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
    final locationsAsync = ref.watch(locationsProvider);

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
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
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
              Text(
                'Nearby Parking',
                style: AppTextStyles.headline.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 16),
              AppSearchBar(
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: 16),
              const CurrentLocationButton(),
              const SizedBox(height: 20),
              _LocationsSection(
                locationsAsync: locationsAsync,
                locations: locations,
                selectedId: selectedId,
                onSelect: (id) =>
                    ref.read(selectedLocationIdProvider.notifier).state = id,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Renders the horizontal list of location cards, distinguishing between
/// the underlying [locationsProvider] still loading, resolving to a
/// [Failure], and resolving to a [Success] whose filtered/searched
/// [locations] happen to be empty.
class _LocationsSection extends StatelessWidget {
  const _LocationsSection({
    required this.locationsAsync,
    required this.locations,
    required this.selectedId,
    required this.onSelect,
  });

  final AsyncValue<Result<List<LocationPin>, AppError>> locationsAsync;
  final List<LocationPin> locations;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (locationsAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final result = locationsAsync.asData?.value;
    if (result is Failure<List<LocationPin>, AppError>) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(result.error.message, style: AppTextStyles.caption),
      );
    }

    if (locations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'No matching locations found.',
          style: AppTextStyles.caption,
        ),
      );
    }

    return SizedBox(
      height: 190,
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
            onTap: () => onSelect(pin.id),
          );
        },
      ),
    );
  }
}
