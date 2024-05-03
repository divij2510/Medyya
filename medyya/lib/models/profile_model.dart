class UserProfile {
  final String username;
  final String firstName;
  final int? connectionsCount;
  final String lastName;
  final String profilePicture;
  final String bio;

  UserProfile({
    required this.username,
    required this.firstName,
    this.connectionsCount,
    required this.lastName,
    required this.profilePicture,
    required this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['user'],
      firstName: json['user_first_name'],
      lastName: json['user_last_name'],
      connectionsCount: json['connections'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'connections': connectionsCount,
      'profile_picture': profilePicture,
      'bio': bio,
    };
  }
}