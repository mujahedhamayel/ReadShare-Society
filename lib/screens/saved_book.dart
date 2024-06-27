import 'dart:convert';

import 'package:facebook/models/models.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/widgets/PDF_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedBooksPage extends StatefulWidget {
  @override
  _SavedBooksPageState createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage> {
  List<Book> savedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userBooksKey = 'user_${user!.id}_savedBooks';
    List<String>? booksJson = prefs.getStringList(userBooksKey);

    if (booksJson != null) {
      setState(() {
        savedBooks = booksJson
            .map((bookJson) {
              try {
                Map<String, dynamic> bookMap = jsonDecode(bookJson);
                return Book.fromJson(bookMap);
              } catch (e) {
                // Handle the error gracefully
                print('Error decoding bookJson: $bookJson');
                return null;
              }
            })
            .where((book) => book != null)
            .cast<Book>()
            .toList();
      });
    }
  }

  Future<void> _deleteBook(Book book) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? booksJson = prefs.getStringList('savedBooks');

    if (booksJson != null) {
      booksJson.removeWhere((bookJson) {
        Map<String, dynamic> bookMap = jsonDecode(bookJson);
        return bookMap['_id'] == book.id;
      });

      await prefs.setStringList('savedBooks', booksJson);
      _loadSavedBooks(); // Reload the books list
    }
  }

  Future<void> _clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      savedBooks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              await _clearAllPreferences();
            },
          ),
        ],
      ),
      body: savedBooks.isNotEmpty
          ? ListView.builder(
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                Book book = savedBooks[index];
                return ListTile(
                  leading: Image.network(book.imgUrl, width: 50, height: 50),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewerPage(pdfBook: book),
                            ),
                          );
                        },
                        child: Text('Continue Reading'),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _deleteBook(book);
                          setState(() {}); // Refresh the UI
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('No saved books')),
    );
  }
}
