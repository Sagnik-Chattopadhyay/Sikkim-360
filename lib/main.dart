import 'package:flutter/material.dart';
import 'package:sikkim_app/audio.dart';
import 'package:sikkim_app/coordinates.dart';
import 'package:sikkim_app/event_planner.dart';
import 'package:sikkim_app/manuscripts.dart';
import 'package:sikkim_app/location.dart';
import 'package:sikkim_app/monastery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homescreen(),
    );
  }
}

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sikkim App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Explore Sikkim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Coordinates'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocationScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack_sharp),
              title: const Text('Audio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const audio()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.temple_buddhist),
              title: const Text('Monastery Tour'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Monastery()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Manuscripts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Manuscripts()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Sikkim App!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
