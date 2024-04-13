import 'package:bars/utilities/exports.dart';

class CreateSelectImageWidget extends StatelessWidget {
  final bool isEditting;
  final String feature;
  final String selectImageInfo;
  final String featureInfo;
  final bool isEvent;
  final VoidCallback onPressed;

  const CreateSelectImageWidget(
      {super.key,
      required this.isEditting,
      required this.feature,
      required this.selectImageInfo,
      required this.featureInfo,
      required this.isEvent,
      required this.onPressed});

  // _handleImage(BuildContext context) async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   HapticFeedback.heavyImpact();

  //   final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
  //   if (file == null) return;
  //   isEvent
  //       ? _provider.setEventImage(file as File)
  //       : _provider.setPostImage(file as File);
  // }

  // _handleImage(BuildContext context) async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   HapticFeedback.heavyImpact();

  //   final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
  //   if (file == null) return;

  //   // After picking and cropping, check for harmful content before setting the image
  //   _provider.setIsLoading(true);
  //   final isHarmful = await _checkForHarmfulContent(context, file as File);
  //   if (isHarmful) {
  //     // If the image is harmful, show a Snackbar and do not set the image
  //     _provider.setIsLoading(false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             'Harmful content detected. Please choose a different image.'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   } else {
  //     _provider.setIsLoading(false);
  //     // If the image is not harmful, set it using the provider
  //     isEvent ? _provider.setEventImage(file) : _provider.setPostImage(file);
  //   }
  // }

  // Future<File> _cropImage(File imageFile) async {
  //   File? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: imageFile.path,
  //     aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
  //   );
  //   return croppedImage!;
  // }

  // Future<bool> _checkForHarmfulContent(BuildContext context, File image) async {
  //   // Replace with your actual API key
  //   VisionApiHelper visionHelper = VisionApiHelper();

  //   Map<String, dynamic>? analysisResult =
  //       await visionHelper.safeSearchDetect(image.path);
  //   if (analysisResult != null) {
  //     // Extract Safe Search detection results
  //     final safeSearch = analysisResult['responses'][0]['safeSearchAnnotation'];
  //     // Check if any of the detected attributes are possible or likely
  //     if (safeSearch['adult'] == 'LIKELY' ||
  //         safeSearch['adult'] == 'VERY_LIKELY' ||
  //         safeSearch['spoof'] == 'LIKELY' || // Checking for spoof content
  //         safeSearch['spoof'] == 'VERY_LIKELY' ||
  //         safeSearch['medical'] == 'LIKELY' || // Checking for medical content
  //         safeSearch['medical'] == 'VERY_LIKELY' ||
  //         safeSearch['violence'] == 'LIKELY' ||
  //         safeSearch['violence'] == 'VERY_LIKELY' ||
  //         safeSearch['racy'] == 'LIKELY' ||
  //         safeSearch['racy'] == 'VERY_LIKELY') {
  //       // If any content is detected as likely or very likely, consider the image harmful
  //       return true;
  //     }
  //   }
  //   // If the analysisResult is null or no harmful content detected, consider the image not harmful
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!_provider.isLoading)
          AvatarGlow(
            animate: true,
            showTwoGlows: true,
            shape: BoxShape.circle,
            glowColor: Colors.blue,
            endRadius: ResponsiveHelper.responsiveHeight(context, 100.0),
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 3000),
            child: Container(
                width: ResponsiveHelper.responsiveHeight(context, 100.0),
                height: ResponsiveHelper.responsiveHeight(context, 100.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    )),
                child: IconButton(
                  icon: Icon(
                    MdiIcons.image,
                    color: Colors.white,
                    size: ResponsiveHelper.responsiveHeight(context, 80.0),
                  ),
                  onPressed: () async {
                    ImageSafetyHandler imageSafetyHandler =
                        ImageSafetyHandler();
                    await   imageSafetyHandler.handleImage(
                      context,
                    );
                  },
                  
                )),
          ),
        _provider.isLoading
            ? Text(
                'Processing...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
                textAlign: TextAlign.center,
              )
            : GestureDetector(
                onTap: onPressed,
                child: ShakeTransition(
                  child: CreateInfoWidget(
                    isEditting: isEditting,
                    feature: feature,
                    featureInfo: featureInfo,
                    selectImageInfo: selectImageInfo,
                  ),
                ),
              )
      ],
    );
  }
}
