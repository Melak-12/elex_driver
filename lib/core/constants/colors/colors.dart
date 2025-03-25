import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5B338A);
  static const Color primary2 = Color(0xFFBE2E71);
  static const Color onPrimary = Color(0xFFf2f2f2);
  static const Color secondary = Color(0xFFf2c94c);
  static const Color onSecondary = Color(0xFF000000);
  static const Color black = Colors.black;
  static const Color tertiaryColor = Colors.blueGrey;
  static const Color bodyColor = Color(0xFFEAE5F0);
  static const Color appBarColor = Color.fromARGB(255, 217, 233, 231);
  static Color onSurfaceMid(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
  static Color onSurfaceLight(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
  static Color onSurfaceVeryLight(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.08);
  static Color onSurfaceDark(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
}
