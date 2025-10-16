import 'package:flutter/material.dart';
import '../main.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  // Mock login logic state
  String _selectedRole = 'Student'; // Default role
  final TextEditingController _usernameController = TextEditingController(text: 'user@vnr.edu');
  final TextEditingController _passwordController = TextEditingController(text: 'password');

  void _login() {
    // Mock authentication check
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      // Determine the role status to pass
      bool isTeacher = _selectedRole == 'Teacher';
      bool isAdmin = _selectedRole == 'Admin';
      
      // Navigate to Dashboard, passing the role status
      Navigator.pushReplacementNamed(
        context, 
        '/dashboard',
        arguments: {
          'isTeacher': isTeacher,
          'isAdmin': isAdmin, // Admin currently not used but set up for future
        }
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CAMPUS COMPASS', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset(
                'assets/vnr_logo_small.png', // Placeholder for small logo image
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 1),
                    ),
                    child: const Center(
                      child: Text('VNR Logo', style: TextStyle(color: primaryColor, fontSize: 10)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Text('Estd. 1995', style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 30),
              
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please log in to continue.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Role Selector
              _buildRoleSelector(),
              const SizedBox(height: 20),
              
              // Username Field
              _buildTextField(
                controller: _usernameController,
                hintText: 'Username / Email',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              
              // Password Field
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              
              // Remember Me / Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (bool? value) {}),
                      const Text('Remember Me', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: primaryColor,
                ),
                child: const Text('LOGIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              
              // Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: Text('Sign Up Here', style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Social Logins (Mock)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.g_mobiledata),
                  _buildSocialIcon(Icons.facebook),
                  _buildSocialIcon(Icons.apple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
          items: <String>['Student', 'Teacher', 'Admin']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text('Log in as $value'),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
  
  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 30, color: Colors.black87),
      ),
    );
  }
}