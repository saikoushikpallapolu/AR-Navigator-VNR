import 'package:flutter/material.dart';

// --- Event Detail Data Structure (The data shown on the click screen) ---
class EventDetail {
  final String title;
  final String date;
  final String room;
  final List<String> topics;
  final List<String> speakers;
  final bool isLive;

  EventDetail({
    required this.title,
    required this.date,
    required this.room,
    required this.topics,
    required this.speakers,
    required this.isLive,
  });
}

// --- Main Event Model (The data used on the Home Screen card) ---
class Event {
  final String title;
  final String date;
  final String category;
  final String description;
  final String room;
  final bool isLive;
  final EventDetail details; 

  Event({
    required this.title,
    required this.date,
    required this.category,
    required this.description,
    required this.room,
    this.isLive = false,
    required this.details,
  });
}