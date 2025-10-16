import 'package:flutter/material.dart';
// FIX: Import the EventDetail model from the dedicated model file
import '../models/event_model.dart'; 

class EventDetailScreen extends StatelessWidget {
  final EventDetail event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color primaryMaroon = Color(0xFF800000);
    final Color headerColor = event.isLive ? Colors.red.shade100 : Colors.blueGrey.shade50;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: headerColor,
        elevation: 0,
        foregroundColor: primaryMaroon,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Event Header ---
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: primaryMaroon),
                      const SizedBox(width: 5),
                      Text(event.date, style: TextStyle(fontSize: 16, color: primaryMaroon)),
                      const SizedBox(width: 15),
                      Icon(Icons.room, size: 16, color: primaryMaroon),
                      const SizedBox(width: 5),
                      Text(event.room, style: TextStyle(fontSize: 16, color: primaryMaroon)),
                    ],
                  ),
                  if (event.isLive) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                        const SizedBox(width: 5),
                        Text('LIVE NOW', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Topics Covered ---
            Text('Topics Covered', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryMaroon)),
            const SizedBox(height: 10),
            ...event.topics.map((topic) => Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(topic, style: const TextStyle(fontSize: 16))),
                ],
              ),
            )).toList(),
            
            const SizedBox(height: 30),

            // --- Speakers/People Involved ---
            Text('Speakers / Organizers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryMaroon)),
            const SizedBox(height: 10),
            ...event.speakers.map((speaker) => ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.black54),
              title: Text(speaker, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(event.speakers.indexOf(speaker) == 0 ? 'Lead Speaker' : 'Organizer', style: const TextStyle(fontSize: 12)),
              contentPadding: EdgeInsets.zero,
            )).toList(),

            const SizedBox(height: 40),

            // --- Navigation Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Starting navigation to ${event.room}...')),
                  );
                },
                icon: const Icon(Icons.near_me_outlined, size: 24),
                label: Text('Navigate to ${event.room}', style: const TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}