import 'dart:convert';
import 'package:facebook/constants.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class UserService {
  final String apiUrl = 'http://$ip:$port/api/users';

  Future<List<User>> fetchFollowedUsers() async {
    String token = AuthToken().getToken;
    final followedUsersUrl = '$apiUrl/followed-users';
    final response = await http.get(Uri.parse(followedUsersUrl),
        headers: ApiUtil.headers(token));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load followed Users');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    String token = AuthToken().getToken;
    final followedUsersUrl = '$apiUrl/users';
    final response = await http.get(Uri.parse(followedUsersUrl),
        headers: ApiUtil.headers(token));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load followed Users');
    }
  }

  Future<User> fetchUserDetails(String name) async {
    final String apiUrl =
        'http://$ip:$port/api/users/name/$name'; // Update this to your actual API endpoint
    String token = AuthToken().getToken;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> addChattedUser(String userId) async {
    String token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('$apiUrl/$userId/chat'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add chatted user');
    }
  }

  Future<List<User>> fetchChattedUsers() async {
    String token = AuthToken().getToken;
    final response = await http.get(
      Uri.parse('$apiUrl/chatted-users'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load chatted users');
    }
  }

  Future<User> fetchUserById(String userId) async {
    final String apiUrl =
        'http://$ip:$port/api/users/$userId'; // Update this to your actual API endpoint
    String token = AuthToken().getToken;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
