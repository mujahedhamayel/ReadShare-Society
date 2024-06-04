import 'dart:convert';
import 'package:facebook/constants.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:facebook/utils/auth_token.dart';
import '../models/book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _bookResults = [];
  List<dynamic> _userResults = [];
  List<dynamic> _postResults = [];
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    String token = AuthToken().getToken;

    // Search books
    final bookResponse = await http.get(
      Uri.parse('http://$ip:$port/api/search/books?query=$query'),
      headers: ApiUtil.headers(token),
    );

    // Search users
    final userResponse = await http.get(
      Uri.parse('http://$ip:$port/api/search/users?query=$query'),
      headers: ApiUtil.headers(token),
    );

    // Search posts
    final postResponse = await http.get(
      Uri.parse('http://$ip:$port/api/search/posts?query=$query'),
      headers: ApiUtil.headers(token),
    );

    if (bookResponse.statusCode == 200 &&
        userResponse.statusCode == 200 &&
        postResponse.statusCode == 200) {
      setState(() {
        _bookResults = jsonDecode(bookResponse.body);
        _userResults = jsonDecode(userResponse.body);
        _postResults = jsonDecode(postResponse.body);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search ',
                    border: InputBorder.none,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            _performSearch(_searchController.text);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _bookResults.clear();
                              _userResults.clear();
                              _postResults.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      _performSearch(query);
                    } else {
                      setState(() {
                        _bookResults.clear();
                        _userResults.clear();
                        _postResults.clear();
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bookResults.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Books',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _bookResults.length,
                itemBuilder: (context, index) {
                  final book = Book.fromJson(_bookResults[index]); // Assuming Book has a fromJson method
                  return ListTile(
                    title: Text(book.title ?? 'No Title'),
                    subtitle: Text(book.author ?? 'No Author'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/bookDetail',
                        arguments: book,
                      );
                    },
                  );
                },
              ),
            ],
            if (_userResults.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Users',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _userResults.length,
                itemBuilder: (context, index) {
                  final user = User.fromJson(_userResults[index]); // Assuming User has a fromJson method
                  return ListTile(
                    title: Text(user.name ?? 'No Name'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/userProfile',
                        arguments: user,
                      );
                    },
                  );
                },
              ),
            ],
            if (_postResults.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _postResults.length,
                itemBuilder: (context, index) {
                  final post = _postResults[index];
                  return ListTile(
                    title: Text(post['description'] ?? 'No Description'),
                    subtitle: Text(post['id']['name'] ?? 'No Owner Name'),
                    
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
