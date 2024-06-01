import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/widgets/post_container.dart';
import 'package:provider/provider.dart';
import '../config/palette.dart';
import '../models/post_model.dart';

import 'package:facebook/utils/api_util.dart';
import 'package:flutter/services.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';
import 'package:facebook/constants.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<ProfilePage> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  List<Post> _posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    String? token = AuthToken().getToken;

    try {
      final response = await http.get(
        Uri.parse('http://$ip:$port/api/posts/me'),
        headers: ApiUtil.headers(token),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['posts'];

        // Add a check to see if data is null
        if (data == null) {
          print('No posts found');
          setState(() {
            _posts = [];
            isLoading = false;
          });
          return;
        }

        setState(() {
          _posts = data.map((json) => Post.fromJson(json)).toList();
          print('Loaded ${_posts.length} posts');
          isLoading = false; // Set loading to false
        });
      } else {
        print('Failed to load posts: ${response.statusCode}');
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Error fetching posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: ProfilePageMobile(
            scrollController: _trackingScrollController,
            user: user!,
            posts: _posts,
            isLoading: isLoading,
          ),
          desktop: ProfilePageDesktop(
            scrollController: _trackingScrollController,
            user: user!,
            posts: _posts,
            isLoading: isLoading,
          ),
          tablet: ProfilePageMobile(
            scrollController: _trackingScrollController,
            user: user!,
            posts: _posts,
            isLoading: isLoading,
          ),
        ),
      ),
    );
  }
}

class ProfilePageMobile extends StatelessWidget {
  final User user;
  final TrackingScrollController scrollController;
  final List<Post> posts;
  final bool isLoading;

  const ProfilePageMobile({
    super.key,
    required this.user,
    required this.scrollController,
    required this.posts,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_outlined),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _TopPortion(user: user),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text("Follow"),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'message',
                        elevation: 0,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(
                    postCount: user.postCounts,
                    followerCount: user.followersCounts,
                    followingCount: user.followingCounts,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (posts.isEmpty) {
                  return const Center(child: Text("No posts available"));
                }
                return PostContainer(post: posts[index]);
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePageDesktop extends StatelessWidget {
  final User user;
  final TrackingScrollController scrollController;
  final List<Post> posts;
  final bool isLoading;

  const ProfilePageDesktop({
    Key? key,
    required this.user,
    required this.scrollController,
    required this.posts,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_outlined),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _TopPortion(user: user),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text("Follow"),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'message',
                        elevation: 0,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(
                    postCount: user.postCounts,
                    followerCount: user.followersCounts,
                    followingCount: user.followingCounts,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (posts.isEmpty) {
                  return const Center(child: Text("No posts available"));
                }
                return PostContainer(post: posts[index]);
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final int? postCount;
  final int? followerCount;
  final int? followingCount;

  const _ProfileInfoRow({
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    print("postCount $postCount");
    print("Followers $followerCount");
    print("Following $followingCount");
    final List<ProfileInfoItem> _items = [
      ProfileInfoItem("Posts", postCount ?? 0),
      ProfileInfoItem("Followers", followerCount ?? 0),
      ProfileInfoItem("Following", followingCount ?? 0),
    ];

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  final User user;

  const _TopPortion({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 100),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Palette.REDcolor, Palette.REDcolor2]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(user.imageUrl!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
