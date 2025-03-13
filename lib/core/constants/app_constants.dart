import 'package:flutter/material.dart';
class AppConstant {

  /// [PADDINGS]
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const double screenPadding = 18;

  /// [MARGINS]
  static Color onSurfaceMid(BuildContext context) =>Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
  static Color onSurfaceLight(BuildContext context) => Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
  static Color onSurfaceVeryLight(BuildContext context) =>Theme.of(context).colorScheme.onSurface.withOpacity(0.08);
  static Color onSurfaceDark(BuildContext context) =>Theme.of(context).colorScheme.onSurface.withOpacity(0.8);


  
}
