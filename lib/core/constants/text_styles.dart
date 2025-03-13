import 'package:elex_driver/core/constants/assets.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFamily: AppAssets.primaryFont,
  );
  static const TextStyle headline2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFamily: AppAssets.secondaryFont,
  );
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.tertiaryColor,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: AppAssets.complimentaryFont,
  );
  static const TextStyle bodyText2 = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssets.complimentaryFont,
  );
}
