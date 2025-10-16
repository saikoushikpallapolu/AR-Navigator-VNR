import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// FIX: Using relative path to navigate up to models/ and to the new profile screen
import '../../models/user_auth_model.dart';
import 'faculty_profile_screen.dart';

class StudentFacultyFinderScreen extends StatefulWidget {
  const StudentFacultyFinderScreen({super.key});

  @override
  State<StudentFacultyFinderScreen> createState() => _StudentFacultyFinderScreenState();
}

class _StudentFacultyFinderScreenState extends State<StudentFacultyFinderScreen> {
  final Color primaryMaroon = const Color(0xFF800000);
  final TextEditingController _searchController = TextEditingController();
  List<TeacherData> _filteredTeachers = [];

  // 1. Defined Faculty Data List
  final List<TeacherData> allTeachers = [
    TeacherData(
      name: 'Prof. Nagini',
      department: 'CSE',
      designation: 'Associate Professor',
      room: 'E101',
      phone: '9845xxxxxx',
      officeHours: '10:00-12:00',
      status: 'In Class',
    ),
    TeacherData(
      name: 'Prof. Madhubala',
      department: 'CSE',
      designation: 'Professor',
      room: 'E203',
      phone: '9987xxxxxx',
      officeHours: '09:00-17:00',
      status: 'Available',
    ),
    TeacherData(
      name: 'Prof. Jhansi',
      department: 'CSE',
      designation: 'Assistant Professor',
      room: 'E110',
      phone: '8765xxxxxx',
      officeHours: '14:00-16:00',
      status: 'Available',
    ),
    TeacherData(
      name: 'Prof. Thirmal',
      department: 'ECE',
      designation: 'Professor',
      room: 'B302',
      phone: '7770xxxxxx',
      officeHours: '11:00-13:00',
      status: 'On Leave',
    ),
    TeacherData(
      name: 'Prof. Ravindra',
      department: 'CSE',
      designation: 'Head of Department',
      room: 'C403',
      phone: '9000xxxxxx',
      officeHours: '16:00-18:00',
      status: 'Available',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add a listener to trigger filtering and UI rebuild on every text change
    _searchController.addListener(_filterTeachers);
    _filteredTeachers = List.from(allTeachers); // Initially show all
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    // setState call here rebuilds the widget tree
    setState(() {
      if (query.isEmpty) {
        _filteredTeachers = List.from(allTeachers);
      } else {
        _filteredTeachers = allTeachers
            .where((teacher) =>
                teacher.name.toLowerCase().contains(query) ||
                teacher.room.toLowerCase().contains(query) ||
                teacher.department.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTeachers);
    _searchController.dispose();
    super.dispose();
  }

  // Helper widget to display the filtered results
  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return Container(); // Hide results when search bar is empty
    }
    
    if (_filteredTeachers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Text('No faculty found matching your search.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredTeachers.length,
      itemBuilder: (context, index) {
        final teacher = _filteredTeachers[index];
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${teacher.department} - ${teacher.designation}'),
              trailing: Text(teacher.room, style: TextStyle(color: primaryMaroon, fontWeight: FontWeight.bold)),
              onTap: () {
                // Navigate to the Faculty Profile Screen
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FacultyProfileScreen(teacher: teacher),
                ));
              },
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // Determine if the search bar has text
    final isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Finder'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Provider.of<UserAuthModel>(context, listen: false).setSelectedIndex(0), // Back to home
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Color(0xFF333333)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController, // Linked to controller
                      decoration: InputDecoration(
                        hintText: 'Search Faculty by name, room, or dept...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Color(0xFF333333)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Conditionally Display Search Results or Default Widgets ---
            if (isSearching) 
              _buildSearchResults()
            else ...[
              // Only show these widgets when search bar is empty
              const Text(
                'Previous Searches:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: [
                  // Added onTap handler to fill the search bar for quick search
                  _buildSearchTag(context, 'Prof. Madhubala', 'madhubala'),
                  _buildSearchTag(context, 'E101', 'e101'),
                  _buildSearchTag(context, 'CSE', 'cse'),
                ],
              ),
              const SizedBox(height: 40),

              // 2. Sample Map Placeholder
              Center(
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 50, color: primaryMaroon),
                      const SizedBox(height: 8),
                      const Text('Campus Map Visualization', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                      Text('Dynamic 2D/3D Map View Placeholder', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // View Campus Map Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening full campus map...')),
                     );
                  },
                  icon: const Icon(Icons.map_outlined, size: 24),
                  label: const Text('View Campus Map', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryMaroon,
                    side: BorderSide(color: primaryMaroon, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Quick Help Box (Retained)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryMaroon.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(left: BorderSide(color: primaryMaroon, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: primaryMaroon, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Help:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the search bar to find faculty by their name or room number. Tap on a result to get their details and availability status.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                    ),
                    const Text(
                      '\nView on map to explore the entire campus layout.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTag(BuildContext context, String text, String query) {
    return GestureDetector(
      onTap: () {
        // Set the controller text and move the cursor to the end
        _searchController.value = TextEditingValue(
          text: query,
          selection: TextSelection.collapsed(offset: query.length),
        );
      },
      child: Chip(
        label: Text(text, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
        backgroundColor: Colors.white,
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
    );
  }
}