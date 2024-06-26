import 'package:facebook/models/book.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/screens/chatscreen.dart';
import 'package:facebook/screens/map_screen.dart';
import 'package:facebook/services/book_service.dart';
import 'package:facebook/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRequestsPage extends StatefulWidget {
  @override
  _UserRequestsPageState createState() => _UserRequestsPageState();
}

class _UserRequestsPageState extends State<UserRequestsPage> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _bookService.fetchUserBookRequests();
  }

  void _refreshRequests() async {
    setState(() {
      _requestsFuture = _bookService.fetchUserBookRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Requests'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('You Don\'t have any Book\'s yet'));
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
                Text(book.title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    subtitle: Text('Status: ${request.status}'),
                    trailing: request.status == 'requested'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await BookService()
                                      .acceptRequest(book.id, request.id);
                                  onRequestAccepted();
                                },
                                child: Text('Accept'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  await BookService()
                                      .denyRequest(book.id, request.id);
                                  onRequestAccepted();
                                },
                                child: Text('Deny'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[100],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.contact_page),
                                onPressed: () {
                                  _showContactDialog(context, user);
                                },
                              ),
                            ],
                          )
                        : Text(request.status == 'accepted'
                            ? 'Accepted'
                            : 'Denied'),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Contact User'),
          content: Container(
            width: 450, // Set the width
            height: 450, // Set the height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('The location of the user:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: flutterMap(context.widget, {}, user.location)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.call),
                  label: Text('Call'),
                  onPressed: () {
                    final Uri url = Uri(scheme: 'tel', path: user.mobileNumber);
                    launchUrl(url);
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.chat),
                  label: Text('Chat'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chatscreen(
                          user: user,
                          defaultMessage: '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
