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

  Future<List<Book>> fetchPDFBooks() async {
    List<Book> books = await fetchBooks();
    
    return books.where((book) => book.type == 'pdf').toList();
  }

  Future<List<Book>> fetchPhysicalBooks() async {
    List<Book> books = await fetchBooks();
   
    return books.where((book) => book.type == 'physical').toList();
  }

  // Fetch liked books of the logged-in user
  Future<List<Book>> fetchLikedBooks() async {
    String token = AuthToken().getToken;
    final likedBooksUrl = '$apiUrl/liked';
    final response =
        await http.get(Uri.parse(likedBooksUrl), headers: ApiUtil.headers(token));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load liked books');
    }
  }

  // Add the likeBook method
  Future<void> likeBook(String bookId) async {
    String token = AuthToken().getToken;
    final url = '$apiUrl/$bookId/like';

    final response = await http.post(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like the book');
    }
  }

   Future<void> addReview(String bookId, Review review) async {
    String token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('$apiUrl/$bookId/reviews'),
      headers: ApiUtil.headers(token),
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add review');
    }
  }

}


