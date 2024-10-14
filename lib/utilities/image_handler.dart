import 'package:bars/utilities/exports.dart';

// Utility class for handling image operations
class ImageHandler {
  static Future<void> handleImageFromGallery(
    BuildContext context,
    bool isLogo,
    // UserData provider,
    // UserStoreModel? shop,
  ) async {
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
        submitProfileImage(
          context,
          file,
          isLogo,
        );
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
    // UserData provider,
    // UserStoreModel? shop,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (!_provider.isLoading2) {
      _provider.setIsLoading2(true);

      try {
        String _profileImageUrl = '';

        if (isLogo) {
          if (profileImage == null) {
            _profileImageUrl = _provider.userStore!.shopLogomageUrl;
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
        //     'shopLogomageUrl': _profileImageUrl,
        //   },
        // );

        isLogo
            ? batch.update(
                userProfessionalRef.doc(_provider.user!.userId),
                {
                  'shopLogomageUrl': _profileImageUrl,
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
        //         _provider.userStore!.shopType,
        //         _provider.userStore!.accountType!,
        //       )
        //     :

        if (!isLogo)
          HiveUtils.updateAuthorHive(
            context: context,
            name: _provider.user!.userName!,
            profileImageUrl: _profileImageUrl,
            link: dynamicLink,
            shopType: _provider.user!.shopType!,
            accountType: _provider.user!.accountType!,
            disabledAccount: _provider.user!.disabledAccount!,
            reportConfirmed: _provider.user!.reportConfirmed!,
            verified: _provider.user!.verified!,
            disableChat: _provider.user!.disableChat!,
            // lastActiveDate: _provider.user!.lastActiveDate!,
            // context,
            // _provider.user!.userName!,
            // _profileImageUrl,
            // dynamicLink,
            // _provider.userStore!.shopType,
            // _provider.userStore!.accountType!,
          );
        isLogo
            ? _provider.setLogoImage(profileImage)
            : _provider.setProfileImage(profileImage);
        isLogo
            ? _provider.setLogoImageUrl(_profileImageUrl)
            : _provider.setProfileImageUrl(_profileImageUrl);

        _provider.setIsLoading2(false);
      } catch (e) {
        _showBottomSheetErrorMessage(
            context, 'Failed to change profile picture');
      } finally {
        _provider.setIsLoading2(false);
      }
    }
  }

  // static void setProviderStore(
  //   UserData provider,
  //   UserStoreModel shop,
  // ) {
  //   UserStoreModel _userStore = UserStoreModel(
  //     userId: provider.user!.userId!,
  //     shopName: provider.name,
  //     shopLogomageUrl: '',
  //     shopType: provider.shopType,
  //     verified: provider.user!.verified!,
  //     terms: provider.termAndConditions,
  //     city: provider.city,
  //     country: provider.country,
  //     overview: provider.overview,
  //     accountType: provider.accountType,
  //     noBooking: provider.noBooking,
  //     awards: provider.awards,
  //     contacts: provider.bookingContacts,
  //     links: provider.linksToWork,
  //     // priceTags: provider.priceRate,
  //     services: provider.services,
  //     professionalImageUrls: provider.professionalImages,
  //     dynamicLink: provider.user!.dynamicLink!,
  //     randomId: shop.randomId,
  //     currency: provider.currency,
  //     transferRecepientId: shop.transferRecepientId,
  //     maxCapacity: shop.maxCapacity ?? 0,
  //     amenities: shop.amenities,
  //     averageRating: shop.averageRating ?? 0,
  //     openingHours: provider.openingHours,
  //     appointmentSlots: provider.appointmentSlots,
  //     address: provider.address,
  //   );

  //   // UserStoreModel updatedUser = UserStoreModel.fromJson(_userStore);
  //   provider.setUserStore(_userStore);
  // }

  static void _showBottomSheetErrorMessage(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
