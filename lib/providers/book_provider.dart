import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _physicalBooks = [];
  List<Book> _pdfBooks = [];

  List<Book> _books = [];

  List<Book> _likedBooks = [];
    List<Book> _userBooks = [];


  List<Book> get books => _books;

  List<Book> get likedBooks => _likedBooks;
  List<Book> get physicalBooks => _physicalBooks;
  List<Book> get pdfBooks => _pdfBooks;
    List<Book> get userBooks => _userBooks;


  void setBooks(List<Book> books) {
    _books = books;
    notifyListeners();
  }

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

  bool isBookLiked(Book book, userId) {
    return _likedBooks.any((likedBook) =>
        likedBook.id == book.id && likedBook.likes.contains(userId));
  }

  Future<void> fetchPhysicalBooks() async {
    _physicalBooks = await BookService().fetchPhysicalBooks();
    notifyListeners();
  }

  Future<void> fetchPDFBooks() async {
    _pdfBooks = await BookService().fetchPDFBooks();
    notifyListeners();
  }
   Future<void> fetchUserBooks() async {
    _userBooks = await BookService().fetchUserBooks();
    notifyListeners();
  }
}
