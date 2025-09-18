import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.primaryRed),
        brightness: Brightness.light,
        background: const Color(AppConstants.white),
        surface: const Color(AppConstants.white),
        primary: const Color(AppConstants.primaryRed),
        secondary: const Color(AppConstants.secondaryRed),
        error: const Color(AppConstants.primaryRed),
        onPrimary: const Color(AppConstants.white),
        onSecondary: const Color(AppConstants.white),
        onBackground: const Color(AppConstants.black),
        onSurface: const Color(AppConstants.black),
        onError: const Color(AppConstants.white),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(AppConstants.white),
        foregroundColor: Color(AppConstants.black),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(AppConstants.black),
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: Color(AppConstants.black),
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: const Color(AppConstants.white),
        elevation: 2,
        shadowColor: const Color(AppConstants.black).withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppConstants.primaryRed),
          foregroundColor: const Color(AppConstants.white),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(AppConstants.primaryRed),
          side: const BorderSide(
            color: Color(AppConstants.primaryRed),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(AppConstants.primaryRed),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppConstants.lightGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(
            color: Color(AppConstants.primaryRed),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(
            color: Color(AppConstants.primaryRed),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        hintStyle: TextStyle(
          color: const Color(AppConstants.darkGray).withOpacity(0.6),
          fontSize: AppConstants.fontSizeMedium,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(AppConstants.white),
        selectedItemColor: Color(AppConstants.primaryRed),
        unselectedItemColor: Color(AppConstants.darkGray),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(AppConstants.primaryRed),
        foregroundColor: Color(AppConstants.white),
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(AppConstants.gray),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(AppConstants.darkGray),
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Color(AppConstants.black),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(AppConstants.black),
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.black),
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.black),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.black),
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.black),
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.black),
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.black),
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.darkGray),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.black),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.black),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.darkGray),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.black),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.darkGray),
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.darkGray),
        ),
      ),
    );
  }
}
