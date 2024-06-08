// import 'dart:convert';
// import 'package:facebook/constants.dart';
// import 'package:facebook/utils/api_util.dart';
// import 'package:facebook/utils/auth_token.dart';
// import 'package:http/http.dart' as http;
// import '../models/comment_model.dart';

// class CommentService {
//   final String apiUrl = 'http://$ip:$port/api/posts';

//    Future<void> _fetchComments() async {
//     String token = AuthToken().getToken;
//     final response = await http.get(
//       Uri.parse('$baseUrl/posts/${widget.post.id}/comments'),
//       headers: ApiUtil.headers(token),
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> commentData = json.decode(response.body);
//       setState(() {
//         _comments
//             .addAll(commentData.map((data) => Comment.fromJson(data)).toList());
//       });
//     } else {
//       print('Failed to load comments');
//     }
//   }

//   Future<void> _addComment(postId) async {
//     String token = AuthToken().getToken;
//     if (_commentController.text.isNotEmpty) {
//       final response = await http.post(
//         Uri.parse('$baseUrl/posts/${widget.post.id}/comment'),
//         headers: ApiUtil.headers(token),
//         body: json.encode({'text': _commentController.text}),
//       );

//       if (response.statusCode == 201) {
//         final Comment newComment = Comment.fromJson(json.decode(response.body));
//         setState(() {
//           _comments.add(newComment);
//           _commentController.clear();
//         });
//       } else {
//         print('Failed to add comment');
//       }
//     }
//   }