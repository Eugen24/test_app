import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../providers/current_location_provider.dart';

class CurrentLocationButton extends ConsumerWidget {
  const CurrentLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentLocationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PillButton(
          label: 'Use Current Location',
          icon: Icons.my_location_rounded,
          onPressed: () =>
              ref.read(currentLocationProvider.notifier).determine(),
        ),
        state.when(
          data: (result) => result.when(
            success: (_) => const SizedBox.shrink(),
            failure: (error) => Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                error.message,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 8, left: 4),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
