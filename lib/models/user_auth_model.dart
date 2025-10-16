import 'package:flutter/material.dart';

// Simple class to hold the application state (user role and login status)
class UserAuthModel extends ChangeNotifier {
  String? _userRole; // 'Student' or 'Teacher'
  bool _isLoggedIn = false;
  int _selectedIndex = 0; // Current index for Bottom Navigation Bar

  String? get userRole => _userRole;
  bool get isLoggedIn => _isLoggedIn;
  int get selectedIndex => _selectedIndex;

  void setRole(String role) {
    if (role == 'Student' || role == 'Teacher') {
      _userRole = role;
      notifyListeners();
    }
  }

  void login() {
    _isLoggedIn = true;
    _selectedIndex = 0; // Reset to Home on login
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = null;
    _selectedIndex = 0;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}