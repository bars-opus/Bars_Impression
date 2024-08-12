import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:bars/utilities/secrets.dart';

class VisionApiHelper {
  Future<Map<String, dynamic>?> safeSearchDetect(String imagePath) async {
    final String apiKey = visionHelperApiKey.VISIONHELPERPAPI_KEY;
    final Uri endpoint = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final response = await http.post(
      endpoint,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'requests': [
          {
            'image': {
              'content': base64Encode(await File(imagePath)
                  .readAsBytes()), // Convert the image file to a base64 encoded string
            },
            'features': [
              {
                'type': 'SAFE_SEARCH_DETECTION'
              }, // Use the Safe Search Detection feature
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error with Google Vision API: ${response.reasonPhrase}');
      return null;
    }
  }
}
