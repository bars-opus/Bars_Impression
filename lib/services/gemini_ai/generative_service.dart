import 'package:bars/services/gemini_ai/gemini_api_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GoogleGenerativeAIService {
  late final GenerativeModel _model;

  GoogleGenerativeAIService() {
    const String _apiKey = GeminiApiKey.GEMINIAPI_KEY;

    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
  }

  Future<String?> generateResponse(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text;
  }
}
