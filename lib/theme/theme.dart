import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppTheme {
  // Light theme (like OPay)
  static ThemeData get lightThemeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B386), // OPay green
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF00B386)),
          titleTextStyle: TextStyle(
            color: Color(0xFF00B386),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF00B386), // OPay green
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 4,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        useMaterial3: true,
      );

  // Dark theme (like OPay dark mode)
  static ThemeData get darkThemeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B386),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF00B386)),
          titleTextStyle: TextStyle(
            color: Color(0xFF00B386),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF00B386),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 4,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        useMaterial3: true,
      );
}
