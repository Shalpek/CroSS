import 'package:flutter/material.dart';

// Основные цвета бренда
const accent = Color(0xFFFF7A00);

// Темная тема
final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1E2738),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1E2738),
    secondary: accent,
    surface: Color(0xFF2A3246),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white70,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E2738),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: accent,
    unselectedLabelColor: Colors.white70,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: accent, width: 3),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2A3246),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.white38),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(accent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
    ),
  ),
  dividerColor: Colors.white12,
);

// Светлая тема
final ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.white,
    secondary: accent,
    surface: Color(0xFFF5F6FA),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: accent,
    unselectedLabelColor: Colors.black54,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: accent, width: 3),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F6FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.black38),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(accent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
    ),
  ),
  dividerColor: Colors.black12,
);
