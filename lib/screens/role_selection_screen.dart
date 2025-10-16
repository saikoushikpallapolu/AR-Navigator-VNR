import 'package:flutter/material.dart';
import '../main.dart'; // To access primaryColor

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, String role) {
    if (role == 'Student/Visitor') {
      // 3) On clicking Student/Visitor, shift to the main homepage (scanner one)
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Admin and Teachers are considered "pre-registered" logins and are mocked to proceed.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$role login successful! Accessing $role Dashboard... (Mock)')),
      );
      Navigator.pushReplacementNamed(context, '/dashboard'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Access as:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 40),

              _buildRoleButton(context, 'Student/Visitor', Icons.school),
              const SizedBox(height: 20),
              _buildRoleButton(context, 'Teacher', Icons.person_pin),
              const SizedBox(height: 20),
              _buildRoleButton(context, 'Admin', Icons.admin_panel_settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _selectRole(context, role),
      icon: Icon(icon, size: 28),
      label: Text(
        role,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}