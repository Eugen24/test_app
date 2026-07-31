import '../../../core/utils/result.dart';
import 'user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile, AppError>> getProfile();
}
