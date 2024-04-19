class UserProfile {
  final String username;
  final String fullName;
  final int connectionsCount;
  final String profilePicture;
  final String bio;

  UserProfile({
    required this.username,
    required this.fullName,
    required this.connectionsCount,
    required this.profilePicture,
    required this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['user'],
      fullName: json['user_full_name'],
      connectionsCount: json['connections'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
    );
  }
}