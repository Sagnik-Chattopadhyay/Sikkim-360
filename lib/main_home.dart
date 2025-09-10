import 'package:flutter/material.dart';
import 'package:sikkim_app/audio.dart';
import 'package:sikkim_app/coordinates.dart';
import 'package:sikkim_app/manuscripts.dart';
import 'package:sikkim_app/location.dart';
import 'package:sikkim_app/monastery.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Sikkim App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Explore Sikkim',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Coordinates'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LocationScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack_sharp),
              title: const Text('Audio'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const audio()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.temple_buddhist),
              title: const Text('Monastery Tour'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Monastery()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Manuscripts'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Manuscripts()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          user != null
              ? "Welcome, ${user.displayName ?? user.email}!"
              : "Welcome to Sikkim App!",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
