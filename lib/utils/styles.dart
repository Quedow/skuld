import 'package:flutter/material.dart';

abstract class Styles {
  static final double borderRadius = 10;

  static const Color orangeColor = Color(0xFFF28D2E);
  static const Color purpleColor = Color(0xFF9F2CF3);
  static const Color blueColor = Color(0xFF2C82F2);
  static const Color greenColor = Color(0xFF2CF285);
  static const Color redColor = Color(0xFFF53B33);
  static const Color greyColor = Colors.grey;

  static const Color lightPrimaryColor = Color(0xFFD5C8FF);
  static const Color primaryColor = Color(0xFF6133B4);
  static const Color darkPrimaryColor = Color(0xFF432874);
  
  static const Color secondaryColor = lightPrimaryColor; // Color(0xFFBFBBB8)

  static const Color hintColor = Color(0xFF444444);
  static const Color darkColor = Color(0xFF0D0D0D);
  static const Color unselectedItemColor = Color(0xFF757575);

  static const TextStyle labelLargeStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      // tertiary: darkPrimaryColor,
      // onTertiary: Colors.white,
      onSecondary: Colors.black,
      error: redColor,
      onError: Colors.white,
      surface: Colors.white, // Top bar, bottom bar, card and background
      onSurface: darkColor,
      surfaceContainerHighest: unselectedItemColor, // Disable switch background, textfield filled, time picker hour background
      outline: hintColor, // Textfield border, button border
      outlineVariant: hintColor, // Divider
      inverseSurface: darkPrimaryColor, // Snack bar
      onInverseSurface: Colors.white,
      surfaceTint: darkColor,
    ),
    timePickerTheme: const TimePickerThemeData(
      hourMinuteColor: lightPrimaryColor,
      hourMinuteTextColor: Colors.black,
    ),
    dialogBackgroundColor: Colors.white,
    hintColor: hintColor,
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    unselectedWidgetColor: unselectedItemColor,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: darkColor),
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: darkColor),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(primaryColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) => labelLargeStyle.copyWith(color: states.contains(WidgetState.focused) ? primaryColor : hintColor)),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(Colors.black),
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => states.contains(WidgetState.selected) ? lightPrimaryColor : Colors.white),
          side: const WidgetStatePropertyAll(BorderSide(color: hintColor)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
          textStyle: const WidgetStatePropertyAll(labelLargeStyle),
        ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)))),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
        side: const WidgetStatePropertyAll(BorderSide(color: primaryColor)),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), // Page titles
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // List titles
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal), // List item titles, important information
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal), // Paragraph text
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: hintColor), // Caption, secondary text
      labelLarge: labelLargeStyle, // Navigation links, menu items, text input
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // Button text, tabs
    ),
  );
}