import 'package:bars/utilities/exports.dart';

class ImageSafetyHandler {
  // bool isEvent = false; // You can set this externally if needed

  Future<void> handleImage(BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.heavyImpact();

    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    _provider.setIsLoading(true);
    // final isHarmful = await _checkForHarmfulContent(context, file as File);
      bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(context, file as File);

    if (isHarmful) {
      _provider.setIsLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Harmful content detected. Please choose a different image.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      _provider.setIsLoading(false);
      // isEvent ?
      _provider.setEventImage(file);
      //  : _provider.setPostImage(file);
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

  // Future<bool> _checkForHarmfulContent(BuildContext context, File image) async {
  //   VisionApiHelper visionHelper = VisionApiHelper();

  //   Map<String, dynamic>? analysisResult =
  //       await visionHelper.safeSearchDetect(image.path);
  //   if (analysisResult != null) {
  //     final safeSearch = analysisResult['responses'][0]['safeSearchAnnotation'];
  //     if (safeSearch['adult'] == 'LIKELY' ||
  //         safeSearch['adult'] == 'VERY_LIKELY' ||
  //         safeSearch['spoof'] == 'LIKELY' ||
  //         safeSearch['spoof'] == 'VERY_LIKELY' ||
  //         safeSearch['medical'] == 'LIKELY' ||
  //         safeSearch['medical'] == 'VERY_LIKELY' ||
  //         safeSearch['violence'] == 'LIKELY' ||
  //         safeSearch['violence'] == 'VERY_LIKELY' ||
  //         safeSearch['racy'] == 'LIKELY' ||
  //         safeSearch['racy'] == 'VERY_LIKELY') {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
}
