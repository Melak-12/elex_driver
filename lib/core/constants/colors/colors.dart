import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF67308F);
  static const Color primary2 = Color.fromARGB(242, 168, 24, 74);
  static const Color onPrimary = Color(0xFFf2f2f2);
  static const Color secondary = Color(0xFFf2c94c);
  static const Color onSecondary = Color(0xFF000000);
  static const Color black = Colors.black;
  static const Color third = Colors.blueGrey;

      static Color onSurfaceMid(BuildContext context) => Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
      static Color onSurfaceLight(BuildContext context) => Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
      static Color onSurfaceVeryLight(BuildContext context) => Theme.of(context).colorScheme.onSurface.withOpacity(0.08);
      static Color onSurfaceDark(BuildContext context) => Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
}
