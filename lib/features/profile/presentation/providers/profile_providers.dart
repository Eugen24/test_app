import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
import '../../data/mock_profile_repository.dart';
import '../../domain/user_profile.dart';

final profileRepositoryProvider = Provider((ref) => MockProfileRepository());

final profileProvider =
    FutureProvider<Result<UserProfile, AppError>>((ref) async {
  return ref.watch(profileRepositoryProvider).getProfile();
});
