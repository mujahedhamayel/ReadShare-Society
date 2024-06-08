import 'user_model.dart';

class Post {
  final User user;
  final String caption;
  final String timeAgo;
  final String? imageUrl; // Make imageUrl nullable
  final int likes;
  final int comments;
  final int shares;
  final String? imageUrlUser; // Make imageUrl nullable
  final String? id;
  final List<String> likedBy;

  const Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    this.imageUrl, // Allow null values
    required this.likes,
    required this.comments,
    required this.shares,
    this.imageUrlUser, // Allow null values
    this.id,
    required this.likedBy,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      user: User.fromJson(json['user'] ?? {}), // Handle null user

      caption: json['description'] ?? '', // Provide a default value if null
      timeAgo: json['createDate'] ?? '', // Provide a default value if null
      imageUrl: json['imagepost'], // This can be null
      likes: (json['Like'] as List).length, // Count the likes
      comments: (json['comments'] as List).length, // Count the comments
      shares:
          0, // Assuming shares is not available in your JSON and default to 0

      imageUrlUser: json['imageUrl'], // This can be null
      id: json['_id'],
      likedBy: List<String>.from(json['Like'] ?? []),
    );
  }
}
