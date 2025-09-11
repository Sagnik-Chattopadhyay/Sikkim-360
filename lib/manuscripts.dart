import 'dart:io';//
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Manuscripts extends StatefulWidget {
  const Manuscripts({super.key});

  @override
  State<Manuscripts> createState() => _ManuscriptsState();
}

class _ManuscriptsState extends State<Manuscripts> {
  final ImagePicker _picker = ImagePicker();
  String _extractedText = "";
  String _translatedText = "";
  String _summary = "";
  String _summaryHindi = "";
  File? _image;

  // ✅ Initialize Gemini
  final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: "AIzaSyCN-V9NFY8ikUGoZNAUc3K-7R5IAAqwjQQ", // 🔑 Replace with your Gemini API key
  );

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        var status = await Permission.camera.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Camera permission denied")),
          );
          return;
        }
      }

      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
        _extractedText = "";
        _translatedText = "";
        _summary = "";
        _summaryHindi = "";
      });

      await _processImage(File(pickedFile.path));
    } catch (e) {
      debugPrint("❌ Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      if (recognizedText.text.isEmpty) {
        setState(() => _extractedText = "No text found.");
        return;
      }

      setState(() => _extractedText = recognizedText.text);

      // ✅ Summarize extracted text with Gemini
      final summary = await _summarizeText(recognizedText.text);
      setState(() => _summary = summary);

      // ✅ Translate summary into Hindi
      final translatedSummary = await _translateToHindi(summary);
      setState(() => _summaryHindi = translatedSummary);

      // ✅ Detect original text language and translate full text to Hindi (optional)
      final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final String lang =
          await languageIdentifier.identifyLanguage(recognizedText.text);
      await languageIdentifier.close();

      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.values.firstWhere(
          (l) => l.bcpCode == lang,
          orElse: () => TranslateLanguage.english,
        ),
        targetLanguage: TranslateLanguage.hindi,
      );

      final String translated = await translator.translateText(recognizedText.text);
      await translator.close();

      setState(() => _translatedText = translated);
    } catch (e) {
      debugPrint("❌ Error processing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // 🔹 Use Gemini to summarize text
  Future<String> _summarizeText(String text) async {
    try {
      final response = await _gemini.generateContent([
        Content.text("Summarize this text in simple English:\n$text")
      ]);
      return response.text ?? "No summary available.";
    } catch (e) {
      debugPrint("❌ Gemini error: $e");
      return "Failed to summarize.";
    }
  }

  // 🔹 Translate English summary into Hindi
  Future<String> _translateToHindi(String text) async {
    try {
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: TranslateLanguage.hindi,
      );
      final translated = await translator.translateText(text);
      await translator.close();
      return translated;
    } catch (e) {
      debugPrint("❌ Translation error: $e");
      return "Failed to translate.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manuscripts")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 250,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            Text("📜 Extracted Text:\n$_extractedText"),
            const Divider(),
            Text("📝 English Summary:\n$_summary"),
            const Divider(),
            Text("🌐 Summary in Hindi:\n$_summaryHindi"),
            const Divider(),
            Text("🌍 Full Text Translated to Hindi:\n$_translatedText"),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "camera",
            onPressed: () => _pickImage(ImageSource.camera),
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: () => _pickImage(ImageSource.gallery),
            child: const Icon(Icons.photo),
          ),
        ],
      ),
    );
  }
}
