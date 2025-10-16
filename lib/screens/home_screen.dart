import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_auth_model.dart'; 
import '../models/event_model.dart'; // Imports Event and EventDetail
import 'qr_scanner_screen.dart'; 
import 'event_detail_screen.dart'; 
import 'profile_screen.dart'; // Used to access notifications data and handle logout

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryMaroon = const Color(0xFF800000);
  String _scanResult = 'Ready to scan QR to start navigating';
  final TextEditingController _searchController = TextEditingController();
  List<Event> _filteredEvents = [];
  
  final Map<String, GlobalKey> _categoryKeys = {
    'Seminars': GlobalKey(),
    'Hackathons': GlobalKey(),
    'Workshops': GlobalKey(),
    'Cultural': GlobalKey(),
    'Tech Fests': GlobalKey(),
  };

  // --- Sample Events Data (15 Events) ---
  final List<Event> allEvents = [
    // Seminars (3 events)
    Event(title: 'AI in Health', date: 'Oct 25', category: 'Seminars', description: 'ML applications in diagnostics.', room: 'A-201', isLive: true,
      details: EventDetail(title: 'AI in Health', date: 'Oct 25, 2025 (10:00 AM)', room: 'A-201', topics: ['ML Fundamentals', 'Data Synthesis', 'Clinical Trials'], speakers: ['Dr. V. Rao', 'Prof. J. Mehta'], isLive: true)),
    Event(title: 'Blockchain Basics', date: 'Nov 02', category: 'Seminars', description: 'Intro to decentralized ledger tech.', room: 'A-110',
      details: EventDetail(title: 'Blockchain Basics', date: 'Nov 02, 2025 (11:00 AM)', room: 'A-110', topics: ['Hash Functions', 'Mining Process', 'Smart Contracts'], speakers: ['Mr. R. Gupta'], isLive: false)),
    Event(title: 'Cyber Security', date: 'Dec 05', category: 'Seminars', description: 'Trends in ethical hacking.', room: 'E-305',
      details: EventDetail(title: 'Cyber Security', date: 'Dec 05, 2025 (2:00 PM)', room: 'E-305', topics: ['Pen Testing', 'DDoS Mitigation', 'Cloud Security'], speakers: ['Ms. P. Sharma'], isLive: false)),
    
    // Hackathons (3 events)
    Event(title: 'Code Blitz 24H', date: 'Nov 09-10', category: 'Hackathons', description: '24-hour coding challenge.', room: 'Auditorium', isLive: true,
      details: EventDetail(title: 'Code Blitz 24H', date: 'Nov 09-10, 2025', room: 'Auditorium', topics: ['Rapid Prototyping', 'Teamwork', 'Pitching'], speakers: ['Mr. S. Kumar', 'Tech Team'], isLive: true)),
    Event(title: 'App Dev Marathon', date: 'Dec 01-02', category: 'Hackathons', description: 'Build mobile apps using Flutter.', room: 'Labs B-401',
      details: EventDetail(title: 'App Dev Marathon', date: 'Dec 01-02, 2025', room: 'Labs B-401', topics: ['UI/UX', 'State Management', 'Backend Integration'], speakers: ['Prof. L. Singh'], isLive: false)),
    Event(title: 'IoT Challenge', date: 'Jan 15-16', category: 'Hackathons', description: 'Smart device prototyping.', room: 'E-501',
      details: EventDetail(title: 'IoT Challenge', date: 'Jan 15-16, 2026', room: 'E-501', topics: ['Sensor Data', 'Microcontrollers', 'Cloud Services'], speakers: ['Dr. A. Reddy'], isLive: false)),
    
    // Workshops (3 events)
    Event(title: 'React Native', date: 'Oct 28-29', category: 'Workshops', description: 'Cross-platform mobile development.', room: 'Workshop C',
      details: EventDetail(title: 'React Native', date: 'Oct 28-29, 2025', room: 'Workshop C', topics: ['Hooks', 'Styling', 'API Calls'], speakers: ['Mr. J. Rao'], isLive: false)),
    Event(title: 'Cloud Computing', date: 'Nov 20', category: 'Workshops', description: 'Mastering AWS and Azure.', room: 'Lab A-105', isLive: true,
      details: EventDetail(title: 'Cloud Computing', date: 'Nov 20, 2025 (1:00 PM)', room: 'Lab A-105', topics: ['Virtual Machines', 'Scaling', 'Serverless'], speakers: ['Ms. N. Kaur'], isLive: true)),
    Event(title: 'UI/UX Design', date: 'Jan 05', category: 'Workshops', description: 'Interface design principles.', room: 'Design Studio',
      details: EventDetail(title: 'UI/UX Design', date: 'Jan 05, 2026 (9:30 AM)', room: 'Design Studio', topics: ['Figma', 'Wireframing', 'User Testing'], speakers: ['Prof. T. Bose'], isLive: false)),

    // Cultural (3 events)
    Event(title: 'Annual Cultural Fest', date: 'Mar 25-27', category: 'Cultural', description: 'Celebration of arts, music, and dance.', room: 'Amphitheater',
      details: EventDetail(title: 'Annual Cultural Fest', date: 'Mar 25-27, 2026', room: 'Amphitheater', topics: ['Music', 'Dance', 'Drama'], speakers: ['Culture Committee'], isLive: false)),
    Event(title: 'Literary Gala', date: 'Apr 05', category: 'Cultural', description: 'Poetry, debates, and storytelling.', room: 'Library Hall',
      details: EventDetail(title: 'Literary Gala', date: 'Apr 05, 2026', room: 'Library Hall', topics: ['Poetry', 'Debate', 'Short Stories'], speakers: ['Lit Club'], isLive: false)),
    Event(title: 'Theater Night', date: 'May 01', category: 'Cultural', description: 'Live drama and theatrical performances.', room: 'Auditorium',
      details: EventDetail(title: 'Theater Night', date: 'May 01, 2026', room: 'Auditorium', topics: ['Improv', 'Stage Design', 'Script Writing'], speakers: ['Drama Club'], isLive: false)),

    // Tech Fests (3 events)
    Event(title: 'Electra Tech Fest', date: 'Apr 10-12', category: 'Tech Fests', description: 'Electronics and communication exhibition.', room: 'Block C Hall',
      details: EventDetail(title: 'Electra Tech Fest', date: 'Apr 10-12, 2026', room: 'Block C Hall', topics: ['Robotics', 'VLSI', 'Antennas'], speakers: ['ECE Dept.'], isLive: false)),
    Event(title: 'Mech Expo', date: 'May 20-22', category: 'Tech Fests', description: 'Mechanical design showcase.', room: 'Workshop B',
      details: EventDetail(title: 'Mech Expo', date: 'May 20-22, 2026', room: 'Workshop B', topics: ['CAD', 'Thermodynamics', 'Fluid Mechanics'], speakers: ['Mechanical Dept.'], isLive: false)),
    Event(title: 'CompSci Zenith', date: 'Jun 18-19', category: 'Tech Fests', description: 'Coding, robotics, and future tech.', room: 'Block A Hall',
      details: EventDetail(title: 'CompSci Zenith', date: 'Jun 18-19, 2026', room: 'Block A Hall', topics: ['AI/ML', 'Web 3.0', 'Quantum Computing'], speakers: ['CSE Dept.'], isLive: false)),
  ];
  
  // Group events by category for easier display
  late final Map<String, List<Event>> _groupedEvents;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _groupedEvents = _groupEventsByCategory(allEvents);
    _filteredEvents = List.from(allEvents);
    _searchController.addListener(_filterEvents);
  }

  // Helper methods (filterEvents, scrollToCategory, startScan, dispose) omitted for brevity

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = List.from(allEvents);
      } else {
        _filteredEvents = allEvents
            .where((event) =>
                event.title.toLowerCase().contains(query) ||
                event.category.toLowerCase().contains(query) ||
                event.description.toLowerCase().contains(query) ||
                event.room.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _scrollToCategory(String category) {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear(); 
    }
    
    final key = _categoryKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _startScan() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (result != null) {
      setState(() {
        _scanResult = 'Scanned: $result';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation Data Scanned: $result')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.removeListener(_filterEvents);
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<Event>> _groupEventsByCategory(List<Event> events) {
    Map<String, List<Event>> grouped = {};
    for (var event in events) {
      grouped.putIfAbsent(event.category, () => []).add(event);
    }
    final sortedKeys = _categoryKeys.keys.toList();
    Map<String, List<Event>> finalGrouped = {};
    for (var key in sortedKeys) {
      finalGrouped[key] = grouped[key] ?? [];
    }
    return finalGrouped;
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

  Widget _buildDrawer(BuildContext context, UserAuthModel auth, ProfileScreen profileScreen) {
    final Color primaryMaroon = Theme.of(context).primaryColor;
    final List<Map<String, String>> relevantNotifications = profileScreen.getRelevantNotifications(auth.userRole, profileScreen.notifications);

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(profileScreen.getProfileData(auth.userRole)['name'] ?? 'User Name'),
            accountEmail: Text(profileScreen.getProfileData(auth.userRole)['email'] ?? 'user@vnr.edu'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF800000)),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF800000), // Maroon header
            ),
          ),
          
          // Navigation Items (Reflecting the Footer options)
          _buildDrawerItem(context, 0, 'Home', Icons.home),
          _buildDrawerItem(context, 1, 'Faculty', Icons.people),
          _buildDrawerItem(context, 2, 'Library', Icons.local_library),
          _buildDrawerItem(context, 3, 'Profile', Icons.person),
          const Divider(),

          // Notifications Link
          ListTile(
            leading: Icon(Icons.notifications, color: primaryMaroon),
            title: const Text('View Notifications'),
            trailing: CircleAvatar(
              radius: 10,
              backgroundColor: relevantNotifications.isNotEmpty ? Colors.red : Colors.transparent,
              child: relevantNotifications.isNotEmpty 
                ? Text('${relevantNotifications.length}', style: const TextStyle(fontSize: 10, color: Colors.white))
                : null,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showNotificationsDialog(context, relevantNotifications, primaryMaroon);
            },
          ),

          // Logout (Fixed at the bottom)
          Expanded(child: Container()), 
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('LOG OUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Trigger logout logic defined in ProfileScreen's button
              profileScreen.handleLogout(context, auth);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  // Helper for drawer items
  Widget _buildDrawerItem(BuildContext context, int index, String title, IconData icon) {
    final auth = Provider.of<UserAuthModel>(context, listen: false);
    final isSelected = auth.selectedIndex == index;
    const Color primaryMaroon = Color(0xFF800000);
    
    return ListTile(
      leading: Icon(icon, color: isSelected ? primaryMaroon : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryMaroon : Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        // Change the selected index in the Main Navigation Screen
        auth.setSelectedIndex(index); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserAuthModel>(context);
    final isSearching = _searchController.text.isNotEmpty;
    // Get notifications using a temporary instance of ProfileScreen
    final ProfileScreen profileScreen = ProfileScreen(); 
    final List<Map<String, String>> relevantNotifications = profileScreen.getRelevantNotifications(auth.userRole, profileScreen.notifications);
    
    return Scaffold(
      // --- CHANGE 2: Add Drawer (Side Menu) ---
      drawer: _buildDrawer(context, auth, profileScreen),
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(), // Opens the drawer
          ),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 20),
            SizedBox(width: 4),
            Text('VNR VIGNANA JYOTHI INSTITUTE', style: TextStyle(fontSize: 14)),
          ],
        ),
        centerTitle: true,
        actions: [
          // --- CHANGE 1: Notifications Icon Logic ---
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
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            // --- Search Bar ---
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'SEARCH EVENTS, ROOMS, CATEGORIES...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF333333)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            // --- Navigation Icons Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconTile(icon: Icons.bookmark_border, label: 'SEMINARS', category: 'Seminars'),
                _buildIconTile(icon: Icons.dashboard_customize_outlined, label: 'HACKATHONS', category: 'Hackathons'),
                _buildIconTile(icon: Icons.build_outlined, label: 'WORKSHOPS', category: 'Workshops'),
                _buildIconTile(icon: Icons.museum_outlined, label: 'CULTURAL', category: 'Cultural'),
                _buildIconTile(icon: Icons.computer_outlined, label: 'TECH Fests', category: 'Tech Fests'),
              ],
            ),
            const SizedBox(height: 40),

            // --- QR Scanner Section ---
            Center(
              child: GestureDetector(
                onTap: _startScan,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: primaryMaroon,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.qr_code_2, color: Colors.white, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _scanResult.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600, 
                  color: _scanResult.startsWith('SCANNED') ? primaryMaroon : const Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- Events Section Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isSearching ? 'SEARCH RESULTS' : 'EVENTS', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: primaryMaroon),
              ],
            ),
            const SizedBox(height: 10),

            // --- Events List Area ---
            if (isSearching && _filteredEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: Text('No events found matching your search.')),
              )
            else if (isSearching)
              // Display filtered events in a simple list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredEvents.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(_filteredEvents[index], context);
                },
              )
            else
              // Display grouped, non-filtered events
              ..._categoryKeys.keys.map((category) {
                final events = _groupedEvents[category] ?? [];
                if (events.isEmpty) return const SizedBox.shrink(); // Hide empty categories

                return Column(
                  key: _categoryKeys[category], // Attach the GlobalKey here for scrolling
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(events[index], context);
                      },
                    ),
                  ],
                );
              }).toList(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  // Helper to build the clickable icon tiles (omitted for brevity)
  Widget _buildIconTile({required IconData icon, required String label, required String category}) {
    return GestureDetector(
      onTap: () => _scrollToCategory(category),
      child: Column(
        children: [
          Icon(icon, size: 28, color: const Color(0xFF333333)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Helper to build a visually appealing event card (omitted for brevity)
  Widget _buildEventCard(Event event, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        leading: Container(
          width: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryMaroon.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(event.date.split(' ')[0], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryMaroon)),
              Text(event.date.split(' ').length > 1 ? event.date.split(' ')[1] : '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(
              children: [
                Text('Room: ${event.room}', style: TextStyle(fontSize: 12, color: primaryMaroon)),
                
                // Live Tag and Navigation Button for Live Events
                if (event.isLive) ...[
                  const SizedBox(width: 8),
                  const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  const SizedBox(width: 4),
                  Text('LIVE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                ]
              ],
            ),
          ],
        ),
        // Trailing widget combines navigation and detail arrow
        trailing: event.isLive 
          ? IconButton(
              icon: const Icon(Icons.near_me, color: Color(0xFF800000)),
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigating to live event in ${event.room}...')),
                  );
              },
            )
          : const Icon(Icons.chevron_right, size: 20),
        
        onTap: () {
          // Navigate to the Event Detail Screen on tap
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event.details),
          ));
        },
      ),
    );
  }
}