import 'package:bars/utilities/exports.dart';

class ImageSafetyHandler {
  // bool isEvent = false; // You can set this externally if needed
  Future<void> handleImage(BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.heavyImpact();

    try {
      final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
      if (file == null) return;

      _provider.setIsLoading2(true);
      // final isHarmful = await _checkForHarmfulContent(context, file as File);
      bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(
          context, file as File);

      if (isHarmful) {
        _provider.setIsLoading2(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Harmful content detected. Please choose a different image.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        _provider.setIsLoading2(false);
        // isEvent ?
        _provider.setEventImage(file);
        //  : _provider.setPostImage(file);
      }
    } catch (e) {
      _provider.setIsLoading2(false);
      mySnackBar(context, 'Image not selected');
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }
}



