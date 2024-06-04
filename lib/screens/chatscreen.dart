import 'package:flutter/material.dart';
import 'package:facebook/config/palette.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  _favoritepageState createState() => _favoritepageState();
}

class _favoritepageState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Palette.REDcolor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
      ),
    );
  }
}
