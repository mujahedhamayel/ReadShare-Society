import 'package:facebook/providers/followed_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/palette.dart';
import '../models/user_model.dart';
import '../providers/followed_user_provider.dart';
import '../services/user_service.dart';
import '../widgets/user_card.dart';
import 'chatscreen.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _allUserListFuture;
  late Future<List<User>> _chattedUserListFuture;
  TextEditingController _searchController = TextEditingController();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  List<User> _chattedUsers = [];
  List<User> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final followedUsersProvider =
        Provider.of<FollowedUsersProvider>(context, listen: false);

    followedUsersProvider.fetchFollowedUsers();

    _allUserListFuture = UserService().fetchAllUsers();
    _allUserListFuture.then((users) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _allUsers = users;
          _updateFilteredUsers();
        });
      });
    });

    _chattedUserListFuture = UserService().fetchChattedUsers();
    _chattedUserListFuture.then((users) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _chattedUsers = users;
          _updateFilteredUsers();
        });
      });
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isSearching = true;
        _filterSearchResults();
      });
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _filterSearchResults() {
    List<User> searchResults = _allUsers.where((user) {
      String searchTerm = _searchController.text.toLowerCase();
      String userName = user.name.toLowerCase();
      return userName.contains(searchTerm);
    }).toList();

    // Remove duplicates
    searchResults = searchResults.toSet().toList();

    setState(() {
      _searchResults = searchResults;
    });
  }

  void _updateFilteredUsers() {
    final followedUsersProvider =
        Provider.of<FollowedUsersProvider>(context, listen: false);

    // Create a map to remove duplicates using user.id as the key
    Map<String, User> userMap = {};

    // Add followed users to the map
    for (var user in followedUsersProvider.followedUsers) {
      userMap[user.id] = user;
    }

    // Add chatted users to the map
    for (var user in _chattedUsers) {
      userMap[user.id] = user;
    }

    // Convert the map values to a list to get unique users
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _filteredUsers = userMap.values.toList();
      });
    });
  }

  void _addUserToFollowed(User user) async {
    try {
      print('Adding user ${user.name} to chatted users...');
      await UserService().addChattedUser(user.id);
      print('User ${user.name} added to chatted users in the database.');

      final followedUsersProvider =
          Provider.of<FollowedUsersProvider>(context, listen: false);
      followedUsersProvider.addFollowedUser(user);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _chattedUsers.remove(user);
          _updateFilteredUsers();
        });
      });
    } catch (error) {
      print('Error adding user to followed list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Palette.REDcolor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a user...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<FollowedUsersProvider>(
              builder: (context, followedUsersProvider, _) {
                _updateFilteredUsers();
                List<User> usersToDisplay =
                    _isSearching ? _searchResults : _filteredUsers;
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: usersToDisplay.length,
                  itemBuilder: (context, index) {
                    final user = usersToDisplay[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: UserCardChat(
                        user: user,
                        onStartChat: _addUserToFollowed,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardChat extends StatelessWidget {
  final User user;
  final Function(User) onStartChat;

  const UserCardChat({Key? key, required this.user, required this.onStartChat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onStartChat(user); // Add user to followed list when starting chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatscreen(user: user, defaultMessage: ""),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: user.imageUrl != null
                  ? NetworkImage(user.imageUrl!)
                  : AssetImage('assets/default_avatar.png'), // Default avatar
              radius: 30,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
