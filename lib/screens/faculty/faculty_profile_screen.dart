import 'package:flutter/material.dart';

// Data model for the Faculty Profile
class TeacherData {
  final String name;
  final String department;
  final String designation;
  final String room;
  final String phone;
  final String officeHours;
  final String status;

  TeacherData({
    required this.name,
    required this.department,
    required this.designation,
    required this.room,
    required this.phone,
    required this.officeHours,
    required this.status,
  });
}

class FacultyProfileScreen extends StatelessWidget {
  final TeacherData teacher;

  const FacultyProfileScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    const Color primaryMaroon = Color(0xFF800000);
    const Color primaryLavender = Color(0xFFE6E6FA); // Light purple color for the header

    Color statusColor;
    switch (teacher.status) {
      case 'Available':
        statusColor = Colors.green;
        break;
      case 'In Class':
        statusColor = Colors.amber.shade700;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLavender,
        foregroundColor: primaryMaroon,
        elevation: 0,
        title: const Text(
          'Faculty Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section (Lavender Background) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              color: primaryLavender,
              child: Column(
                children: [
                  // Profile Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryMaroon.withOpacity(0.5), width: 1),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Name and Department
                  Text(
                    teacher.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    teacher.department.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    teacher.designation,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // --- Details Section ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Room, Phone, Office Hours, Time Table
                  _buildDetailItem(
                    icon: Icons.location_on_outlined,
                    label: 'ROOM NO:',
                    value: teacher.room,
                  ),
                  _buildDetailItem(
                    icon: Icons.phone_outlined,
                    label: 'CONTACT:',
                    value: teacher.phone,
                  ),
                  _buildDetailItem(
                    icon: Icons.schedule_outlined,
                    label: 'OFFICE HOURS:',
                    value: teacher.officeHours,
                  ),
                  _buildDetailItem(
                    icon: Icons.image_outlined,
                    label: 'TIME TABLE:',
                    value: 'View Time Table',
                    isAction: true,
                  ),

                  const SizedBox(height: 20),

                  // Current Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Current status: ',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      Text(
                        teacher.status,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Navigate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Action: Navigate to Room (Placeholder for future AR/Map integration)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigating to ${teacher.room} via map...')),
                        );
                      },
                      icon: const Icon(Icons.near_me_outlined, size: 24),
                      label: const Text('Navigate To Room', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryMaroon,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: isAction ? const Color(0xFF800000) : Colors.grey[700]),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isAction ? FontWeight.bold : FontWeight.normal,
                  color: isAction ? const Color(0xFF800000) : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}