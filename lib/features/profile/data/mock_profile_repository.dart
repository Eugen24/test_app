import '../../../core/utils/result.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<Result<UserProfile, AppError>> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const Result.success(
      UserProfile(
        name: 'Alex Rivera',
        avatarInitial: 'A',
        visitedCount: 12,
        favoriteSpot: 'Riverside Park',
      ),
    );
  }
}
