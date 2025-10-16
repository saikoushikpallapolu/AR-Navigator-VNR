import 'package:flutter/material.dart';
import '../main.dart'; // To access primaryColor

// Data model for a faculty member
class Faculty {
  final String name;
  final String room;
  final String department;
  final ValueNotifier<bool> isAvailable; // Use ValueNotifier for mock real-time updates

  Faculty({
    required this.name,
    required this.room,
    required this.department,
    required bool initialAvailability,
  }) : isAvailable = ValueNotifier(initialAvailability);
}

class FacultyFinderScreen extends StatefulWidget {
  final bool isTeacherRole; // New parameter to define the role

  // If true, shows the 'Find My Current Location' button (for Teachers).
  // If false (Student), only shows 'View Campus Map'.
  const FacultyFinderScreen({
    super.key,
    this.isTeacherRole = false, // Default to student view for safety
  });

  @override
  State<FacultyFinderScreen> createState() => _FacultyFinderScreenState();
}

class _FacultyFinderScreenState extends State<FacultyFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Faculty> _allFaculty = [];
  List<Faculty> _filteredSuggestions = [];
  List<String> _searchHistory = ['Prof. Madhubala', 'E102', 'Prof. Jhansi'];

  @override
  void initState() {
    super.initState();
    // Initialize faculty data
    _allFaculty = [
      Faculty(name: 'Prof. Madhubala', room: 'E102', department: 'CSE', initialAvailability: true),
      Faculty(name: 'Prof. Nagini', room: 'C205', department: 'CSE', initialAvailability: false),
      Faculty(name: 'Prof. Jhansi', room: 'D310', department: 'CSE', initialAvailability: true),
      Faculty(name: 'Prof. Thirmal', room: 'L101', department: 'Physics', initialAvailability: false),
    ];
    
    _searchController.addListener(_onSearchChanged);
    
    // Mock availability changes for demonstration
    _startMockAvailabilityUpdates();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    for (var faculty in _allFaculty) {
      faculty.isAvailable.dispose();
    }
    super.dispose();
  }

  // Mocks background availability status updates
  void _startMockAvailabilityUpdates() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      // Example: Nagini becomes available, Madhubala becomes busy
      _allFaculty.firstWhere((f) => f.name == 'Prof. Madhubala').isAvailable.value = false;
      _allFaculty.firstWhere((f) => f.name == 'Prof. Nagini').isAvailable.value = true;
      
      // Schedule the next update
      Future.delayed(const Duration(seconds: 10), _startMockAvailabilityUpdates);
    });
  }


  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        // If query is empty, show all faculty as suggestions
        _filteredSuggestions = _allFaculty;
      } else {
        // Filter suggestions based on name or room
        _filteredSuggestions = _allFaculty.where((faculty) {
          return faculty.name.toLowerCase().contains(query) ||
                 faculty.room.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _handleSearchSubmit(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        // Keep history to a reasonable size
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      });
    }
    FocusScope.of(context).unfocus(); // Hide keyboard
  }
  
  void _selectSuggestion(Faculty faculty) {
    _searchController.text = faculty.name;
    _handleSearchSubmit(faculty.name);
    // Force the suggestion list to show only the selected faculty
    setState(() {
      _filteredSuggestions = [faculty];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list to show below the search bar
    final List<Faculty> displayList = _searchController.text.isEmpty
        ? [] // If search is empty, don't show all faculty, only history
        : _filteredSuggestions;
        
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Finder', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: secondaryColor, // Light Purple/Lavender
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _handleSearchSubmit,
                  decoration: const InputDecoration(
                    hintText: 'Search Faculty by name/room',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.menu, color: primaryColor),
                    suffixIcon: Icon(Icons.search, color: primaryColor),
                  ),
                ),
              ),
            ),
            
            // Suggestions/History Area
            if (_searchController.text.isEmpty)
              _buildSearchHistory()
            else
              _buildSuggestionsList(displayList),

            // Logo Placeholder
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/vnr_logo_mock.png', height: 80, errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Center(
                          child: Text('VNR Logo', style: TextStyle(color: primaryColor, fontSize: 10)),
                        ),
                      );
                    }),
                    const Text('Estd. 1995', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ),
            
            // Conditional Button: Find My Current Location (Teacher Only)
            if (widget.isTeacherRole)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Finding current location... (Mock)')),
                    );
                  },
                  icon: const Icon(Icons.location_pin, size: 28),
                  label: const Text('Find My Current Location', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Solid color for primary action
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

            // Campus Map Button (Both Student and Teacher)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing Campus Map... (Mock)')),
                  );
                },
                icon: const Icon(Icons.map_outlined, size: 28),
                label: const Text('View Campus Map', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            // Quick Help Box
            _buildQuickHelpBox(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestionsList(List<Faculty> suggestions) {
    if (suggestions.isEmpty && _searchController.text.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No faculty found matching your query.', style: TextStyle(fontStyle: FontStyle.italic)),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final faculty = suggestions[index];
        return ListTile(
          onTap: () => _selectSuggestion(faculty),
          leading: const Icon(Icons.person, color: primaryColor),
          title: Text(faculty.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${faculty.room} | ${faculty.department}'),
          trailing: ValueListenableBuilder<bool>(
            valueListenable: faculty.isAvailable,
            builder: (context, isAvailable, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(
                      color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: isAvailable ? Colors.green : Colors.red,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
  
  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Previous Searches:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: _searchHistory.map((query) {
              return ActionChip(
                label: Text(query, style: TextStyle(color: primaryColor)),
                onPressed: () {
                  _searchController.text = query;
                  _handleSearchSubmit(query);
                },
                backgroundColor: primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: primaryColor.withOpacity(0.5)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickHelpBox() {
    return Container(
      margin: const EdgeInsets.all(32.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(Icons.help_outline, color: primaryColor, size: 28),
              const SizedBox(width: 10),
              Text(
                'Quick Help:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.isTeacherRole 
              ? 'As a faculty member, you can use "Find My Current Location" to update your live status and room location for students. Use the search bar to check colleagues.'
              : 'Use the search bar to find faculty by their name or room number. Tap on a result to get their details and availability status.\n\nView on map to explore the entire campus layout.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}