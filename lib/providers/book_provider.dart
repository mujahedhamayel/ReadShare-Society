import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _physicalBooks = [];
  List<Book> _pdfBooks = [];
  List<Book> _books = [];
  List<Book> _likedBooks = [];
  List<Book> _userBooks = [];
  Map<String, Book> _bookCache = {};

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

  bool isBookLiked(Book book, String userId) {
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

  Future<Book> fetchBookById(String bookId) async {
    if (_bookCache.containsKey(bookId)) {
      return _bookCache[bookId]!;
    } else {
      Book book = await BookService().getBookById(bookId);
      _bookCache[bookId] = book;
      notifyListeners();
      return book;
    }
  }

  Future<void> rateBook(String bookId, double score) async {
    await BookService().rateBook(bookId, score);
    Book updatedBook = await fetchBookById(bookId);
    _bookCache[bookId] = updatedBook;
    notifyListeners();
  }

  void addBook(Book book) {
    _userBooks.add(book);
    notifyListeners();
  }
}
