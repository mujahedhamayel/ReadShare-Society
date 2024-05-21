import 'package:facebook/config/palette.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class DetailPage extends StatelessWidget {
  final Book book;
  const DetailPage({required this.book, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BookDetail(book: book),
              BookCover(book: book),
            ],
          ),
        ));
  }
}

class BookDetail extends StatelessWidget {
  final Book book;
  const BookDetail({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.type.toUpperCase(),
              style: const TextStyle(
                  color: Palette.REDcolor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              book.name,
              style: const TextStyle(fontSize: 24, height: 1.2),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Published from ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: book.publisher,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(book.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class BookCover extends StatelessWidget {
  final Book book;
  const BookCover({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(left: 20),
        height: 250,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 50),
              width: MediaQuery.of(context).size.width - 20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                color: Color.fromARGB(200, 238, 238, 238),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                child: Image.asset(
                  book.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_horiz_outlined),
      )
    ],
  );
}
