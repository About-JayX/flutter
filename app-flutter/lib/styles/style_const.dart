import 'package:flutter/material.dart';
import 'package:mobisen_app/util/screen_util.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF000000);
  static const Color errorColor = Color(0xFFB00020);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

// class AppWidgetStyles {
//   static const double bottomNavigationConHeight = 72.0;
// }

class AppSize {
  static const double screenPaddingHorizontal = 11.46;
  static const double bottomNavigationConHeight = 72.0;
  static double statusBarHeight = ScreenUtil.topPadding;
  static double bottomNavigationHeight =
      bottomNavigationConHeight + ScreenUtil.bottomPadding;
}

class AppPadding {
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: AppSize.screenPaddingHorizontal);
  static const EdgeInsets contentPadding = EdgeInsets.all(8.0);
}
