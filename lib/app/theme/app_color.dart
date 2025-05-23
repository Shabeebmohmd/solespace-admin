import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.teal;
  static const background = Color(0xff1a2530);
  static const secondBackground = Color(0xff161f28);
  static const smallTexts = Color(0xff707b81);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const gradientPrimary = LinearGradient(
    colors: [
      Color.fromARGB(255, 223, 246, 255),
      Color.fromARGB(255, 193, 238, 218),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
