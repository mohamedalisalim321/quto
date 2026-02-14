import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.black, // Buttons, highlights
      onPrimary: Colors.white, // Text on primary
      secondary: Colors.grey.shade600, // Accents
      onSecondary: Colors.white,
      surface: Colors.grey.shade100, // Cards, surfaces
      onSurface: Colors.black87,
      shadow: Colors.black26,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    cardColor: Colors.grey.shade100,
    dividerColor: Colors.black26,
    splashColor: Colors.black12,
    highlightColor: Colors.black12,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black87,
      selectionHandleColor: Colors.black54,
      selectionColor: Colors.black12,
    ),
    shadowColor: Colors.black26,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: Colors.white, // Buttons, highlights
      onPrimary: Colors.black,
      secondary: Colors.grey.shade400, // Accents
      onSecondary: Colors.black,
      surface: const Color(0xFF1E1E1E), // Cards, surfaces
      onSurface: Colors.white,
      shadow: Colors.black54,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.white24,
    splashColor: Colors.white12,
    highlightColor: Colors.white10,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.white70,
      selectionColor: Colors.white12,
    ),
    shadowColor: Colors.black54,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white70,
      foregroundColor: Colors.black87,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );
}
