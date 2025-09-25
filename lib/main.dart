import 'package:flutter/material.dart';
import 'package:safetravel_app/features/auth/presentation/screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeTravel App',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(
          0xFF030213,
        ), // Deep Dark Blue from design spec
        scaffoldBackgroundColor: const Color(
          0xFFFFFFFF,
        ), // Pure White background
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF030213), // Deep Dark Blue
          secondary: Color(0xFFF0F0F3), // Light Blue Gray
          surface: Color(0xFFFFFFFF), // White
          surfaceContainerHighest: Color(0xFFECECF0), // Muted
          tertiary: Color(0xFFDC2626), // Emergency Red
          error: Color(0xFFD4183D), // Destructive Red
          onPrimary: Color(0xFFFFFFFF), // White text on primary
          onSecondary: Color(0xFF030213), // Dark text on secondary
          onSurface: Color(0xFF030213), // Dark text on surface
          outline: Color(0x1A000000), // 10% Black border
          brightness: Brightness.light,
        ),
        // Text Theme following design spec
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(
            0xFFF3F3F5,
          ), // Input background from design spec
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), // Small border radius
            borderSide: const BorderSide(
              color: Color(0x1A000000),
            ), // 10% Black border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0x1A000000)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF030213), width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF030213,
            ), // Primary from design spec
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 44), // Minimum touch target
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF030213),
            minimumSize: const Size(0, 44),
            side: const BorderSide(color: Color(0x1A000000)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 1,
          shadowColor: Color(0x1A000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const RegistrationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
