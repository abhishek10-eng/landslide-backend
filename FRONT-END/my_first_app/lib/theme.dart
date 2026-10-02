import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFFF4F6F8),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D47A1),
      primary: const Color(0xFF0D47A1),
      secondary: const Color(0xFF00BFA5),
    ),
  );
}
