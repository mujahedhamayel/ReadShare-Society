import '/models/models.dart'; // Make sure to import the necessary models

class Comment {
  final User user; // Change from String to User
  final String text;
  final String timeAgo;

  const Comment({
    required this.user,
    required this.text,
    required this.timeAgo,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: User.fromJson(json['user'] ?? {}), // Parse user from JSON
      text: json['text'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
    );
  }
}
