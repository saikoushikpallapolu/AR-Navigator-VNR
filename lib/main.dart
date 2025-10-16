import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// FIX: Using relative paths to access siblings
import 'models/user_auth_model.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';


void main() {
  runApp(
    // Wrap the app with ChangeNotifierProvider to manage state
    ChangeNotifierProvider(
      create: (context) => UserAuthModel(),
      child: const CampusCompassApp(),
    ),
  );
}

class CampusCompassApp extends StatelessWidget {
  const CampusCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryMaroon = Color(0xFF800000);

    return MaterialApp(
      title: 'Campus Compass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryMaroon,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFF800000,
            <int, Color>{
              50: Color(0xFFF5E5E5),
              100: Color(0xFFE6B8B8),
              200: Color(0xFFD38A8A),
              300: Color(0xFFC05C5C),
              400: Color(0xFFAA3A3A),
              500: primaryMaroon,
              600: Color(0xFF730000),
              700: Color(0xFF660000),
              800: Color(0xFF590000),
              900: Color(0xFF400000),
            },
          ),
        ).copyWith(secondary: primaryMaroon),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryMaroon),
          titleTextStyle: TextStyle(
            color: primaryMaroon,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Check auth state to show the correct entry screen
      home: Consumer<UserAuthModel>(
        builder: (context, auth, _) {
          // If the user is logged in, show the main navigation screen (Home, Footer, etc.)
          if (auth.isLoggedIn) {
            return const MainNavigationScreen();
          }
          // If not logged in, start with the Splash Screen
          return const SplashScreen();
        },
      ),
    );
  }
}