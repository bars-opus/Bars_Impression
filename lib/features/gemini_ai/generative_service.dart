// This service interacts with the Google Generative AI model to generate responses.
// It can generate text responses based on a prompt and optionally include an image

import 'dart:typed_data';
import 'package:bars/utilities/secrets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GoogleGenerativeAIService {
  late final GenerativeModel _model;

  // Initializes the GenerativeModel with a specific model and API key.
  GoogleGenerativeAIService() {
    const String _apiKey = GeminiApiKey.GEMINIAPI_KEY;
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
  }

  // Generates a text response based on a given prompt.
  Future<String?> generateResponse(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text;
  }

  // Generates a response using a prompt and an image.
  Future<String?> generateResponseWithImage(
      String prompt, Uint8List image) async {
    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', image)]),
    ];
    final response = await _model.generateContent(content);
    return response.text;
  }
}
