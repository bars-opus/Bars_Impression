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
                    await imageSafetyHandler.handleImage(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CreateInfoWidget(
                      isEditting: isEditting,
                      feature: feature,
                      featureInfo: featureInfo,
                      selectImageInfo: selectImageInfo,
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
