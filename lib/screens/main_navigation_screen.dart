import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative paths
import '../models/user_auth_model.dart';
import 'home_screen.dart';
import 'faculty/faculty_wrapper_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';
// NEW: Import the QR Scanner screen
import 'qr_scanner_screen.dart'; 


class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  // Define the screens for the footer
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FacultyWrapperScreen(), // Role-based dashboard
    const LibraryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);
    final Color primaryMaroon = Theme.of(context).primaryColor;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(auth.selectedIndex),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Faculty',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_library_outlined),
              activeIcon: Icon(Icons.local_library),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: auth.selectedIndex,
          selectedItemColor: primaryMaroon,
          unselectedItemColor: Colors.grey[600],
          onTap: auth.setSelectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}