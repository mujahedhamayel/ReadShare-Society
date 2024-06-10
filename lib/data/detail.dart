import 'dart:convert';

import 'package:facebook/config/palette.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/providers/book_provider.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/services/book_service.dart';
import 'package:facebook/services/user_service.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/widgets/PDF_viewer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

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
    UserService userService = UserService();
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
                onTap: () async {
                  // Fetch the owner's details from the backend or use what you have
                  User owner = await userService
                      .fetchUserDetails(book.owner); // Fetch owner details

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: owner),
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
  void initState() {
    super.initState();

    final providerUser = Provider.of<UserProvider>(context, listen: false).user;
    final userId = providerUser!.id; // Obtain the current user's ID
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    isBookmarked = bookProvider.isBookLiked(widget.book, userId);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
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
              onTap: () async {
                try {
                  await BookService().likeBook(widget.book.id);
                  setState(() {
                    isBookmarked = !isBookmarked;
                    if (isBookmarked) {
                      bookProvider.likeBook(widget.book);
                    } else {
                      bookProvider.unlikeBook(widget.book.id);
                    }
                  });
                } catch (e) {
                  print('Failed to like/unlike the book: $e');
                }
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
            child: widget.book.type == 'pdf'
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PdfViewerPage(pdfUrl: widget.book.pdfLink!),
                        ),
                      );
                    },
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
                            'Read Book',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                : Positioned(
                    left: 350,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () => _showRequestDialog(context),
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
                            SizedBox(width: 5),
                            Text(
                              'Request the book',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

void _showRequestDialog(BuildContext context) {
  LatLng? _selectedLocation;
  final TextEditingController addressController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Request the book'),
            content: Container(
              width: 450, // Set the width
              height: 450, // Set the height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('The prise of Book',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) async {
                        LatLng currentLocation = await _getCurrentLocation();
                        controller.animateCamera(
                            CameraUpdate.newLatLng(currentLocation));
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(0, 0), // Default location (initial load)
                        zoom: 12,
                      ),
                      onTap: (location) {
                        setState(() {
                          _selectedLocation = location;
                          addressController.text =
                              'Lat: ${location.latitude}, Lon: ${location.longitude}';
                        });
                      },
                      markers: _selectedLocation != null
                          ? {
                              Marker(
                                markerId: MarkerId('selected-location'),
                                position: _selectedLocation!,
                              ),
                            }
                          : {},
                    ),
                  ),
                  const Text('Choose an option below:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to chat page
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Go to chat with Owner',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showCompleteRequestDialog(context);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Confirm Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _showCompleteRequestDialog(BuildContext context) {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  LatLng? _selectedLocation;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Complete the Request'),
            content: Container(
              width: 450, // Set the width
              height: 500, // Set the height
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter additional details:'),
                    const SizedBox(height: 20),
                    TextField(
                      controller: detailsController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address Manual (Optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) async {
                          LatLng currentLocation = await _getCurrentLocation();
                          controller.animateCamera(
                              CameraUpdate.newLatLng(currentLocation));
                        },
                        initialCameraPosition: const CameraPosition(
                          target:
                              LatLng(0, 0), // Default location (initial load)
                          zoom: 12,
                        ),
                        onTap: (location) {
                          setState(() {
                            _selectedLocation = location;
                            addressController.text =
                                'Lat: ${location.latitude}, Lon: ${location.longitude}';
                          });
                        },
                        markers: _selectedLocation != null
                            ? {
                                Marker(
                                  markerId: MarkerId('selected-location'),
                                  position: _selectedLocation!,
                                ),
                              }
                            : {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.REDcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('Request details: ${detailsController.text}');
                        print('Request address: ${addressController.text}');
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<LatLng> _getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
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
  List<Review> _submittedReviews = [];

  @override
  void initState() {
    super.initState();
    userRating = widget.book.rate.toDouble();
    _submittedReviews = widget.book.review;
  }

  void _handleRatingUpdate(double newRating) {
    setState(() {
      userRating = newRating;
    });
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user!;

      try {
        final newReview = Review(
          username: currentUser.name,
          text: _reviewController.text,
          date: DateTime.now(),
        );

        await BookService().addReview(widget.book.id, newReview);

        setState(() {
          _submittedReviews.add(newReview);
          _reviewController.clear();
        });
      } catch (e) {
        print('Failed to add review: $e');
      }
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
          if (_submittedReviews.isNotEmpty)
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
                for (Review review in _submittedReviews)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(review.text),
                  ),
                SizedBox(height: 20),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Add a Review...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                RawMaterialButton(
                  padding: const EdgeInsets.all(12.0),
                  fillColor: Palette.REDcolor, // Changed color to red
                  elevation: 0.0,
                  shape: const CircleBorder(),
                  onPressed: _submitReview,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
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
