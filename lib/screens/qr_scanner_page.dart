import 'package:flutter/material.dart';
// Note: Assuming 'mobile_scanner' or 'qr_code_scanner' is installed.
// The actual import path and widget name might vary based on the chosen package.
// For this example, I'll use a placeholder for the scanner logic.
// In a real Flutter app, replace this placeholder with the actual package implementation.

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  String _scanResult = 'Scan a QR Code to navigate...';

  // MOCK function to simulate opening and processing the camera scan
  void _startMockScan() {
    // In a real app, this is where you'd initialize the camera and scanner widget.
    // Since we can't run the native camera, we simulate the result.
    setState(() {
      _scanResult = 'Camera opened... scanning...';
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      // Mock successful scan result
      setState(() {
        _scanResult = 'Scanned successfully! Navigating to Room E305...';
      });

      // Show the result and pop back to the dashboard after a short delay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_scanResult)),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pop(context); // Go back to the dashboard
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startMockScan(); // Automatically start the "camera" scan simulation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Placeholder for the live camera feed area
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Icon(Icons.videocam, size: 100, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _scanResult,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            // In a real implementation, the button would be for manual focus/torch control
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _scanResult = 'Restarting scan...';
                });
                _startMockScan();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Scan'),
            ),
          ],
        ),
      ),
    );
  }
}