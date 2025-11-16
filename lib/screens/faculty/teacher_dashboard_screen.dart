import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_auth_model.dart';
import '../../models/faculty_model.dart';
import '../../services/faculty_service.dart';

class TeacherFacultyDashboardScreen extends StatefulWidget {
  final Faculty faculty; // 🔥 NEW: Accept faculty object

  const TeacherFacultyDashboardScreen({super.key, required this.faculty});

  @override
  State<TeacherFacultyDashboardScreen> createState() =>
      _TeacherFacultyDashboardScreenState();
}

class _TeacherFacultyDashboardScreenState
    extends State<TeacherFacultyDashboardScreen> {
  final Color primaryMaroon = const Color(0xFF800000);
  final FacultyService facultyService = FacultyService();

  late String _currentStatus;

  // Status colors
  final Map<String, Color> statusColors = {
    'Available': Colors.green,
    'In Class': Colors.amber,
    'On Leave': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.faculty.availability; // 🔥 Load status from Firestore
  }

  // 🔥 FIRESTORE UPDATE FUNCTION
  Future<void> _updateStatus(String status) async {
    setState(() {
      _currentStatus = status;
    });

    await facultyService.updateAvailability(widget.faculty.id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status updated to: $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<UserAuthModel>(context, listen: false)
                .setSelectedIndex(0);
          },
        ),
        actions: const [
          Icon(Icons.notifications_none),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ------------------------------------
            // 🔥 PROFILE CARD USING FIRESTORE DATA
            // ------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Faculty Name
                  Text(
                    widget.faculty.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Status Row
                  Row(
                    children: [
                      const Text(
                        'Current status: ',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF333333)),
                      ),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: statusColors[_currentStatus],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: statusColors[_currentStatus],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Room Number
                  Text(
                    'Room : ${widget.faculty.roomNo}',
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF333333)),
                  ),

                  const SizedBox(height: 8),

                  // Placeholder for last updated
                  Text(
                    'Last updated: Just now',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ------------------------------------
            // 🔥 UPDATE AVAILABILITY SECTION
            // ------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Availability',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildStatusOption('Available'),
                  _buildStatusOption('In Class'),
                  _buildStatusOption('On Leave'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Other dashboard options (unchanged)
            ListTile(
              leading: Icon(Icons.calendar_today, color: primaryMaroon),
              title: const Text("View Today's Schedule"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.book_online, color: primaryMaroon),
              title: const Text("Manage Appointment Requests"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // 🔥 RADIO BUTTON OPTION FOR STATUS CHANGE
  // -----------------------------------------
  Widget _buildStatusOption(String status) {
    Color statusColor = statusColors[status]!;

    return RadioListTile<String>(
      title: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: statusColor,
          ),
          const SizedBox(width: 8),
          Text(status, style: const TextStyle(fontSize: 16)),
        ],
      ),
      value: status,
      groupValue: _currentStatus,
      onChanged: (value) {
        if (value != null) {
          _updateStatus(value); // 🔥 FIRESTORE UPDATE
        }
      },
      activeColor: primaryMaroon,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
    );
  }
}
