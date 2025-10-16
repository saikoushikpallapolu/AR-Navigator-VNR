import 'package:flutter/material.dart';
import '../main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 50),
            // Logo Section
            Column(
              children: [
                Image.asset(
                  'assets/vnr_logo_large.png', // Placeholder for large logo image
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'VNR Logo',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'VNR VIGNANA JYOTHI INSTITUTE OF\nENGINEERING AND TECHNOLOGY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            
            // Welcome Message
            Column(
              children: const [
                Text(
                  'WELCOME TO CAMPUS COMPASS,\nYOUR NAVIGATION GUIDE IS READY!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.red, // Used red color as seen in the image mock
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
            
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'GET STARTED',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}