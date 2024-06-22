import 'dart:convert';

import 'package:facebook/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPage = prefs.getInt(widget.pdfBook.pdfLink!);
    });
  }

  Future<void> _savePage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.pdfBook.pdfLink!, page);

    // Save the book information
    List<String>? books = prefs.getStringList('savedBooks') ?? [];
    Map<String, dynamic> bookMap = widget.pdfBook.toJson();
    bookMap['savedPage'] = page;
    String bookJson = jsonEncode(bookMap);

    if (!books.contains(bookJson)) {
      books.add(bookJson);
    }
    await prefs.setStringList('savedBooks', books);
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
