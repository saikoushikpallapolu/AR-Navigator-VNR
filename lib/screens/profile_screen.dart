import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative paths
import '../models/user_auth_model.dart';
import 'auth/role_selection_screen.dart'; // Import Role Selection

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);
    final Color primaryMaroon = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: primaryMaroon.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Profile Screen\nLogged in as a ${auth.userRole}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // 1. Reset the authentication state
                auth.logout(); 

                // 2. Clear the navigation stack and push the RoleSelectionScreen (Login Page)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                  (Route<dynamic> route) => false, // Predicate returns false, clearing all routes
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}