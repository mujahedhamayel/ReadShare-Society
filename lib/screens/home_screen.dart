import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/notifications.dart';
import '/config/palette.dart';
import '/data/data.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';
import 'package:facebook/constants.dart';

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook/screens/ProfilePage.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        Uri.parse('http://$ip:$port/api/posts'),
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: _HomeScreenMobile(
              scrollController: _trackingScrollController,
              posts: _posts,
              isLoading: isLoading),
          desktop: _HomeScreenDesktop(
              scrollController: _trackingScrollController,
              posts: _posts,
              isLoading: isLoading),
          tablet: _HomeScreenMobile(
              scrollController: _trackingScrollController,
              posts: _posts,
              isLoading: isLoading),
        ),
      ),
    );
  }
}

class _HomeScreenMobile extends StatelessWidget {
  final TrackingScrollController scrollController;
  final List<Post> posts;
  final bool isLoading;

  const _HomeScreenMobile({
    required this.scrollController,
    required this.posts,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text(
            'ReadShare',
            style: TextStyle(
              color: Palette.REDcolor,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
          centerTitle: false,
          floating: true,
          actions: [
            CircleButton(
              icon: Icons.search,
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            CircleButton(
              icon: Icons.notifications,
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        const SliverToBoxAdapter(
          child: CreatePostContainer(currentUser: currentUser),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
          sliver: SliverToBoxAdapter(
            child: Rooms(onlineUsers: onlineUsers),
          ),
        ),
        isLoading
            ? SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final Post post = posts[index];
                    return PostContainer(post: post);
                  },
                  childCount: posts.length,
                ),
              ),
      ],
    );
  }
}

class _HomeScreenDesktop extends StatelessWidget {
  final TrackingScrollController scrollController;
  final List<Post> posts;
  final bool isLoading;

  const _HomeScreenDesktop({
    required this.scrollController,
    required this.posts,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: MoreOptionsList(currentUser: currentUser),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 600.0,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: CreatePostContainer(currentUser: currentUser),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                sliver: SliverToBoxAdapter(
                  child: Rooms(onlineUsers: onlineUsers),
                ),
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final Post post = posts[index];
                          return PostContainer(post: post);
                        },
                        childCount: posts.length,
                      ),
                    ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ContactsList(users: onlineUsers),
            ),
          ),
        ),
      ],
    );
  }
}
