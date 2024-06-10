import 'package:facebook/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:facebook/config/palette.dart';
import 'package:provider/provider.dart';
import '../data/detail.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).fetchLikedBooks();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ReadShare',
          style: TextStyle(
            color: Palette.REDcolor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: bookProvider.likedBooks.isEmpty
              ? const Text('No books available')
              : ListView.builder(
                  itemCount: bookProvider.likedBooks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final book = bookProvider.likedBooks[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(book: book),
                          ),
                        );
                      },
                      child: Container(
                        height: 136,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${book.author} · ${book.updateDate.toLocal()}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.bookmark, size: 16),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(book.imgUrl),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
