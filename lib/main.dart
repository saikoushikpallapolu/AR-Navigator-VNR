import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_form_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/qr_scanner_page.dart';
import 'screens/faculty_finder_screen.dart';

// Define the primary color (Maroon from the logo)
const Color primaryColor = Color(0xFF800000);
// Define a secondary color for backgrounds
const Color secondaryColor = Color(0xFFC8A2C8); 

void main() {
  runApp(const CampusCompassApp());
}

class CampusCompassApp extends StatelessWidget {
  const CampusCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Compass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: primaryColor),
          headlineMedium: TextStyle(color: primaryColor),
          titleLarge: TextStyle(color: primaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(primaryColor))
            .copyWith(secondary: primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginFormScreen(),
        '/dashboard': (context) => const DashboardScreen(), 
        '/scanner': (context) => const QrScannerPage(),
        '/faculty_finder': (context) => const FacultyFinderScreen(), 
      },
    );
  }
}

// Helper function to create MaterialColor from Color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}