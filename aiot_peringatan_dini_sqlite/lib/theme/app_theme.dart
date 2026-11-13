import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFFD84315);

  static ThemeData _bangun(Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: b),
        appBarTheme: const AppBarTheme(centerTitle: true),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        ),
      );

  static ThemeData get lightTheme => _bangun(Brightness.light);
  static ThemeData get darkTheme => _bangun(Brightness.dark);
}
