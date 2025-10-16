import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/event_card.dart';
import 'faculty_finder_screen.dart'; // Import the screen for direct navigation

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  
  // Role Status received from the Login Page
  bool _isTeacherLoggedIn = false; 
  // bool _isAdminLoggedIn = false; // For future use

  final List<Map<String, String>> _allEvents = [
    {'title': 'Literovia', 'type': 'event', 'date': '8-9 SEP', 'placeholder': 'Literovia Event'},
    {'title': 'HyCa', 'type': 'seminar', 'date': '15-17 OCT', 'placeholder': 'HyCa Seminar'},
    {'title': 'Scintillationz', 'type': 'fest', 'date': '1-2 DEC', 'placeholder': 'Scintillationz Fest'},
    {'title': 'SIH', 'type': 'hackathon', 'date': '22-23 NOV', 'placeholder': 'SIH Hackathon'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely retrieve arguments passed from the login screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isTeacherLoggedIn = args['isTeacher'] ?? false;
      // _isAdminLoggedIn = args['isAdmin'] ?? false;
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) { // Index 2 is the Faculty/People icon
      // Navigate and pass the role status
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FacultyFinderScreen(isTeacherRole: _isTeacherLoggedIn),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getIconLabel(index)} pressed!')),
      );
    }
  }

  String _getIconLabel(int index) {
    switch(index) {
      case 0: return 'Home';
      case 1: return 'Calendar'; 
      case 2: return 'People'; 
      case 3: return 'Profile';
      default: return '';
    }
  }

  // Filter logic for the search bar
  List<Map<String, String>> get _filteredEvents {
    if (_searchQuery.isEmpty) {
      return _allEvents;
    }
    final queryLower = _searchQuery.toLowerCase();
    return _allEvents.where((event) {
      return event['title']!.toLowerCase().contains(queryLower) ||
             event['type']!.toLowerCase().contains(queryLower);
    }).toList();
  }

  // QR Scanner Trigger Function (Navigates to the camera screen)
  void _triggerScanner(BuildContext context) {
    Navigator.pushNamed(context, '/scanner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('VNR VIGNANA JYOTHI INSTITUTE', style: TextStyle(fontSize: 14, color: Colors.black)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Working Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value; 
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'SEARCH EVENTS, SPEAKERS...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                  ),
                ),
              ),
            ),

            // Horizontal Category Scroll
            _buildCategories(),

            // Center Scanner Section
            _buildScannerSection(context),

            // Vertically Scrollable Events Section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'EVENTS >',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'Showing ${_filteredEvents.length} results',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: SizedBox(
                height: 200, 
                child: _filteredEvents.isEmpty
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No events found matching your search criteria.'),
                      ))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          return EventCard(
                            title: event['title']!,
                            date: event['date']!,
                            imagePlaceholderText: event['placeholder']!,
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Footer (Bottom Navigation Bar)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'People'), // Faculty Finder integrated here
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategories() {
    final List<Map<String, dynamic>> categories = [
      {'label': 'SEMINARS', 'icon': Icons.speaker_group},
      {'label': 'HACKATHONS', 'icon': Icons.code},
      {'label': 'WORKSHOPS', 'icon': Icons.build},
      {'label': 'CULTURAL', 'icon': Icons.palette},
      {'label': 'TECH FESTS', 'icon': Icons.flash_on},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(categories[index]['icon'], color: primaryColor, size: 30),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    categories[index]['label'],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScannerSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Scanner Button
          GestureDetector(
            onTap: () => _triggerScanner(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: const Icon(
                Icons.qr_code_scanner, 
                size: 120, 
                color: Colors.black87
              ),
            ),
          ),
          const Text(
            'SCAN QR TO START NAVIGATING',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}