import 'package:flutter/material.dart';
// FIX: Using relative path to access the auth subfolder
import 'auth/role_selection_screen.dart'; 

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const Color primaryMaroon = Color(0xFF800000);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // *** CHANGE: INCREASED LOGO SIZE TO 0.9 ***
              Image.asset(
                'assets/vnr_logo.png', // Path to your logo file
                height: size.width * 0.9,
                width: size.width * 0.9,
                fit: BoxFit.contain, // Ensures the whole logo fits within the boundaries
              ),
              
              const SizedBox(height: 50),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'WELCOME TO CAMPUS COMPASS,\nYOUR NAVIGATION GUIDE IS READY!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryMaroon,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.15),
              SizedBox(
                width: size.width * 0.7,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Role Selection, replacing the splash screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}