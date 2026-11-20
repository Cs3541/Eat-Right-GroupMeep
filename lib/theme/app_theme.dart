import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color lightGreen = Color(0xFFF3F6F1);
  static const Color originalLightGreen = Color(0xFFC2CCC0);
  static const Color darkBrown = Color(0xFF2B0C30);
  static const Color darkGreen = Color(0xFF005B35);
  static const Color mediumGreen = Color(0xFF719278);
  static const Color mutedRed = Color(0xFF9A2343);

  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      
      scaffoldBackgroundColor: lightGreen,

      colorScheme: const ColorScheme.light(
        primary: darkGreen,
        onPrimary: white,
        secondary: mediumGreen,
        onSecondary: white,
        tertiary: mutedRed,
        onTertiary: white,
        surface: white,
        onSurface: darkBrown,
        error: mutedRed,
        onError: white,
      ),

      // General text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkBrown,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkBrown,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: darkBrown,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkBrown,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: darkBrown,
        ),
        bodyMedium: TextStyle(
          color: darkBrown,
        ),
      ),

      // App bars
      appBarTheme: const AppBarTheme(
        backgroundColor: lightGreen,
        foregroundColor: darkBrown,
        elevation: 0,
        centerTitle: false,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: white,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Main buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkGreen,
          side: const BorderSide(color: darkGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        labelStyle: const TextStyle(color: darkBrown),
        hintStyle: TextStyle(
          color: darkBrown.withValues(alpha: 0.55),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: originalLightGreen,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: originalLightGreen,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: darkGreen,
            width: 2,
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: darkGreen,
        unselectedItemColor: mediumGreen,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: originalLightGreen,
        thickness: 1,
      ),

      // Progress indicators
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: darkGreen,
        linearTrackColor: originalLightGreen,
      ),
    );
  }
}