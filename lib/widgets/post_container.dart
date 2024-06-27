import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/CommentsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/config/palette.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class PostContainer extends StatefulWidget {
  final Post post;

  const PostContainer({
    super.key,
    required this.post,
  });

  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  
  late bool isLiked;
  late int likeCount;
    late int commentCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;
     commentCount = widget.post.comments;
    // Check if the current user has liked the post
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    isLiked = widget.post.likedBy.contains(currentUser?.id);
  }

  Future<void> likePost(String postId) async {
    String token = AuthToken().getToken;
    final String baseUrl = 'http://$ip:$port/api/posts';

    final response = await http.post(
      Uri.parse('$baseUrl/$postId/like'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like the post');
    }
  }

 void _toggleLike() async {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    if (currentUser == null) return;

    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
        widget.post.likedBy.add(currentUser.id);
      } else {
        likeCount--;
        widget.post.likedBy.remove(currentUser.id);
      }
    });

    try {
      await likePost(widget.post.id!);
    } catch (e) {
      // Revert the state if the API call fails
      setState(() {
        isLiked = !isLiked;
        if (isLiked) {
          likeCount++;
          widget.post.likedBy.add(currentUser.id);
        } else {
          likeCount--;
          widget.post.likedBy.remove(currentUser.id);
        }
      });
      print('Failed to like/unlike the post: $e');
    }
  }

    void _navigateToComments() async {
    final updatedComments = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(
          post: widget.post,
          updateCommentCount: (count) {
            setState(() {
              commentCount = count;
            });
          },
        ),
      ),
    );

    if (updatedComments != null) {
      setState(() {
        commentCount = updatedComments;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: isDesktop ? 5.0 : 0.0,
      ),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(post: widget.post),
                  const SizedBox(height: 4.0),
                  Text(widget.post.caption),
                  if (widget.post.imageUrl != null &&
                      widget.post.imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                          CachedNetworkImage(imageUrl: widget.post.imageUrl!),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _PostStats(
                post: widget.post,
                isLiked: isLiked,
                likeCount: likeCount,
                commentCount: commentCount,

                onLikePressed: _toggleLike,
                onCommentPressed: _navigateToComments,
              ),
            ),
          ],
        ),
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

class _PostStats extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final int likeCount;
    final int commentCount;

  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;

  const _PostStats({
    required this.post,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.onLikePressed,
    required this.onCommentPressed,
  });

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Palette.REDcolor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                '$likeCount',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '$commentCount Comments',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        const Divider(),
        Row(
          children: [
            _PostButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                color: isLiked ? Palette.REDcolor : Colors.grey[600],
                size: 20.0,
              ),
              label: 'Like',
              onTap: onLikePressed,
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.commentOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Comment',
              onTap: onCommentPressed,
            ),
          ],
        ),
      ],
    );
  }
}
class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  const _PostButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
