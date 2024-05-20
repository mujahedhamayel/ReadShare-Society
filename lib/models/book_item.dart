import 'package:facebook/data/detail.dart';
import 'package:facebook/models/book.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final Book book;
  const BookItem({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailPage(
                book: book,
              ))),
      child: Container(
        height: book.height as double,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(book.imgUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
