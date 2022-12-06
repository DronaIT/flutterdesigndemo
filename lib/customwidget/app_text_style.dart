import 'package:flutter/material.dart';

double screenWidth = 0;

class AppTextStyle {
// TextStyle

  static TextStyle bold({required color, required int fontSize}) {
    return TextStyle(
        color: color,
        fontFamily: "DMSans-Bold",
        fontSize: (screenWidth / 375.0) * fontSize,
        fontWeight: FontWeight.bold);
  }

  static TextStyle normal(Color color, double size) {
    return TextStyle(
        color: color,
        fontFamily: "DMSans-Regular",
        fontSize: (screenWidth / 375.0) * size,
        fontWeight: FontWeight.normal);
  }

  static TextStyle medium(Color color, double size) {
    return TextStyle(
        color: color,
        fontFamily: "DMSans-Medium",
        fontSize: (screenWidth / 375.0) * size,
        fontWeight: FontWeight.w600);
  }

  static TextStyle light(Color color, double size) {
    return TextStyle(
        color: color,
        fontFamily: "DMSans-Regular",
        fontSize: (screenWidth / 375.0) * size,
        fontWeight: FontWeight.w100);
  }

  static TextStyle italic(Color color, double size) {
    return TextStyle(
      color: color,
      fontFamily: "DMSans-Italic",
      fontSize: (screenWidth / 375.0) * size,
      fontStyle: FontStyle.italic,
    );
  }


}

