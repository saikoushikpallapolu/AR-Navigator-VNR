import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Your auth model
import '../../models/user_auth_model.dart';

// Firestore integration
import '../../models/faculty_model.dart';
import '../../services/faculty_service.dart';

// Updated: FacultyProfileScreen must accept Faculty instead of TeacherData
import 'faculty_profile_screen.dart';

class StudentFacultyFinderScreen extends StatefulWidget {
  const StudentFacultyFinderScreen({super.key});

  @override
  State<StudentFacultyFinderScreen> createState() =>
      _StudentFacultyFinderScreenState();
}

class _StudentFacultyFinderScreenState
    extends State<StudentFacultyFinderScreen> {
  final Color primaryMaroon = const Color(0xFF800000);
  final TextEditingController _searchController = TextEditingController();

  final FacultyService facultyService = FacultyService();
  List<Faculty> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  // 🔥 NEW: Firestore Search
  void _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final results = await facultyService.searchFaculty(query);
    setState(() => searchResults = results);
  }

  // 🔥 UPDATED: Build Search Result List using Firestore Faculty model
  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) return Container();

    if (searchResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Text(
            'No faculty found matching your search.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final f = searchResults[index];

        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: Text(
                f.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${f.dept} • ${f.email}'),
              trailing: Text(
                f.roomNo,
                style: TextStyle(
                  color: primaryMaroon,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        FacultyProfileScreen(faculty: f), // UPDATED
                  ),
                );
              },
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  // ---------------------------
  // Your EXISTING UI below
  // ---------------------------

  Widget _buildCampusBlockDiagram() {
    final List<String> blocks = [
      'A Block',
      'B Block',
      'C Block',
      'D Block',
      'E Block',
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryMaroon.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Campus Layout Overview',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: blocks
                .map(
                  (block) => Container(
                    width: 50,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryMaroon.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryMaroon, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        block,
                        style: TextStyle(
                          color: primaryMaroon,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Text(
            'Tap "View Campus Map" for detailed navigation.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Finder'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Provider.of<UserAuthModel>(
            context,
            listen: false,
          ).setSelectedIndex(0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // -----------------------
            // Search Bar (UNCHANGED)
            // -----------------------
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
                      controller: _searchController,
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

            if (isSearching)
              _buildSearchResults()
            else ...[
              const Text(
                'Previous Searches:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildSearchTag(context, 'Prof. Madhubala', 'madhubala'),
                  _buildSearchTag(context, 'E101', 'e101'),
                  _buildSearchTag(context, 'CSE', 'cse'),
                ],
              ),
              const SizedBox(height: 40),
              Center(child: _buildCampusBlockDiagram()),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening full campus map...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map_outlined, size: 24),
                  label: const Text(
                    'View Campus Map',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryMaroon,
                    side: BorderSide(color: primaryMaroon, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Search tag helper
  Widget _buildSearchTag(BuildContext context, String text, String query) {
    return GestureDetector(
      onTap: () {
        _searchController.value = TextEditingValue(
          text: query,
          selection: TextSelection.collapsed(offset: query.length),
        );
      },
      child: Chip(
        label: Text(
          text,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
    );
  }
}
