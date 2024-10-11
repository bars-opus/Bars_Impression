import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class HiveUtils {
  // Method to update user location preferences and store information
  static Future<void> updateUserLocation(
    BuildContext context,
    String city,
    String country,
    String shopType,
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

    await locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  // static Future<void> updateUserStore(
  //   BuildContext context,
  //   String logoImageUrl,
  //   String shopType,
  //   String accountType,
  // ) async {
  //   Box<UserStoreModel> accountUserStoreBox;

  //   // Open or fetch the accountUserStore box
  //   if (Hive.isBoxOpen('accountUserStore')) {
  //     accountUserStoreBox = Hive.box<UserStoreModel>('accountUserStore');
  //   } else {
  //     accountUserStoreBox =
  //         await Hive.openBox<UserStoreModel>('accountUserStore');
  //   }

  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   var updatedUserStore = UserStoreModel(
  //     userId: _provider.userStore!.userId,
  //     accountType: accountType,
  //     userName: _provider.userStore!.userName,
  //     shopLogomageUrl: logoImageUrl,
  //     shopType: shopType,
  //     verified: _provider.userStore!.verified,
  //     terms: _provider.userStore!.terms,
  //     city: _provider.userStore!.city,
  //     country: _provider.userStore!.country,
  //     overview: _provider.userStore!.overview,
  //     noBooking: _provider.userStore!.noBooking,
  //     awards: _provider.userStore!.awards,
  //     contacts: _provider.userStore!.contacts,
  //     links: _provider.userStore!.links,
  //     // priceTags: _provider.userStore!.priceTags,
  //     services: _provider.userStore!.services,
  //     professionalImageUrls: _provider.userStore!.professionalImageUrls,
  //     dynamicLink: _provider.userStore!.dynamicLink,
  //     randomId: _provider.userStore!.randomId,
  //     currency: _provider.userStore!.currency,
  //     transferRecepientId: _provider.userStore!.transferRecepientId,
  //     currentVisitors: _provider.userStore!.currentVisitors ?? 0,
  //     maxCapacity: _provider.userStore!.maxCapacity ?? 0,
  //     amenities: _provider.userStore!.amenities,
  //     averageRating: _provider.userStore!.averageRating ?? 0,
  //     openingHours: _provider.userStore!.openingHours,
  //     appointmentSlots: _provider.userStore!.appointmentSlots,
  //   );

  //   // Update the boxes with new instances
  //   await accountUserStoreBox.put(updatedUserStore.userId, updatedUserStore);
  // }

  // Method to update author information
  static updateAuthorHive( {
    required BuildContext context,
    required String name,
    required String profileImageUrl,
    required String link,
    required String shopType,
    required String accountType,
    required bool disabledAccount,
    required bool reportConfirmed,
    required bool verified,
    required bool disableChat,
    // required Timestamp lastActiveDate,
  }) {
    final accountAuthorBox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    var updatedAccountAuthor = AccountHolderAuthor(
      // bio: bio,
      accountType: accountType,
      disabledAccount: disabledAccount,
      dynamicLink: link,
      lastActiveDate: Timestamp.fromDate(DateTime.now()),
      shopType: shopType,
      profileImageUrl: profileImageUrl,
      reportConfirmed: reportConfirmed,
      userId: _provider.currentUserId,
      userName: name, // Update userName with the new name parameter
      verified: verified,
      disableChat: disableChat,
      // isShop: _provider.user!.isShop,
    );

    _provider.setUser(updatedAccountAuthor);
    accountAuthorBox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }
}
