import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';// Import the package

class Monastery extends StatelessWidget {
  const Monastery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monastery Tour'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              src: 'assets/sikkim_monastery_lowpoly.glb', // Your 3D model path
              alt: "A 3D model of the Monastery",
              backgroundColor: Colors.transparent,
              ar: true,
              autoRotate: true,
              cameraControls: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to homescreen'),
            ),
          ),
        ],
      ),
    );
  }
}
