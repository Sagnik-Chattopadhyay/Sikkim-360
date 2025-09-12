import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventAdder extends StatefulWidget {
  const EventAdder({super.key});

  @override
  State<EventAdder> createState() => _EventAdderState();
}

class _EventAdderState extends State<EventAdder> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedMonastery;

  final List<Map<String, dynamic>> monasteries = [
    {"name": "Rumtek Monastery", "lat": 27.3326, "lng": 88.6122},
    {"name": "Pemayangtse Monastery", "lat": 27.3185, "lng": 88.2396},
    {"name": "Tashiding Monastery", "lat": 27.2667, "lng": 88.2667},
    {"name": "Enchey Monastery", "lat": 27.3389, "lng": 88.6069},
    {"name": "Phodong Monastery", "lat": 27.4302, "lng": 88.5881},
  ];

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedMonastery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final selectedMonastery = monasteries.firstWhere(
          (m) => m["name"] == _selectedMonastery,
    );

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection("events").add({
      "monasteryName": _selectedMonastery,
      "coordinates": {
        "lat": selectedMonastery["lat"],
        "lng": selectedMonastery["lng"],
      },
      "eventTitle": _eventTitleController.text.trim(),
      "eventDescription": _eventDescriptionController.text.trim(),
      "eventDate": _selectedDate.toString().split(" ")[0],
      "startTime": _selectedTime!.format(context),
      "createdBy": user?.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event submitted successfully")),
    );

    Navigator.pop(context); // go back to home after submitting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_monastery.jpg"),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Local Event",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 16),

                      // Event title
                      TextFormField(
                        controller: _eventTitleController,
                        decoration: const InputDecoration(
                          labelText: "Event Title",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Enter event title" : null,
                      ),
                      const SizedBox(height: 16),

                      // Event description
                      TextFormField(
                        controller: _eventDescriptionController,
                        decoration: const InputDecoration(
                          labelText: "Event Description",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty ? "Enter event description" : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown for monasteries
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Select Monastery",
                          border: OutlineInputBorder(),
                        ),
                        items: monasteries.map((m) {
                          return DropdownMenuItem<String>(
                            value: m["name"] as String,
                            child: Text(m["name"] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedMonastery = value);
                        },
                        validator: (value) => value == null ? "Select a monastery" : null,
                      ),
                      const SizedBox(height: 16),

                      // Date and time pickers
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _pickDate,
                              child: Text(_selectedDate == null
                                  ? "Pick Date"
                                  : _selectedDate.toString().split(" ")[0]),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _pickTime,
                              child: Text(_selectedTime == null
                                  ? "Pick Time"
                                  : _selectedTime!.format(context)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      ElevatedButton(
                        onPressed: _submitEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Submit Event", style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
