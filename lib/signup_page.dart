import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String role = "User"; // default role

  Future<void> createUserWithEmailAndPassword() async {
    final userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // save extra data (name + role) in Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "role": role,
    });

    // update Firebase displayName
    await userCredential.user!.updateDisplayName(_nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || !value.contains('@')
                    ? "Enter a valid email"
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) => value != null && value.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              const SizedBox(height: 16),

              // Role selection
              const Text(
                "Are you a:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: const Text("User"),
                value: "User",
                groupValue: role,
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text("Local"),
                value: "Local",
                groupValue: role,
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await createUserWithEmailAndPassword();
                    Navigator.pop(context); // back to auth gate
                  }
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
