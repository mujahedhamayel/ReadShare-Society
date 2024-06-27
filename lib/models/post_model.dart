import 'user_model.dart';

class Post {
  final User user;
  final String caption;
  final String timeAgo;
  final String? imageUrl; 
  final int likes;
   int comments;
  final int shares;
  final String? imageUrlUser; 
  final String? id;
  final List<String> likedBy;

   Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    this.imageUrl, 
    required this.likes,
    required this.comments,
    required this.shares,
    this.imageUrlUser, 
    this.id,
    required this.likedBy,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      user: User.fromJson(json['user'] ?? {}), 

      caption: json['description'] ?? '', 
      timeAgo: json['createDate'] ?? '', 
      imageUrl: json['imagepost'], 
      likes: (json['Like'] as List).length, 
      comments: (json['comments'] as List).length, 
      shares:
          0, 

      imageUrlUser: json['imageUrl'], 
      id: json['_id'],
      likedBy: List<String>.from(json['Like'] ?? []),
    );
  }
}
