class PostModel {
  final int id;
  final String user;
  final int likes;
  final String postImage;
  final String caption;
  final String createdAt;
  final String profileImage;
  final String fullName;

  PostModel({
    required this.profileImage,
    required this.id,
    required this.user,
    required this.likes,
    required this.postImage,
    required this.caption,
    required this.createdAt,
    required this.fullName,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      user: json['user'],
      fullName: json['user_firstname']+' '+json['user_lastname'],
      likes: json['likes'],
      postImage: json['post_image'],
      profileImage: json['user_profile_picture'],
      caption: json['caption'],
      createdAt: json['created_at'],
    );
  }
}