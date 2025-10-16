import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative path to navigate up to models/ and into the current directory
import '../../models/user_auth_model.dart';
import 'student_finder_screen.dart';
import 'teacher_dashboard_screen.dart';
// NEW: Import the model used for Faculty data
import 'faculty_profile_screen.dart'; 


class FacultyWrapperScreen extends StatelessWidget {
  const FacultyWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);

    if (auth.userRole == 'Student') {
      return const StudentFacultyFinderScreen();
    } else if (auth.userRole == 'Teacher') {
      return const TeacherFacultyDashboardScreen();
    } else {
      // Fallback screen in case the role is somehow missing
      return Scaffold(
        appBar: AppBar(title: const Text('Faculty')),
        body: const Center(child: Text('Please log in to view the Faculty dashboard.')),
      );
    }
  }
}