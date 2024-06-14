import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class FollowedUsersProvider with ChangeNotifier {
  List<User> _followedUsers = [];
  List<User> get followedUsers => _followedUsers;

  Future<void> fetchFollowedUsers() async {
    try {
      _followedUsers = await UserService().fetchFollowedUsers();
      notifyListeners();
    } catch (error) {
      print('Error fetching followed users: $error');
    }
  }

  void addFollowedUser(User user) {
    if (!_followedUsers.contains(user)) {
      _followedUsers.add(user);
      notifyListeners();
    }
  }

  void removeFollowedUser(User user) {
    User? listUser =
        _followedUsers.firstWhere((element) => element.id == user.id);
    if (listUser.id == user.id) {
      _followedUsers.remove(listUser);
      notifyListeners();
    }
  }
}
