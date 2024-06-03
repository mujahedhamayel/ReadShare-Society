import 'dart:io';

import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/responsive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/widgets/post_container.dart';
import 'package:image_picker/image_picker.dart';
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
  final User? user;
  const ProfilePage({super.key, this.user});

  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<ProfilePage> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  List<Post> _posts = [];
  bool isLoading = true;
  bool isFollowing = false;
  int followerCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _checkIfFollowing();
    if (widget.user != null) {
      followerCount = widget.user!.followersCounts ?? 0;
    }
  }

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    String? token = AuthToken().getToken;
    String url = 'http://$ip:$port/api/posts/';
    if (widget.user == null) {
      url += 'me';
    } else {
      url += 'user/${widget.user!.id}';
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['posts'];

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
          isLoading = false;
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

  Future<void> _checkIfFollowing() async {
    String? token = AuthToken().getToken;
    String url = 'http://$ip:$port/api/users/${widget.user!.id}/is-following';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFollowing = jsonDecode(response.body)['isFollowing'];
        });
      } else {
        print('Failed to check following status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking following status: $e');
    }
  }

  Future<void> _followUser() async {
    String? token = AuthToken().getToken;
    String url = 'http://$ip:$port/api/users/${widget.user!.id}/follow';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFollowing = !isFollowing;
          followerCount += isFollowing ? 1 : -1;
        });
      } else {
        print('Failed to follow/unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error following/unfollowing user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context).user;
    final user = widget.user ?? providerUser;
    if (user != null && user.followersCounts != null) {
      followerCount = user.followersCounts!;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: ProfilePageMobile(
            scrollController: _trackingScrollController,
            user: user!,
            posts: _posts,
            isLoading: isLoading,
            isFollowing: isFollowing,
            followerCount: followerCount,
            onFollowPressed: _followUser,
          ),
          desktop: ProfilePageDesktop(
            scrollController: _trackingScrollController,
            user: user,
            posts: _posts,
            isLoading: isLoading,
            isFollowing: isFollowing,
            followerCount: followerCount,
            onFollowPressed: _followUser,
          ),
          tablet: ProfilePageMobile(
            scrollController: _trackingScrollController,
            user: user!,
            posts: _posts,
            isLoading: isLoading,
            isFollowing: isFollowing,
            followerCount: followerCount,
            onFollowPressed: _followUser,
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
  final bool isFollowing;
  final int followerCount;
  final VoidCallback onFollowPressed;

  const ProfilePageMobile({
    super.key,
    required this.user,
    required this.scrollController,
    required this.posts,
    required this.isLoading,
    required this.isFollowing,
    required this.followerCount,
    required this.onFollowPressed,
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
                        onPressed: onFollowPressed,
                        heroTag: 'follow',
                        elevation: 0,
                        label: Text(isFollowing ? 'Following' : 'Follow'),
                        icon: Icon(
                            isFollowing ? Icons.check : Icons.person_add_alt_1),
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
                    postCount: user.postCounts ?? 0,
                    followerCount: followerCount,
                    followingCount: user.followingCounts ?? 0,
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
  final bool isFollowing;
  final int followerCount;
  final VoidCallback onFollowPressed;

  const ProfilePageDesktop({
    Key? key,
    required this.user,
    required this.scrollController,
    required this.posts,
    required this.isLoading,
    required this.isFollowing,
    required this.followerCount,
    required this.onFollowPressed,
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
                        onPressed: onFollowPressed,
                        heroTag: 'follow',
                        elevation: 0,
                        label: Text(isFollowing ? 'Following' : 'Follow'),
                        icon: Icon(
                            isFollowing ? Icons.check : Icons.person_add_alt_1),
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
                    postCount: user.postCounts ?? 0,
                    followerCount: followerCount,
                    followingCount: user.followingCounts ?? 0,
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

class _TopPortion extends StatefulWidget {
  final User user;

  const _TopPortion({
    super.key,
    required this.user,
  });

  @override
  __TopPortionState createState() => __TopPortionState();
}

class __TopPortionState extends State<_TopPortion> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.user.imageUrl!;
  }

  Future<void> _changeProfilePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Show a loading indicator while the image is being uploaded
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Initialize Firebase
        await Firebase.initializeApp();

        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_photos/${widget.user.id}.jpg');
        await storageRef.putFile(File(pickedFile.path));

        // Get the download URL
        final downloadUrl = await storageRef.getDownloadURL();

        // Update the user's profile photo URL in the backend
        await _updateUserProfilePhoto(downloadUrl);

        // Close the loading indicator
        Navigator.of(context).pop();

        // Update the state with the new image URL
        setState(() {
          imageUrl = downloadUrl;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile photo updated successfully!')),
        );
      } catch (e) {
        // Close the loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile photo: $e')),
        );
      }
    }
  }

  Future<void> _updateUserProfilePhoto(String downloadUrl) async {
    // Make a request to your backend to update the user's profile photo URL
    String? token = AuthToken().getToken;
    String url = 'http://$ip:$port/api/users/${widget.user.id}/update-photo';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
        body: jsonEncode({'imageUrl': downloadUrl}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile photo');
      }
    } catch (e) {
      throw Exception('Error updating profile photo: $e');
    }
  }

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
                          image: NetworkImage(imageUrl),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () => _changeProfilePhoto(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.user.name,
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
