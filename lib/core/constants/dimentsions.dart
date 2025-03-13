import 'package:flutter/material.dart';

class AppDimensions {
  static const double smallPadding = 8.0;
  static const double smallMargin = 8.0;
  static const double mediumMargin = 16.0;
  static const double largeMargin = 32.0;
  static const double largeBorderRadius = 50.0;
  static const double mediumBorderRadius = 20.0;
  static const double smallBorderRadius = 10.0;
  static const double mediumIconSize = 30.0;
}

///[ScreenHeight]

double screenHeight(context, {double h = 0.0}) => h > 0.0
    ? MediaQuery.of(context).size.height * h
    : MediaQuery.of(context).size.height;

///[ScreenWidth]

double screenWidth(context, {double w = 0.0}) => w > 0.0
    ? MediaQuery.of(context).size.width * w
    : MediaQuery.of(context).size.width;
