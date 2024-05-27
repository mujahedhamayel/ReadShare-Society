import 'dart:convert';
import 'package:facebook/constants.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  final String apiUrl = 'http://$ip:$port/api/books';

  Future<List<Book>> fetchBooks() async {
    String token = AuthToken().getToken;
    final response =
        await http.get(Uri.parse(apiUrl), headers: ApiUtil.headers(token));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
