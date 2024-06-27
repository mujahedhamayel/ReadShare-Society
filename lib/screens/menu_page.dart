import 'package:facebook/config/palette.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/screens/SignInPage.dart';
import 'package:facebook/screens/book_requests_page.dart';

import 'package:facebook/screens/discussion_room_page.dart';
import 'package:facebook/screens/my_books_page.dart';
import 'package:facebook/screens/saved_book.dart';
import 'package:facebook/screens/settings.dart';
import 'package:facebook/screens/user_requests_for_other.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Palette.REDcolor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile Page'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('My Books'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyBooksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon((Icons.shopping_bag)),
            title: const Text('My Book Requests'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserRequestsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon((Icons.receipt_long)),
            title: const Text('My Requests'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserRequestsForOtherBooksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon((Icons.book)),
            title: const Text('Continue Reading'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedBooksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon((Icons.video_call)),
            title: const Text('Discussions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiscussionRoomPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    
    AuthToken().clearToken();
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (Route<dynamic> route) => false,
    ).then((onValue) {
      Provider.of<UserProvider>(context, listen: false).logout();
    });
    //
  }
}
