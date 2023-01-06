import 'package:flutter/material.dart';
import 'package:navbar/otherpages/globals.dart';

class MyTheme {
  static final light = ThemeData(
      // Colors

      primaryColor: AppColors.secondary,
      splashColor: AppColors.primary,
      cardColor: Colors.white,

      // Fonts
      fontFamily: 'Gotham Book');

  static final lightV2 = light.copyWith(
      colorScheme: light.colorScheme.copyWith(secondary: AppColors.primary));
}
