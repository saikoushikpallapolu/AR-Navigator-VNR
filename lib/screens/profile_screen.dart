import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_auth_model.dart';
import 'auth/role_selection_screen.dart'; 
import 'profile/user_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // NEW: Made public for access from HomeScreen
  Map<String, dynamic> getProfileData(String? role) {
    if (role == 'Teacher') {
      return {
        'name': 'Prof. Madhubala',
        'email': 'madhubala@vnr.edu',
        'id': 'T007',
        'dept': 'Computer Science Engineering',
        'dob': 'N/A',
        'contact': '9987654321',
        'office': 'E-203',
      };
    } else {
      return {
        'name': 'Sai Koushik',
        'email': 'saikoushik@vnr.edu',
        'id': '21911A05A1',
        'dept': 'CSE',
        'dob': '15/05/2003',
        'contact': '9012345678',
      };
    }
  }
  
  // NEW: Made public for access from HomeScreen
  final List<Map<String, String>> notifications = const [
    {'title': 'Faculty Meeting', 'subtitle': 'Reminder: Department meeting in E-100 at 3 PM today.', 'role': 'Teacher'},
    {'title': 'Exam Schedule', 'subtitle': 'The Mid-Term exam schedule has been published.', 'role': 'Student'},
    {'title': 'Library Fine', 'subtitle': 'You have an overdue book from 3 days ago.', 'role': 'Both'},
    {'title': 'New Workshop', 'subtitle': 'Sign up for the "Flutter App Development" workshop.', 'role': 'Both'},
  ];

  // NEW: Public method to filter notifications by role
  List<Map<String, String>> getRelevantNotifications(String? userRole, List<Map<String, String>> allNotifications) {
    return allNotifications
        .where((n) => n['role'] == 'Both' || n['role'] == userRole)
        .toList();
  }
  
  // NEW: Public method to handle logout
  void handleLogout(BuildContext context, UserAuthModel auth) {
    auth.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);
    final String userRole = auth.userRole ?? 'Unknown';
    final Color primaryMaroon = Theme.of(context).primaryColor;
    final Map<String, dynamic> profileData = getProfileData(userRole);
    
    // Filter notifications based on role for the AppBar icon on this screen
    final List<Map<String, String>> relevantNotifications = getRelevantNotifications(userRole, notifications);

    return Scaffold(
      appBar: AppBar(
        title: Text('${userRole} Dashboard'),
        actions: [
          // Notifications Section Button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),
                if (relevantNotifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(
                        '${relevantNotifications.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            onPressed: () {
              _showNotificationsDialog(context, relevantNotifications, primaryMaroon);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- User Card ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person_2_outlined, size: 50),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profileData['name'] ?? 'Guest User',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userRole,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- View Profile Button ---
              ListTile(
                leading: Icon(Icons.account_circle_outlined, color: primaryMaroon),
                title: const Text('View / Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Trigger navigation to the detailed profile screen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                      userRole: userRole,
                      profileData: profileData,
                    ),
                  ));
                },
              ),
              const Divider(),
              
              // --- Other Feature Links ---
              _buildFeatureLink(
                context,
                icon: Icons.grading,
                title: userRole == 'Teacher' ? 'Manage Classes & Attendance' : 'View Grades & Transcript',
              ),
              _buildFeatureLink(
                context,
                icon: Icons.event_note,
                title: 'Academic Calendar',
              ),
              _buildFeatureLink(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings & Privacy',
              ),
              
              const SizedBox(height: 40),

              // --- Logout Button (In Red) ---
              ElevatedButton.icon(
                onPressed: () => handleLogout(context, auth),
                icon: const Icon(Icons.logout),
                label: const Text('LOG OUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper methods (omitted for brevity)
  Widget _buildFeatureLink(BuildContext context, {required IconData icon, required String title}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigating to $title... (Placeholder)')),
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  void _showNotificationsDialog(BuildContext context, List<Map<String, String>> notifications, Color primaryMaroon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications, color: primaryMaroon),
              const SizedBox(width: 10),
              const Text('Notifications'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: notifications.isEmpty
                ? const Text('You are all caught up! No new notifications.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final note = notifications[index];
                      return ListTile(
                        leading: Icon(Icons.info_outline, color: primaryMaroon),
                        title: Text(note['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(note['subtitle']!),
                        onTap: () => Navigator.of(context).pop(),
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(color: primaryMaroon)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}