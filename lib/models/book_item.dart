import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/detail.dart';

class BookItem extends StatelessWidget {
  final Book book;
  const BookItem({required this.book, super.key});
  final num bookHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Book Item ###################  ");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(
                  book: book,
                )));
      },
      child: Container(
        height: bookHeight.toDouble(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(book.imgUrl), // Use NetworkImage for URL
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
