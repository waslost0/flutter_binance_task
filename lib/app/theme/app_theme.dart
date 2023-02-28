import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF212630);
  static const Color background = Color(0xFF212630);
  static const Color loadingIndicatorColor = Colors.white;
  static const Color gray = Color(0xff989EA7);
  static const Color green = Color(0xFF2DBD85);
  static const Color red = Color(0xFFE44358);
  static const Color hint = Color(0xFF989EA7);
  static const Color text = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFF696E77);
  static const Color lightText = Color(0xFF7A7D83);
  static const Color searchbarBackground = Color(0xFF29303d);
  static const Color surfaceLightGray = Color(0xFFF7F8F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF2F3234);
}

class AppTextStyle {
  static const double textHeight = 0.9;
  static const TextStyle small = TextStyle(
    fontSize: 10,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: textHeight,
  );
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: textHeight,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 15,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: textHeight,
  );
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    height: textHeight,
  );
  static const TextStyle title1 = TextStyle(
    fontSize: 18,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    height: textHeight,
  );
}

class AppTheme {
  const AppTheme._();

  static const double cardBorderRadius = 4.0;
  static const Color defaultCardBackgroundColor = Colors.white;
  static const double defaultPadding = 12.0;
  static const double defaultSmallPadding = 6.0;

  static ThemeData buildThemeData() {
    return ThemeData(
      fontFamily: "Barlow",
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.black,
        ),
        titleTextStyle: AppTextStyle.title1.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.white,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.primary,
      ),
    );
  }

  static BoxDecoration buildCardDecoration() => BoxDecoration(
        color: AppColors.surfaceLightGray,
        borderRadius: BorderRadius.circular(cardBorderRadius),
      );

  static InputDecoration buildSearchInputDecoration() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        width: 0,
        color: Colors.transparent,
      ),
    );
    return InputDecoration(
      filled: true,
      fillColor: AppColors.searchbarBackground,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      prefixIconConstraints: const BoxConstraints(
        maxHeight: 45,
      ),
      prefixIcon: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.search,
          color: AppColors.lightGray,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
