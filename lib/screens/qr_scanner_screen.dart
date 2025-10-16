import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // The camera view is the main body content
          MobileScanner(
            // Use this to prevent the camera from being used if the screen is not visible
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              // Only process the first barcode detected
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? "Unknown Code";
                
                // Stop the camera and navigate back, showing the result
                Navigator.pop(context, code);
              }
            },
          ),
          
          // Overlay for instructions or framing
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Align QR Code within the box',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}