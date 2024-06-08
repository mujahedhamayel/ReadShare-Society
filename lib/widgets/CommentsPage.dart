import 'dart:convert';

import 'package:facebook/config/palette.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/models/comment_model.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/models/models.dart';
import 'package:http/http.dart' as http;

class CommentsPage extends StatefulWidget {
  final Post post;

  const CommentsPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  final String baseUrl = 'http://$ip:$port/api';

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    String token = AuthToken().getToken;
    final response = await http.get(
      Uri.parse('$baseUrl/posts/${widget.post.id}/comments'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> commentData = json.decode(response.body);
      setState(() {
        _comments
            .addAll(commentData.map((data) => Comment.fromJson(data)).toList());
      });
    } else {
      print('Failed to load comments');
    }
  }

  Future<void> _addComment() async {
    String token = AuthToken().getToken;

    final providerUser = Provider.of<UserProvider>(context, listen: false).user;

    if (_commentController.text.isNotEmpty && providerUser != null) {
      // Create a new comment object
      final newComment = Comment(
        user: providerUser,
        text: _commentController.text,
        timeAgo: 'Just now',
        likes: [],
        id: 'temporary_id', // Use a temporary ID for optimistic update
      );

      // Optimistically add the comment to the list
      setState(() {
        _comments.add(newComment);
        _commentController.clear();
      });

      // Perform the network request
      final response = await http.post(
        Uri.parse('$baseUrl/posts/${widget.post.id}/comment'),
        headers: ApiUtil.headers(token),
        body: json.encode({'text': newComment.text}),
      );

      if (response.statusCode == 201) {
        final Comment addedComment =
            Comment.fromJson(json.decode(response.body));
        setState(() {
          // Replace the temporary comment with the actual comment from the server
          _comments[_comments.indexOf(newComment)] = addedComment;
        });
      } else {
        // If the request fails, remove the optimistic comment and show an error
        setState(() {
          _comments.remove(newComment);
        });
        print('Failed to add comment');
      }
    }
  }
  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  //     setState(() {
  //       _comments.add(Comment(
  //         user: currentUser,
  //         text: _commentController.text,
  //         timeAgo: 'Just now',
  //       ));
  //       _commentController.clear();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _PostHeader(post: widget.post),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(widget.post.caption),
                  ),
                  if (widget.post.imageUrl != null &&
                      widget.post.imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                          CachedNetworkImage(imageUrl: widget.post.imageUrl!),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return ListTile(
                        leading: ProfileAvatar(
                          user: comment.user,
                          isActive: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user: comment.user),
                              ),
                            );
                          },
                        ),
                        title: Text(comment.user.name),
                        subtitle: Text(comment.text),
                         trailing: Text(formatDate(comment.timeAgo)),
                        onTap: () {
                          setState(() {
                            _commentController.text = comment.text;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                RawMaterialButton(
                  padding: const EdgeInsets.all(12.0),
                  fillColor: Palette.REDcolor, // Changed color to red
                  elevation: 0.0,
                  shape: const CircleBorder(),
                  onPressed: _addComment,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;

  const _PostHeader({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          user: post.user,
          isActive: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: post.user),
              ),
            );
          },
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${post.timeAgo} • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  )
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () => print('More'),
        ),
      ],
    );
  }
}
