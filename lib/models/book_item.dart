import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/detail.dart';

class BookItem extends StatelessWidget {
  final Book book;
  const BookItem({required this.book, super.key});
  final double bookHeight = 235.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensure the Material widget is transparent
      child: InkWell(
        onTap: () {
          print("Book Item ###################  ");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailPage(
                    book: book,
                  )));
        },
        child: Container(
          height: bookHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(book.imgUrl), // Use NetworkImage for URL
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
