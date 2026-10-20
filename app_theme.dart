import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0F172A); // Slate Dark
  static const Color cardColor = Color(0xFF1E293B);  // Lighter Slate Card
  static const Color primary = Color(0xFF8B5CF6);    // Electric Purple
  static const Color accent = Color(0xFF06B6D4);     // Neon Cyan
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textGray = Color(0xFF94A3B8);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: cardColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textWhite),
      bodyLarge: TextStyle(fontSize: 16, color: textWhite),
      bodyMedium: TextStyle(fontSize: 14, color: textGray),
    ),
    useMaterial3: true,
  );
}
