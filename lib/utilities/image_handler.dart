import 'package:bars/utilities/exports.dart';

// Utility class for handling image operations
class ImageHandler {
  static Future<void> handleImageFromGallery(
      BuildContext context, bool isLogo) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      final file = await PickCropImage.pickedMedia(cropImage: cropImage);
      if (file == null) return;

      _provider.setIsLoading(true);
      bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(
          context, file as File);

      if (isHarmful) {
        mySnackBarModeration(context,
            'Harmful content detected. Please choose a different image. Please review');
      } else {
        submitProfileImage(context, file, isLogo);
      }
    } catch (e) {
      mySnackBar(context,
          'An error occurred\nCheck your internet connection and try again.');
    } finally {
      _provider.setIsLoading(false);
    }
  }

  static Future<File> cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage ?? imageFile; // Return original if cropping fails
  }

  static ImageProvider<Object> displayProfileImage(
      String? profileImageUrl, File? profileImage) {
    if (profileImage == null) {
      if (profileImageUrl == null || profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_placeholder2.png');
      } else {
        return CachedNetworkImageProvider(profileImageUrl);
      }
    } else {
      return FileImage(profileImage);
    }
  }

  static Future<void> submitProfileImage(
    BuildContext context,
    File? profileImage,
    bool isLogo,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (!_provider.isLoading2) {
      _provider.setIsLoading2(true);

      try {
        String _profileImageUrl = '';

        if (isLogo) {
          if (profileImage == null) {
            _profileImageUrl = _provider.userStore!.storeLogomageUrl;
          } else {
            _profileImageUrl = await StorageService.uploadSotreLogo(
              _provider.user!.userId!,
              profileImage,
            );
          }
        } else {
          if (profileImage == null) {
            _profileImageUrl = _provider.user!.profileImageUrl!;
          } else {
            _profileImageUrl = await StorageService.uploadUserProfileImage(
              _provider.user!.userId!,
              profileImage,
            );
          }
        }

        String dynamicLink = '';
        //  await DatabaseService.myDynamicLink(
        //   _profileImageUrl,
        //   _provider.user!.userName!,
        //   _provider.user!.bio!,
        //   'https://www.barsopus.com/user_${_provider.currentUserId}',
        // );

        WriteBatch batch = FirebaseFirestore.instance.batch();
        // batch.update(
        //   usersAuthorRef.doc(_provider.user!.userId),
        //   {
        //     'storeLogomageUrl': _profileImageUrl,
        //   },
        // );

        isLogo
            ? batch.update(
                userProfessionalRef.doc(_provider.user!.userId),
                {
                  'storeLogomageUrl': _profileImageUrl,
                  // 'dynamicLink': dynamicLink,
                },
              )
            : batch.update(
                usersAuthorRef.doc(_provider.user!.userId),
                {
                  'profileImageUrl': _profileImageUrl,
                  // 'dynamicLink': dynamicLink,
                },
              );

        await batch.commit();
        // await isLogo
        //     ? HiveUtils.updateUserStore(
        //         context,
        //         _profileImageUrl,
        //         _provider.userStore!.storeType,
        //         _provider.userStore!.accountType!,
        //       )
        //     :
             HiveUtils.updateAuthorHive(
                context,
                _provider.user!.userName!,
                _profileImageUrl,
                dynamicLink,
                _provider.userStore!.storeType,
                _provider.userStore!.accountType!,
              );
        ;
        isLogo
            ? _provider.setLogoImage(profileImage)
            : _provider.setProfileImage(profileImage);
        _provider.setIsLoading2(false);
      } catch (e) {
        _showBottomSheetErrorMessage(
            context, 'Failed to change profile picture');
      } finally {
        _provider.setIsLoading2(false);
      }
    }
  }

  static void _showBottomSheetErrorMessage(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
