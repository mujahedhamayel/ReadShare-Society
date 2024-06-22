import 'package:facebook/models/book.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/screens/chatscreen.dart';
import 'package:facebook/services/book_service.dart';
import 'package:facebook/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRequestsForOtherBooksPage extends StatefulWidget {
  @override
  _UserRequestsForOtherBooksPageState createState() => _UserRequestsForOtherBooksPageState();
}

class _UserRequestsForOtherBooksPageState extends State<UserRequestsForOtherBooksPage> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _bookService.fetchUserRequestsForOtherBooks();
  }

  void _refreshRequests() async {
    setState(() {
      _requestsFuture = _bookService.fetchUserRequestsForOtherBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests for Other Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              if (book.requests.isNotEmpty) {
                return BookRequestCard(
                  book: book,
                  onRequestAccepted: _refreshRequests,
                );
              }
              return SizedBox.shrink(); // This avoids an empty space in the list
            },
          );
        },
      ),
    );
  }
}

class BookRequestCard extends StatelessWidget {
  final Book book;
  final VoidCallback onRequestAccepted;

  const BookRequestCard({
    Key? key,
    required this.book,
    required this.onRequestAccepted,
  }) : super(key: key);

  Future<void> _cancelRequest(BuildContext context, String bookId, String requestId) async {
    try {
      await BookService().deleteRequest(bookId, requestId);
      onRequestAccepted(); // Refresh the list
    } catch (e) {
      print('Failed to cancel request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(book.imgUrl, width: 50, height: 50),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () async {
                        User owner = await userService.fetchUserDetails(book.owner); // Fetch owner details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(user: owner),
                          ),
                        );
                      },
                      child: Text(
                        book.owner,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            ...book.requests.map((request) {
              return FutureBuilder<User>(
                future: UserService().fetchUserById(request.user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                      subtitle: Text('Status: ${request.status}'),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error loading user'),
                      subtitle: Text('Status: ${request.status}'),
                    );
                  } else if (!snapshot.hasData) {
                    return ListTile(
                      title: Text('User not found'),
                      subtitle: Text('Status: ${request.status}'),
                    );
                  }

                  final user = snapshot.data!;
                  return ListTile(
                    title: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(user: user),
                          ),
                        );
                      },
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    subtitle: Text('Status: ${request.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat, color: Colors.blue),
                          onPressed: () {
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
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green),
                          onPressed: () async {
                            String formattedPhoneNumber = user.mobileNumber;
                            if (!formattedPhoneNumber.startsWith('+')) {
                              formattedPhoneNumber = '+972' + formattedPhoneNumber; // Assuming +972 as the country code
                            }

                            final Uri url = Uri(scheme: 'tel', path: formattedPhoneNumber);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              print('Could not launch $url'); // Debug print
                              // Attempt to use an alternative approach
                              try {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } catch (e) {
                                print('Failed to launch externally: $e');
                              }
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            _cancelRequest(context, book.id, request.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
