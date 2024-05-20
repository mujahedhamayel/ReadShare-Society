import 'package:facebook/config/palette.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class DetailPage extends StatelessWidget {
  final Book book;
  const DetailPage({required this.book, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BookDetail(
                book: book,
              ),
            ],
          ),
        ));
  }
}

class BookDetail extends StatelessWidget {
  final Book book;
  const BookDetail({required this.book, Key? key}) : super(key: key);

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
              style: TextStyle(fontSize: 24, height: 1.2),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Published from',
                        style: const TextStyle(color: Colors.grey),
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
