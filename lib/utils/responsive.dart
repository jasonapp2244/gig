import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double wp(BuildContext context, double percent) =>
      screenWidth(context) * percent / 100;

  static double hp(BuildContext context, double percent) =>
      screenHeight(context) * percent / 100;

  static double sp(BuildContext context, double size) {
    double baseWidth = 375; // iPhone X reference width
    return (size * screenWidth(context)) / baseWidth;
  }
}
