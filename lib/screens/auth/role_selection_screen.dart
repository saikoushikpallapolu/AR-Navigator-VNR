import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative paths to navigate up (../../models and ../screens)
import '../../models/user_auth_model.dart';
import '../main_navigation_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color primaryMaroon = const Color(0xFF800000);

  void _handleLogin() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select if you are a Student or a Teacher.')),
      );
      return;
    }
    
    // 1. Update the state model (UserAuthModel is now found via relative import)
    final auth = Provider.of<UserAuthModel>(context, listen: false);
    auth.setRole(_selectedRole!);
    auth.login();

    // 2. Explicitly navigate to the main screen, replacing the login screen.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  Widget _buildRoleButton(String role) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedRole = role;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? primaryMaroon : Colors.white,
            foregroundColor: isSelected ? Colors.white : primaryMaroon,
            side: BorderSide(color: primaryMaroon, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: isSelected ? 4 : 1,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            role,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMPUS COMPASS'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              // *** FINAL CHANGE: LOGO SIZE SET TO 0.6 ***
              Center(
                child: Image.asset(
                  'assets/vnr_logo.png', // Path to your logo file
                  height: size.width * 0.6,
                  width: size.width * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please log in to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // --- Role Selection Area ---
              const Text(
                'I am a:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRoleButton('Student'),
                  _buildRoleButton('Teacher'),
                ],
              ),
              const SizedBox(height: 30),
              // --- Login Form ---
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username / Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (val) {}),
                      const Text('Remember Me', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: TextStyle(color: primaryMaroon, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                  ),
                  child: const Text('LOGIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text("Don't have an account? Sign Up Here", style: TextStyle(color: primaryMaroon)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}