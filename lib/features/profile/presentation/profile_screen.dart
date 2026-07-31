import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/result.dart';
import 'providers/profile_providers.dart';
import 'widgets/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: asyncProfile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(AppError.unknown.message, style: AppTextStyles.body),
        ),
        data: (result) => result.when(
          failure: (error) =>
              Center(child: Text(error.message, style: AppTextStyles.body)),
          success: (profile) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      profile.avatarInitial,
                      style: AppTextStyles.headline.copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Hi, ${profile.name.split(' ').first}',
                      style: AppTextStyles.headline.copyWith(fontSize: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      value: '${profile.visitedCount}',
                      label: 'locations visited',
                      rotationDegrees: -2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      value: profile.favoriteSpot,
                      label: 'favorite spot',
                      rotationDegrees: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
