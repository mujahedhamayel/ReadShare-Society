import 'dart:convert';
import 'package:facebook/constants.dart';
import 'package:facebook/models/request_model.dart';
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
    final response = await http.get(Uri.parse(likedBooksUrl),
        headers: ApiUtil.headers(token));

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

  // New method to fetch books created by the logged-in user
  Future<List<Book>> fetchUserBooks() async {
    String token = AuthToken().getToken;
    final userBooksUrl = '$apiUrl/user/books';
    final response = await http.get(Uri.parse(userBooksUrl),
        headers: ApiUtil.headers(token));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load user books');
    }
  }

  Future<Book> getBookById(String bookId) async {
    String token = AuthToken().getToken;
    final url = '$apiUrl/$bookId';
    final response = await http.get(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load book');
    }

    final bookJson = jsonDecode(response.body);
    return Book.fromJson(bookJson);
  }

  // New method to rate a book
  Future<void> rateBook(String bookId, double score) async {
    String token = AuthToken().getToken;
    final url = '$apiUrl/$bookId/rate';

    final response = await http.post(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
      body: jsonEncode({'score': score}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to rate the book');
    }
  }

  Future<double?> getUserRating(String bookId) async {
    String token = AuthToken().getToken;
    final url = '$apiUrl/$bookId/user-rating';
    final response = await http.get(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user rating');
    }

    final responseJson = jsonDecode(response.body);
    return responseJson['userRating']?.toDouble();
  }

  Future<void> requestBook(String bookId) async {
    String token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('$apiUrl/$bookId/request'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      final responseJson = jsonDecode(response.body);
      throw Exception(responseJson['message'] ?? 'Failed to request the book');
    }
  }

  Future<List<Request>> fetchBookRequests(String bookId) async {
    String token = AuthToken().getToken;
    final response = await http.get(
      Uri.parse('$apiUrl/$bookId/requests'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((request) => Request.fromJson(request)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> acceptRequest(String bookId, String requestId) async {
    String token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('$apiUrl/$bookId/requests/$requestId/accept'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept request');
    }
  }

  Future<List<Book>> fetchUserBookRequests() async {
    String token = AuthToken().getToken;
    final url = '$apiUrl/user/book-requests';
    final response = await http.get(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);

      List<Book> books = json.map((book) => Book.fromJson(book)).toList();
      books.sort((a, b) {
        // You can adjust this sorting logic based on your actual data structure
        bool aAccepted =
            a.requests.any((request) => request.status == "requested");
        bool bAccepted =
            b.requests.any((request) => request.status == "requested");
        if (aAccepted && !bAccepted) return -1;
        if (!aAccepted && bAccepted) return 1;
        return 0;
      });
      return books;
    } else {
      throw Exception('Failed to load user book requests');
    }
  }

  Future<void> denyRequest(String bookId, String requestId) async {
    String token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('$apiUrl/$bookId/requests/$requestId/deny'),
      headers: ApiUtil.headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to deny request');
    }
  }
}
