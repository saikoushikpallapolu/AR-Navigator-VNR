import 'package:flutter/material.dart';
import '../../models/faculty_model.dart';

class FacultyProfileScreen extends StatelessWidget {
  final Faculty faculty;

  const FacultyProfileScreen({super.key, required this.faculty});

  @override
  Widget build(BuildContext context) {
    const Color primaryMaroon = Color(0xFF800000);
    const Color primaryLavender = Color(0xFFE6E6FA);

    // Convert Firestore availability to color
    Color statusColor;
    switch (faculty.availability.toLowerCase()) {
      case 'available':
        statusColor = Colors.green;
        break;
      case 'in class':
        statusColor = Colors.amber.shade700;
        break;
      case 'on leave':
        statusColor = Colors.red;
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
            // -----------------------
            // HEADER (Lavender Background)
            // -----------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              color: primaryLavender,
              child: Column(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryMaroon.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Name
                  Text(
                    faculty.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),

                  // Department
                  Text(
                    faculty.dept.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  // Designation? You do NOT have this in Firestore
                  // I will show Faculty ID here instead:
                  Text(
                    "FACULTY ID: ${faculty.facultyId}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // -----------------------
            // DETAILS SECTION
            // -----------------------
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildDetailItem(
                    icon: Icons.location_on_outlined,
                    label: 'ROOM NO:',
                    value: faculty.roomNo,
                  ),
                  _buildDetailItem(
                    icon: Icons.phone_outlined,
                    label: 'CONTACT:',
                    value: faculty.number,
                  ),
                  _buildDetailItem(
                    icon: Icons.email_outlined,
                    label: 'EMAIL:',
                    value: faculty.email,
                  ),
                  _buildDetailItem(
                    icon: Icons.apartment,
                    label: 'DEPARTMENT:',
                    value: faculty.dept,
                  ),

                  const SizedBox(height: 20),

                  // -----------------------
                  // STATUS
                  // -----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Current status: ',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      Text(
                        faculty.availability,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // -----------------------
                  // NAVIGATE BUTTON
                  // -----------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Navigating to ${faculty.roomNo} via map...',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.near_me_outlined, size: 24),
                      label: const Text(
                        'Navigate To Room',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryMaroon,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  // -----------------------
  // DETAIL ITEM BUILDER
  // -----------------------
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
          Icon(
            icon,
            size: 24,
            color: isAction ? const Color(0xFF800000) : Colors.grey[700],
          ),
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
