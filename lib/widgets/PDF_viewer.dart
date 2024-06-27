import 'dart:convert';

import 'package:facebook/models/models.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PdfViewerPage extends StatefulWidget {
  final Book pdfBook;

  PdfViewerPage({required this.pdfBook});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String localPath = "";
  int? _savedPage;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;
  int? _totalPages;

  @override
  void initState() {
    super.initState();
    _downloadFile();
    _loadSavedPage();
  }

  Future<void> _downloadFile() async {
    final url = widget.pdfBook.pdfLink;
    final filename = url?.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    if (await file.exists()) {
      setState(() {
        localPath = file.path;
      });
    } else {
      final response = await http.get(Uri.parse(url!));
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        localPath = file.path;
      });
    }
  }

  Future<void> _loadSavedPage() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = 'user_${user!.id}_book_${widget.pdfBook.pdfLink}';
    setState(() {
      _savedPage = prefs.getInt(userKey);
    });
  }

  Future<void> _savePage(int page) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = 'user_${user!.id}_book_${widget.pdfBook.pdfLink}';
    await prefs.setInt(userKey, page);

    // Save the book information for the specific user
    String userBooksKey = 'user_${user!.id}_savedBooks';
    List<String>? books = prefs.getStringList(userBooksKey) ?? [];
    Map<String, dynamic> bookMap = widget.pdfBook.toJson();
    bookMap['savedPage'] = page;
    String bookJson = jsonEncode(bookMap);

    bool bookExists = false;

    for (int i = 0; i < books.length; i++) {
      Map<String, dynamic> existingBookMap = jsonDecode(books[i]);
      print('${existingBookMap['_id']} existingBookMap');
      if (existingBookMap['_id'] == widget.pdfBook.id) {
        books[i] = bookJson; // Update the existing book entry
        bookExists = true;
        print('Updated existing book: ${widget.pdfBook.id}');
        break;
      }
    }

    if (!bookExists) {
      books.add(bookJson);
      print('Added new book: ${widget.pdfBook.id}');
    }

    await prefs.setStringList(userBooksKey, books);
    print('Saved books for user ${user!.id}: $books');
  }

  Future<void> _removeBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? books = prefs.getStringList('savedBooks') ?? [];
    books.removeWhere((bookJson) {
      Map<String, dynamic> bookMap = jsonDecode(bookJson);
      return bookMap['pdfLink'] == widget.pdfBook.pdfLink;
    });
    await prefs.setStringList('savedBooks', books);
    await prefs.remove(widget.pdfBook.pdfLink!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: localPath.isNotEmpty
          ? PDFView(
              filePath: localPath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              defaultPage: _savedPage ?? 0, // Start from the saved page
              onRender: (_pages) {
                setState(() {
                  _totalPages = _pages;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _pdfViewController = pdfViewController;
                if (_savedPage != null) {
                  _pdfViewController!.setPage(_savedPage!);
                }
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                  _savePage(_currentPage); // Auto-save the current page

                  // Check if the user reached the last page
                  if (_totalPages != null && _currentPage == _totalPages! - 1) {
                    _removeBook();
                  }
                });
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
