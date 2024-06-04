import 'package:facebook/config/palette.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/services/book_service.dart';
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
            book.title,
            style: const TextStyle(fontSize: 24, height: 1.2),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                ////////// هاد الفنكشن الي بستدعي صفحة الناشر ////////////////// هون رح تعدل عليه لانه بستدعي غلط
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          user: User(
                              id: book.owner,
                              name: book.owner,
                              email: '',
                              books: [],
                              likedBooks: [],
                              requests: [],
                              followedUsers: [])), // Assuming you have the user's ID and name
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Published by ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: book.owner,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue, // Make it look like a link
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd().format(book.updateDate),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BookCover extends StatefulWidget {
  final Book book;
  const BookCover({super.key, required this.book});

  @override
  _BookCoverState createState() => _BookCoverState();
}

class _BookCoverState extends State<BookCover> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(left: 20),
      height: 250,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 30),
            width: MediaQuery.of(context).size.width - 20,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              color: Color.fromARGB(191, 212, 211, 211),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.book.imgUrl),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 300,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.REDcolor,
                ),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            left: 350,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 60, 27, 110),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 25,
                  ),
                  Text(
                    'Request the book',
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

class BookReview extends StatefulWidget {
  final Book book;
  const BookReview({Key? key, required this.book}) : super(key: key);

  @override
  _BookReviewState createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  late double userRating;
  TextEditingController _reviewController = TextEditingController();
  List<String> _submittedReviews = [];

  @override
  void initState() {
    super.initState();
    userRating = widget.book.rate.toDouble();
  }

  void _handleRatingUpdate(double newRating) {
    setState(() {
      userRating = newRating;
    });
  }

  void _submitReview() {
    if (_reviewController.text.isNotEmpty) {
      // Replace 'Current User' with the actual current user object
      const currentUser = User(
        name: 'Current User', // Replace with actual user name
        imageUrl: 'path_to_current_user_image',
        id: '',
        email: '',
        books: [],
        likedBooks: [],
        requests: [],
        followedUsers: [], // Replace with actual image URL
      );

      setState(() {
        _submittedReviews.add(Review(
          username: currentUser.name,
          text: _reviewController.text,
          date: DateTime.now(),
        ) as String);
        _reviewController.clear();
      });
    }
  }

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
                '${widget.book.author}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              _buildInteractiveStarRating(userRating),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.book.rate} The Ratings of Book',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          if (widget
              .book.review.isNotEmpty) // Check if review list is not empty
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews:',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                for (Review review
                    in widget.book.review) // Iterate over reviews
                  Text(review.text),
                SizedBox(height: 20),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a Review...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitReview,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStarRating(double score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            _handleRatingUpdate(index + 1.0);
          },
          child: Icon(
            Icons.star,
            size: 25,
            color: index < score ? Colors.amber : Colors.grey.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}
