import 'package:facebook/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import '../config/palette.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/user_card.dart';
class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _followedUserListFuture;
  late Future<List<User>> _allUserListFuture;
  late Future<List<User>> _chattedUserListFuture;
  TextEditingController _searchController = TextEditingController();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  List<User> _followedUsers = [];
  List<User> _chattedUsers = [];

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
    _followedUserListFuture = UserService().fetchFollowedUsers();
    _followedUserListFuture.then((users) {
      setState(() {
        _followedUsers = users;
        _filteredUsers = users;
      });
    });

    _allUserListFuture = UserService().fetchAllUsers();
    _allUserListFuture.then((users) {
      setState(() {
        _allUsers = users;
      });
    });

    _chattedUserListFuture = UserService().fetchChattedUsers();
    _chattedUserListFuture.then((users) {
      setState(() {
        _chattedUsers = users;
        _filteredUsers.addAll(users);
      });
    });
  }

  void _onSearchChanged() {
    filterUsers();
  }

  void filterUsers() {
    List<User> _users = [];
    _users.addAll(_allUsers);
    if (_searchController.text.isNotEmpty) {
      _users.retainWhere((user) {
        String searchTerm = _searchController.text.toLowerCase();
        String userName = user.name.toLowerCase();
        return userName.contains(searchTerm);
      });
    } else {
      _users = _followedUsers;
       _users.addAll(_chattedUsers);
    }
    setState(() {
      _filteredUsers = _users;
    });
  }

  void _addUserToFollowed(User user) async {
    try {
      await UserService().addChattedUser(user.id);
      setState(() {
        if (!_followedUsers.contains(user)) {
          _followedUsers.add(user);
          _chattedUsers.remove(user);
          _filteredUsers.remove(user);
        }
      });
    } catch (error) {
      // Handle the error, e.g., show a notification
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
            child: FutureBuilder<List<User>>(
              future: _followedUserListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No followed users found.'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: UserCardChat(
                          user: user,
                          onStartChat: _addUserToFollowed,
                        ),
                      );
                    },
                  );
                }
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
            builder: (context) => Chatscreen(user: user),
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
              backgroundImage: NetworkImage(user.imageUrl!),
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
                // Text(
                //   user.email,
                //   style: const TextStyle(
                //     fontSize: 14,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}