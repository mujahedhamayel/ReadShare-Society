import 'dart:convert';

import 'package:facebook/config/palette.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/providers/book_provider.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/screens/chatscreen.dart';
import 'package:facebook/screens/map_screen.dart';
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
                onTap: () async {
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
                          color: Colors.blue,
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

  Future<void> checkBookStatusAndProceed() async {
    try {
      final response = await http.get(
        Uri.parse('http://$ip:$port/api/books/${widget.book.id}/status'),
        headers: ApiUtil.headers(AuthToken().getToken),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        final message = responseJson['message'];

        if (status == 'booked') {
          // Show message that the book is booked up
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Book Status'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Proceed to show the request dialog
          UserService userService = UserService();
          User owner = await userService.fetchUserDetails(widget.book.owner);
          _showRequestDialog(context, widget.book, owner);
        }
      } else {
        throw Exception('Failed to load book status');
      }
    } catch (e) {
      print('Failed to check book status: $e');
      // Optionally, show an error dialog or message
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final currentUser = Provider.of<UserProvider>(context).user;

    bool isOwner = currentUser?.name == widget.book.owner;
    print(isOwner);

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
          if (widget.book.type == 'pdf')
            Positioned(
              left: 350,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(pdfBook: widget.book),
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
              ),
            ),
          if (widget.book.type == 'physical' && !isOwner)
            Positioned(
              left: 350,
              bottom: 20,
              child: GestureDetector(
                onTap: () async {
                  await checkBookStatusAndProceed();
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
        ],
      ),
    );
  }
}

void _showRequestDialog(BuildContext context, Book book, User user) {
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
            title: const Text('Request the book'),
            content: Container(
              width: 450, // Set the width
              height: 450, // Set the height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('The price of Book: ${book.price} ₪',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                      height:
                          20), // Added spacing between price and location text
                  const Text('The location of the book:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(
                      height:
                          10), // Added spacing between the location text and the map
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: MapScreen(
                      initialLocation: user.location!,
                    ),
                  ),
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
                      _showCompleteRequestDialog(context, book, user);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Next',
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

void _showCompleteRequestDialog(BuildContext context, Book book, User user) {
  final TextEditingController addressController = TextEditingController();
  LatLng? _selectedLocation;

  // Ensure the phone number starts with a + sign and a country code
  String formattedPhoneNumber = user.mobileNumber;
  if (!formattedPhoneNumber.startsWith('+')) {
    formattedPhoneNumber =
        '+972' + formattedPhoneNumber; // Assuming +972 as the country code
  }

  print('Formatted Phone Number: $formattedPhoneNumber'); // Debug print

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
                    const Text('Call the owner for more details:'),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        final Uri url =
                            Uri(scheme: 'tel', path: formattedPhoneNumber);
                        print('Attempting to launch: $url'); // Debug print
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print('Could not launch $url'); // Debug print
                          // Attempt to use an alternative approach
                          try {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } catch (e) {
                            print('Failed to launch externally: $e');
                          }
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        'Call Owner',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TextField(
                    //   controller: addressController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Address Manual (Optional)',
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   height: 200,
                    //   child: GoogleMap(
                    //     onMapCreated: (GoogleMapController controller) async {
                    //       LatLng currentLocation = await _getCurrentLocation();
                    //       controller.animateCamera(
                    //           CameraUpdate.newLatLng(currentLocation));
                    //     },
                    //     initialCameraPosition: const CameraPosition(
                    //       target:
                    //           LatLng(0, 0), // Default location (initial load)
                    //       zoom: 12,
                    //     ),
                    //     onTap: (location) {
                    //       setState(() {
                    //         _selectedLocation = location;
                    //         addressController.text =
                    //             'Lat: ${location.latitude}, Lon: ${location.longitude}';
                    //       });
                    //     },
                    //     markers: _selectedLocation != null
                    //         ? {
                    //             Marker(
                    //               markerId: MarkerId('selected-location'),
                    //               position: _selectedLocation!,
                    //             ),
                    //           }
                    //         : {},
                    //   ),
                    //),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        final message = await _requestBook(context, book, user);
                        Navigator.of(context).pop(); // Close the current dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatscreen(
                              user: user,
                              defaultMessage:
                                  'I want to request your book: ${book.title}',
                            ),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Request Status'),
                              content: Text(message),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text(
                        'Confirm and Chat with Owner',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        final message = await _requestBook(context, book, user);
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Request Sent'),
                              content: Text(message),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        'Confirm Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

Future<String> _requestBook(BuildContext context, Book book, User user) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ip:$port/api/books/${book.id}/request'),
      headers: ApiUtil.headers(AuthToken().getToken),
    );

    if (response.statusCode == 200) {
      // Request was successful
      final responseJson = jsonDecode(response.body);
      return responseJson['message'];
    } else {
      final responseJson = jsonDecode(response.body);
      return responseJson['message'];
    }
  } catch (e) {
    print('Failed to request book: $e');
    return 'Failed to request book';
  }
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

class BookPdfLink extends StatelessWidget {
  final Book book;
  const BookPdfLink({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(pdfBook: book),
            ),
          );
        },
        child: const Text('Read Book'),
      ),
    );
  }
}

class BookReview extends StatefulWidget {
  final Book book;
  const BookReview({Key? key, required this.book}) : super(key: key);

  @override
  _BookReviewState createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  late double userRating;
  late double averageRating;
  bool isLoading = true;

  TextEditingController _reviewController = TextEditingController();
  List<Review> _submittedReviews = [];

  @override
  void initState() {
    super.initState();
    averageRating = widget.book.rate.toDouble();
    _submittedReviews = widget.book.review;
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    try {
      final rating = await BookService().getUserRating(widget.book.id);
      setState(() {
        userRating = rating ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load user rating: $e');
      setState(() {
        userRating = 0.0;
        isLoading = false;
      });
    }
  }

  void _handleRatingUpdate(double newRating) async {
    setState(() {
      userRating = newRating;
    });
    try {
      await BookService().rateBook(widget.book.id, newRating);
      final updatedBook = await BookService().getBookById(widget.book.id);
      setState(() {
        averageRating = updatedBook.rate.toDouble();
        userRating = updatedBook.userRating ?? 0.0;
      });
    } catch (e) {
      print('Failed to update rating: $e');
    }
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.book.author,
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
                  'Your Rating: ${userRating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Average Rating: ${averageRating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                if (_submittedReviews.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reviews:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (Review review in _submittedReviews)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(review.text),
                        ),
                      const SizedBox(height: 20),
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
                        fillColor: Palette.REDcolor,
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
