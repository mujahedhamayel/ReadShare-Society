import 'package:flutter/material.dart';

class Palette {
  static const Color scaffold = Color(0xFFF0F2F5);
  static const secondaryTextColor = Color(0xFFF5F5F7);
  static const Color REDcolor = Color.fromRGBO(226, 124, 126, 0.978);
  static const Color REDcolor2 = Color.fromRGBO(227, 75, 78, 0.973);
  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [Color.fromRGBO(226, 124, 126, 0.978), Color(0xFFCE48B1)],
  );

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
}
