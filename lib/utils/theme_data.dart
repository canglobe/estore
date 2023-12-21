import 'package:flutter/material.dart';
import 'package:estore/constants/constants.dart';

ThemeData darkThemeData() {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      // display for white color(All time) letters
      displayLarge: TextStyle(color: textDarkColor, fontSize: 24),
      displayMedium: TextStyle(color: textDarkColor, fontSize: 22),
      displaySmall: TextStyle(color: textDarkColor, fontSize: 20),

      // Headline for dark color(All time) letters
      headlineLarge: TextStyle(
          color: textDarkColor, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: textLightColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: textDarkColor, fontSize: 18, fontWeight: FontWeight.bold),

      // title for black color(All time) letters
      titleLarge: TextStyle(
          color: textDarkColor, fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: textDarkColor, fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: textDarkColor, fontSize: 16, fontWeight: FontWeight.bold),

      // body
      bodyLarge: TextStyle(color: textDarkColor, fontSize: 18),
      bodyMedium: TextStyle(color: textDarkColor, fontSize: 16),
      bodySmall: TextStyle(color: textDarkColor, fontSize: 14),

      // label
      labelLarge: TextStyle(color: miniTextColor, fontSize: 16),
      labelMedium: TextStyle(color: miniTextColor, fontSize: 14),
      labelSmall: TextStyle(color: textLightColor, fontSize: 12),
    ),
  );
}

ThemeData lightThemeData() {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffoldBgColor,
    textTheme: const TextTheme(
      // display for white color(All time) letters
      displayLarge: TextStyle(color: textDarkColor, fontSize: 24),
      displayMedium: TextStyle(color: textDarkColor, fontSize: 22),
      displaySmall: TextStyle(color: textDarkColor, fontSize: 20),

      // headline dark color all time
      headlineLarge: TextStyle(
          color: textDarkColor, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: textLightColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: textDarkColor, fontSize: 18, fontWeight: FontWeight.bold),

      // title
      titleLarge: TextStyle(color: textLightColor, fontSize: 20),
      titleMedium: TextStyle(
          color: textLightColor, fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: textLightColor, fontSize: 16),

      // body
      bodyLarge: TextStyle(color: textLightColor, fontSize: 18),
      bodyMedium: TextStyle(color: textLightColor, fontSize: 16),
      bodySmall: TextStyle(color: textLightColor, fontSize: 14),

      // label
      labelLarge: TextStyle(color: miniTextColor, fontSize: 16),
      labelMedium: TextStyle(color: miniTextColor, fontSize: 14),
      labelSmall: TextStyle(color: textLightColor, fontSize: 12),
    ),
  );
}
