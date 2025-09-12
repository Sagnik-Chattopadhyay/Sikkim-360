import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  // 🔑 Hardcode your Gemini API key here
  static const String _apiKey = "AIzaSyCN-V9NFY8ikUGoZNAUc3K-7R5IAAqwjQQ";

  static Future<String> analyzeImage(File image) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey',
    );

    // Convert image to base64
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Build request body in the format Gemini expects
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "Classify this monastery image by century or modernity."},
            {
              "inline_data": {
                "mime_type": "image/jpeg", // or "image/png" depending on your files
                "data": base64Image,
              }
            }
          ]
        }
      ]
    });

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          'No result';
    } else {
      throw Exception('Failed to classify image: ${response.body}');
    }
  }
}
