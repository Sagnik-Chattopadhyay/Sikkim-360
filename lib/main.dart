import 'package:flutter/material.dart';
import 'package:sikkim_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sikkim_app/auth_gate.dart';
import 'monastery_classifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
 feature/manu
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
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Explore Sikkim',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Coordinates'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ),
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
        child: Text('Welcome to Sikkim App!', style: TextStyle(fontSize: 20)),
      ),

      title: 'Sikkim Monastery AI',
      // Show AuthGate first. MonasteryClassifier can be accessed after login.
      home: const AuthGate(),

    );
  }
}
