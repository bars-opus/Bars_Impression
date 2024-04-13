import 'package:bars/utilities/exports.dart';


class HarmfulContentChecker {
  static Future<bool> checkForHarmfulContent(BuildContext context, File image) async {
    VisionApiHelper visionHelper = VisionApiHelper();

    Map<String, dynamic>? analysisResult = await visionHelper.safeSearchDetect(image.path);
    if (analysisResult != null) {
      final safeSearch = analysisResult['responses'][0]['safeSearchAnnotation'];
      if (
        // safeSearch['adult'] == 'LIKELY' ||
          safeSearch['adult'] == 'VERY_LIKELY' ||
          safeSearch['spoof'] == 'LIKELY' ||
          safeSearch['spoof'] == 'VERY_LIKELY' ||
          safeSearch['medical'] == 'LIKELY' ||
          safeSearch['medical'] == 'VERY_LIKELY' ||
          safeSearch['violence'] == 'LIKELY' ||
          safeSearch['violence'] == 'VERY_LIKELY' ||
          // safeSearch['racy'] == 'LIKELY' ||
          safeSearch['racy'] == 'VERY_LIKELY') {
        return true;
      }
    }
    return false;
  }
}
