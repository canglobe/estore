import 'package:estore/constants/constants.dart';
import 'package:flutter/material.dart';

ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      //headline
      headlineLarge: TextStyle(
          color: textDarkColor, fontSize: 30, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: textDarkColor, fontSize: 27, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: textDarkColor, fontSize: 20, fontWeight: FontWeight.bold),
      //display
      displayLarge: TextStyle(color: textDarkColor, fontSize: 22),
      displayMedium: TextStyle(color: textDarkColor, fontSize: 20),
      displaySmall: TextStyle(color: textDarkColor, fontSize: 18),
      //label
      labelLarge: TextStyle(color: textDarkColor, fontSize: 16),
      labelMedium: TextStyle(color: textDarkColor, fontSize: 14),
      labelSmall: TextStyle(color: textDarkColor, fontSize: 12),
    ),
  );
}

ThemeData lightThemeData() {
  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    primaryColorLight: primaryColor,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      //headline
      headlineLarge: TextStyle(
          color: textLightColor, fontSize: 30, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      //display
      displayLarge: TextStyle(color: textLightColor, fontSize: 20),
      displayMedium: TextStyle(color: miniTextColor, fontSize: 18),
      displaySmall: TextStyle(color: textLightColor, fontSize: 16),
      //label
      labelLarge:
          TextStyle(color: textDarkColor, fontSize: 16), // label for buttons

      labelMedium: TextStyle(color: miniTextColor, fontSize: 14),
      labelSmall: TextStyle(color: miniTextColor, fontSize: 12),
    ),
  );
}
