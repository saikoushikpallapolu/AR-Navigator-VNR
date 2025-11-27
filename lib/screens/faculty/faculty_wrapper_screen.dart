import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_auth_model.dart';
import 'student_finder_screen.dart';
import 'teacher_dashboard_screen.dart';

import '../../services/faculty_service.dart';
import '../../models/faculty_model.dart';

class FacultyWrapperScreen extends StatelessWidget {
  const FacultyWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);

    // -----------------------------
    // STUDENT SIDE
    // -----------------------------
    if (auth.userRole == 'Student') {
      return const StudentFacultyFinderScreen();
    }

    // -----------------------------
    // TEACHER SIDE (NO AUTH MODE)
    // Loads first faculty document
    // -----------------------------
    if (auth.userRole == 'Teacher') {
      final facultyService = FacultyService();

      return StreamBuilder<List<Faculty>>(
        stream: facultyService.getFacultyStream(), // real-time
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final facultyList = snapshot.data!;
          if (facultyList.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No faculty found in Firestore')),
            );
          }

          // 🔥 TEMP: always load FIRST faculty
          final faculty = facultyList.first;

          return TeacherFacultyDashboardScreen(faculty: faculty);
        },
      );
    }

    // -----------------------------
    // FALLBACK
    // -----------------------------
    return Scaffold(
      appBar: AppBar(title: const Text('Faculty')),
      body: const Center(child: Text('Select student or teacher')),
    );
  }
}
