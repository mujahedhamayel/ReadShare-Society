import '/models/models.dart'; // Make sure to import the necessary models

class Comment {
  final User user;
  final String text;
  final String timeAgo;
  final List<dynamic> likes;
  final String id;

  const Comment({
    required this.user,
    required this.text,
    required this.timeAgo,
    required this.likes,
    required this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: User.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
      timeAgo: json['date'] ?? '',
      likes: json['likes'] ?? [], // Parse likes as a list
      id: json['_id'] ?? '',
    );
  }

  int get likeCount => likes.length; // Helper to get the number of likes
}
