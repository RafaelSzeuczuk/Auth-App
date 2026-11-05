import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const bg = Color.fromARGB(255, 69, 78, 95);
  static const card = Color(0xFF151E31);
  static const accent = Color(0xFF6C63FF);

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      surface: card,
      secondary: Color(0xFF4A90FF),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    useMaterial3: true,
  );
}
