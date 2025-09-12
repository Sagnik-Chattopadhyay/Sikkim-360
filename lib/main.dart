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
      title: 'Sikkim Monastery AI',
      // Show AuthGate first. MonasteryClassifier can be accessed after login.
      home: const AuthGate(),
    );
  }
}
