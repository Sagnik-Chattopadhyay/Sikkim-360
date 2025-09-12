import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventViewer extends StatelessWidget {
  const EventViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_monastery.jpg"),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Upcoming Local Events",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),

            // StreamBuilder for live Firestore updates
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("events")
                    .orderBy("eventDate", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading events"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final events = snapshot.data!.docs;

                  if (events.isEmpty) {
                    return const Center(
                      child: Text(
                        "No events available",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final eventData =
                          event.data() as Map<String, dynamic>? ?? {};

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventData["eventTitle"] ?? "Untitled Event",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                eventData["eventDescription"] ??
                                    "No description",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "📍 ${eventData["monasteryName"] ?? "Unknown Monastery"}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "📅 ${eventData["eventDate"] ?? "Unknown Date"}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "⏰ ${eventData["startTime"] ?? "Unknown Time"}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
