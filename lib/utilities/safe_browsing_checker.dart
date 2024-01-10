import 'dart:convert';
import 'package:http/http.dart' as http;

class SafeBrowsingChecker {
  Future<bool> isUrlSafe(String url) async {
    final String apiKey = 'AIzaSyCUWeQ75dAnsSRBhN51Iw5rFeyuo_aBvJE';

    final Uri endpoint = Uri.parse(
        'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey');

    try {
      final response = await http
          .post(
            endpoint, // Use the _safeBrowsingUri field with the API key
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'client': {
                'clientId': 'your-application-name',
                'clientVersion': '1.0.0',
              },
              'threatInfo': {
                'threatTypes': [
                  'MALWARE',
                  'SOCIAL_ENGINEERING',
                  'UNWANTED_SOFTWARE',
                  'POTENTIALLY_HARMFUL_APPLICATION',
                  // Add 'THREAT_TYPE_UNSPECIFIED' if you want to check for unknown threat types as well
                ],
                'platformTypes': ['ANY_PLATFORM'],
                'threatEntryTypes': ['URL'],
                'threatEntries': [
                  {'url': url},
                ],
              },
            }),
          )
          .timeout(const Duration(seconds: 10)); // Implement a timeout

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        // If the response contains 'matches', it means threats are detected.
        return !responseJson.containsKey('matches');
      } else {
        // Handle non-200 responses
        throw Exception(
            'Safe Browsing API returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      // Handle network errors, like no internet connection
      print('Network error: $e');
      return false;
    } on FormatException catch (e) {
      // Handle JSON format errors
      print('JSON format error: $e');
      return false;
    } on Exception catch (e) {
      // Handle all other errors
      print('Unknown error: $e');
      return false;
    }
  }
}
