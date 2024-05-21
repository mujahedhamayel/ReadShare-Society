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
              BookReview(book: book)
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

class BookReview extends StatelessWidget {
  final Book book;
  const BookReview({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${book.score}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              _bulidStar(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${book.ratings} The Ratings of Book',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: book.review,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
                const TextSpan(
                  text: 'Read more',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulidStar() {
    final List<Color> color = [
      Colors.amber,
      Colors.amber,
      Colors.amber,
      Colors.amber,
      Colors.grey.withOpacity(0.3),
    ];
    return Row(
      children: color
          .map((e) => Icon(
                Icons.star,
                size: 25,
                color: e,
              ))
          .toList(),
    );
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
              color: Color.fromARGB(191, 212, 211, 211),
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
          ),
          Positioned(
            left: 190,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(226, 124, 126, 0.978)),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          Positioned(
            left: 240,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 60, 27, 110),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  Text(
                    'Audio Book',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
