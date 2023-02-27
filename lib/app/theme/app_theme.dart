import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF212630);
  static const Color background = Color(0xFF212630);
  static const Color loadingIndicatorColor = primary;
  static const Color gray = Color(0xff989EA7);
  static const Color greyLight = Color(0xFFF5F6F7);
  static const Color green = Color(0xFF2DBD85);
  static const Color red = Color(0xFFE44358);
  static const Color border = Color(0xFF989EA7);
  static const Color cardBorder = Color(0xFFE4E8ED);
  static const Color hint = Color(0xFF989EA7);
  static const Color text = Color(0xFFFFFFFF);
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
    height: AppTextStyle.textHeight,
  );
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: AppTextStyle.textHeight,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 15,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: AppTextStyle.textHeight,
  );
  static const TextStyle body3 = TextStyle(
    fontSize: 14,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    height: AppTextStyle.textHeight,
  );
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    height: AppTextStyle.textHeight,
  );
  static const TextStyle title1 = TextStyle(
    fontSize: 18,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    height: AppTextStyle.textHeight,
  );
  static const TextStyle title2 = TextStyle(
    fontSize: 16,
    fontFamily: "Barlow",
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    height: AppTextStyle.textHeight,
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
      textTheme: _buildTextTheme(),
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

  static TextTheme _buildTextTheme() {
    var textColor = Colors.white;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 45,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 33,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: textColor,
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
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.hint,
      ),
      contentPadding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
    );
  }
}
