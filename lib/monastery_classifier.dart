import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'gemini_service.dart'; // your AI service//

class MonasteryClassifier extends StatefulWidget {
  const MonasteryClassifier({super.key});

  @override
  State<MonasteryClassifier> createState() => _MonasteryClassifierState();
}

class _MonasteryClassifierState extends State<MonasteryClassifier> {
  File? _image;
  String _result = "";
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = ""; // reset previous result
      });
    }
  }

  Future<void> _classifyImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      // Call your Gemini service
      final response = await GeminiService.analyzeImage(_image!);

      setState(() {
        // Clean markdown (remove **)
        _result = response.replaceAll("**", "");
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monastery Classifier")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _image!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Camera & Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ],
            ),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _classifyImage,
              child: const Text("Classify Image"),
            ),

            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_result.isNotEmpty)
              Text(
                _result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
