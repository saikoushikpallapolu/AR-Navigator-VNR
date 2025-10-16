import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String userRole;
  
  // Sample data structure for the profile
  final Map<String, dynamic> profileData;

  const UserProfileScreen({
    super.key,
    required this.userRole,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryMaroon = Color(0xFF800000);
    final Color headerColor = userRole == 'Teacher' ? Colors.teal.shade50 : Colors.indigo.shade50;
    final String title = userRole == 'Teacher' ? 'Teacher Profile' : 'Student Profile';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: headerColor,
        foregroundColor: primaryMaroon,
        elevation: 1,
        // Edit button at the top right (App-level edit)
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entering Edit Mode (Form Implementation Needed)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Profile Header (Avatar and Role) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_2_outlined, size: 60, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profileData['name'] ?? 'User Name',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    userRole,
                    style: TextStyle(fontSize: 16, color: primaryMaroon),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Profile Details Section ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      icon: Icons.alternate_email,
                      label: 'Email',
                      value: profileData['email'] ?? 'user@vnr.edu',
                      canEdit: true,
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.badge_outlined,
                      label: userRole == 'Teacher' ? 'Designation' : 'Roll/ID Number',
                      value: profileData['id'] ?? 'T012 / 21911A05A1',
                      canEdit: userRole != 'Student',
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.school_outlined,
                      label: userRole == 'Teacher' ? 'Department' : 'Branch/Year',
                      value: profileData['dept'] ?? 'CSE / IV Year',
                      canEdit: userRole == 'Teacher',
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'D.O.B',
                      value: profileData['dob'] ?? '01/01/2002',
                      canEdit: false,
                    ),
                    _buildDetailRow(
                      context,
                      icon: Icons.phone_outlined,
                      label: 'Contact',
                      value: profileData['contact'] ?? '9876543210',
                      canEdit: true,
                    ),
                    
                    // Teacher Specific Detail
                    if (userRole == 'Teacher')
                      _buildDetailRow(
                        context,
                        icon: Icons.location_on_outlined,
                        label: 'Office Room',
                        value: profileData['office'] ?? 'E-015',
                        canEdit: true,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            
            // --- Feature Suggestion: Quick Access Settings ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
            ),
            const SizedBox(height: 10),
            _buildActionCard(
              icon: Icons.lock_open,
              title: 'Change Password',
              subtitle: 'Update your security credentials.',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Change Password Form'))),
            ),
            _buildActionCard(
              icon: Icons.notifications_active_outlined,
              title: 'Notification Preferences',
              subtitle: 'Manage alerts for events and updates.',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Preferences Settings'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool canEdit,
  }) {
    const Color primaryMaroon = Color(0xFF800000);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: primaryMaroon.withOpacity(0.7)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
          if (canEdit)
            IconButton(
              icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade600),
              onPressed: () {
                // Individual field edit action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editing: $label ($value)')),
                );
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF800000)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}