import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _likedBooks = [];

  List<Book> get likedBooks => _likedBooks;

  Future<void> fetchLikedBooks() async {
    _likedBooks = await BookService().fetchLikedBooks();
    notifyListeners();
  }

  void likeBook(Book book) {
    _likedBooks.add(book);
    notifyListeners();
  }

  void unlikeBook(String bookId) {
    _likedBooks.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }
}
