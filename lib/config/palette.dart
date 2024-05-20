import 'package:flutter/material.dart';

class Palette {
  static const Color scaffold = Color(0xFFF0F2F5);

  static const Color REDcolor = Color.fromRGBO(226, 124, 126, 0.978);

  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [Color.fromRGBO(226, 124, 126, 0.978), Color(0xFFCE48B1)],
  );

  static const Color online = Color(0xFF4BCB1F);

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
}
