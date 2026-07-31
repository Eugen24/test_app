class UserProfile {
  const UserProfile({
    required this.name,
    required this.avatarInitial,
    required this.visitedCount,
    required this.favoriteSpot,
  });

  final String name;
  final String avatarInitial;
  final int visitedCount;
  final String favoriteSpot;
}
