import 'package:flutter/material.dart';
import 'globals.dart';

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

// class MyTheme {
//   static final light = ThemeData(
//     primaryColor: AppColors.primary,
//     accentColor: AppColors.secondary,
//     backgroundColor: AppColors.background,
//     scaffoldBackgroundColor: AppColors.background,
//     cardColor: Colors.white,
//     dividerColor: Colors.grey[400],
//     appBarTheme: AppBarTheme(
//       color: Colors.white,
//       elevation: 0,
//       iconTheme: IconThemeData(
//         color: AppColors.secondary,
//       ),
//       textTheme: TextTheme(
//         headline6: TextStyle(
//           color: AppColors.secondary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//     textTheme: TextTheme(
//       headline1: TextStyle(
//         color: Colors.black,
//         fontSize: 32,
//         fontWeight: FontWeight.bold,
//       ),
//       headline2: TextStyle(
//         color: AppColors.secondary,
//         fontSize: 24,
//         fontWeight: FontWeight.w600,
//       ),
//       bodyText1: TextStyle(
//         color: Colors.grey[800],
//         fontSize: 16,
//         fontWeight: FontWeight.normal,
//       ),
//       bodyText2: TextStyle(
//         color: Colors.grey[600],
//         fontSize: 14,
//         fontWeight: FontWeight.normal,
//       ),
//     ),
//   );

//   static final dark = ThemeData(
//     primaryColor: AppColors.primary,
//     accentColor: AppColors.secondary,
//     backgroundColor: Colors.grey[900],
//     scaffoldBackgroundColor: Colors.grey[900],
//     cardColor: Colors.grey[800],
//     dividerColor: Colors.grey[400],
//     appBarTheme: AppBarTheme(
//       color: Colors.grey[900],
//       elevation: 0,
//       iconTheme: IconThemeData(
//         color: AppColors.secondary,
//       ),
//       textTheme: TextTheme(
//         headline6: TextStyle(
//           color: AppColors.secondary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//     textTheme: TextTheme(
//       headline1: TextStyle(
//         color: Colors.white,
//         fontSize: 32,
//         fontWeight: FontWeight.bold,
//       ),
//       headline2: TextStyle(
//         color: AppColors.secondary,
//         fontSize: 24,
//         fontWeight: FontWeight.w600,
//       ),
//       bodyText1: TextStyle(
//         color: Colors.grey[300],
//         fontSize: 16,
//         fontWeight: FontWeight.normal,
//       ),
//       bodyText2: TextStyle(
//         color: Colors.grey[400],
//         fontSize: 14,
//         fontWeight: FontWeight.normal,
//       ),
//     ),
//   );
//   static final lightV2 = light.copyWith(
//       colorScheme: light.colorScheme.copyWith(secondary: AppColors.primary));
// }
