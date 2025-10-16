import 'package:flutter/material.dart';
// FIX: Import the new QR Scanner Screen
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryMaroon = const Color(0xFF800000);
  String _scanResult = 'Ready to scan QR to start navigating';

  // Function to launch the scanner
  void _startScan() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (result != null) {
      setState(() {
        _scanResult = 'Scanned: $result';
      });
      // Optionally navigate based on the result here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation Data Scanned: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
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
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Search Bar (Events, Speakers)
            TextField(
              decoration: InputDecoration(
                hintText: 'SEARCH EVENTS, SPEAKERS...',
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

            // Navigation Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                IconTile(icon: Icons.bookmark_border, label: 'SEMINARS'),
                IconTile(icon: Icons.dashboard_customize_outlined, label: 'HACKATHONS'),
                IconTile(icon: Icons.build_outlined, label: 'WORKSHOPS'),
                IconTile(icon: Icons.museum_outlined, label: 'CULTURAL'),
                IconTile(icon: Icons.computer_outlined, label: 'TECH Fests'),
              ],
            ),
            const SizedBox(height: 40),

            // QR Scanner Circle (Now functional)
            Center(
              child: GestureDetector(
                onTap: _startScan,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: primaryMaroon, // Make the button maroon for better visibility/interactivity
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.qr_code_2, color: Colors.white, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                // Display scan result or default prompt
                _scanResult.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600, 
                  color: _scanResult.startsWith('Scanned') ? primaryMaroon : const Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Events Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EVENTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                Icon(Icons.arrow_forward_ios, size: 16, color: primaryMaroon),
              ],
            ),
            const SizedBox(height: 10),
            // Placeholder for Event Card
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300)
              ),
              alignment: Alignment.center,
              child: const Text('Event Card: Literovia 8-9 SEPT', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Helper widget for Home Screen Icons (remains StatelessWidget)
class IconTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: const Color(0xFF333333)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}