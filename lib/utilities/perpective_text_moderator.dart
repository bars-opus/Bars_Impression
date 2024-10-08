import 'dart:convert';
import 'package:bars/utilities/secrets.dart';
import 'package:http/http.dart' as http;

class TextModerator {
  Future<Map<String, dynamic>?> moderateText(String text) async {
    final String apiKey = visionHelperApiKey.VISIONHELPERPAPI_KEY;

    final Uri endpoint = Uri.parse(
        'https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=$apiKey');

    final response = await http.post(
      endpoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'comment': {'text': text},
        'languages': ['en'], // Specify the language of the text being checked
        'requestedAttributes': {
          'TOXICITY': {},
          'SEVERE_TOXICITY': {},
          'IDENTITY_ATTACK': {},
          'INSULT': {},
          'PROFANITY': {},
          'THREAT': {},
          'SEXUALLY_EXPLICIT': {},
          // 'FLIRTATION': {}, // Add other attributes here as needed
        }
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error with Perspective API: ${response.reasonPhrase}');
      return null; // Handle the error as appropriate for your application
    }
  }
}
