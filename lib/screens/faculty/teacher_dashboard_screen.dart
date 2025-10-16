import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative path to navigate up two levels (../../models)
import '../../models/user_auth_model.dart';

class TeacherFacultyDashboardScreen extends StatefulWidget {
  const TeacherFacultyDashboardScreen({super.key});

  @override
  State<TeacherFacultyDashboardScreen> createState() => _TeacherFacultyDashboardScreenState();
}

class _TeacherFacultyDashboardScreenState extends State<TeacherFacultyDashboardScreen> {
  String _currentStatus = 'Available';
  final Color primaryMaroon = const Color(0xFF800000);

  // Status map to assign color
  final Map<String, Color> statusColors = {
    'Available': Colors.green.shade600,
    'In Class': Colors.amber.shade700,
    'On Leave': Colors.red.shade600,
  };

  void _updateStatus(String status) {
    setState(() {
      _currentStatus = status;
    });
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
          onPressed: () => Provider.of<UserAuthModel>(context, listen: false).setSelectedIndex(0), // Back to home
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Current Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dr. XXXXXXXX',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Current status : ',
                        style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
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
                  const Text(
                    'Room : E012',
                    style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated : 3 min ago',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Update Availability Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusOption('Available'),
                  _buildStatusOption('In Class'),
                  _buildStatusOption('On Leave'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for other teacher widgets
            ListTile(
              leading: Icon(Icons.calendar_today, color: primaryMaroon),
              title: const Text('View Today\'s Schedule'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.book_online, color: primaryMaroon),
              title: const Text('Manage Appointment Requests'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

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
          _updateStatus(value);
        }
      },
      activeColor: primaryMaroon,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
    );
  }
}