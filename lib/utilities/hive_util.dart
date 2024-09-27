import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class HiveUtils {
  // Method to update user location preferences and store information
  static Future<void> updateUserLocation(
    BuildContext context,
    String city,
    String country,
    String storeType,
  ) async {
    Box<UserSettingsLoadingPreferenceModel> locationPreferenceBox;
    Box<UserStoreModel> accountUserStoreBox;

    // Open or fetch the accountLocationPreference box
    if (Hive.isBoxOpen('accountLocationPreference')) {
      locationPreferenceBox = Hive.box<UserSettingsLoadingPreferenceModel>(
          'accountLocationPreference');
    } else {
      locationPreferenceBox =
          await Hive.openBox<UserSettingsLoadingPreferenceModel>(
              'accountLocationPreference');
    }

    // Open or fetch the accountUserStore box
    if (Hive.isBoxOpen('accountUserStore')) {
      accountUserStoreBox = Hive.box<UserStoreModel>('accountUserStore');
    } else {
      accountUserStoreBox =
          await Hive.openBox<UserStoreModel>('accountUserStore');
    }

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of UserSettingsLoadingPreferenceModel with the updated values
    var updatedLocationPreference = UserSettingsLoadingPreferenceModel(
      userId: _provider.userLocationPreference!.userId,
      city: city,
      country: country,
      currency: _provider.userLocationPreference!.currency,
      timestamp: _provider.userLocationPreference!.timestamp,
      subaccountId: _provider.userLocationPreference!.subaccountId,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId,
    );

    var updatedUserStore = UserStoreModel(
      userId: _provider.userStore!.userId,
      userName: _provider.userStore!.userName,
      storeLogomageUrl: _provider.userStore!.storeLogomageUrl,
      storeType: storeType,
      verified: _provider.userStore!.verified,
      terms: _provider.userStore!.terms,
      city: city,
      country: country,
      overview: _provider.userStore!.overview,
      noBooking: _provider.userStore!.noBooking,
      awards: _provider.userStore!.awards,
      contacts: _provider.userStore!.contacts,
      links: _provider.userStore!.links,
      priceTags: _provider.userStore!.priceTags,
      services: _provider.userStore!.services,
      professionalImageUrls: _provider.userStore!.professionalImageUrls,
      dynamicLink: _provider.userStore!.dynamicLink,
      randomId: _provider.userStore!.randomId,
      currency: _provider.userStore!.currency,
      transferRecepientId: _provider.userStore!.transferRecepientId,
    );

    // Update the boxes with new instances
    await accountUserStoreBox.put(updatedUserStore.userId, updatedUserStore);
    await locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  // Method to update author information
  static updateAuthorHive(BuildContext context, String name, String bio,
      String profileImageUrl, String link) {
    final accountAuthorBox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    var updatedAccountAuthor = AccountHolderAuthor(
      bio: bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: link,
      lastActiveDate: _provider.user!.lastActiveDate,
      storeType: _provider.user!.storeType,
      profileImageUrl: profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: name, // Update userName with the new name parameter
      verified: _provider.user!.verified,
      disableChat: _provider.user!.disableChat,
      isShop: _provider.user!.isShop,
    );

    accountAuthorBox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }
}
