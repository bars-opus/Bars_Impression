import 'dart:math';

import 'package:bars/general/pages/chats/chats.dart';

import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'Home_screen';
  final Key? key;

  const HomeScreen({this.key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final int _updateAppVersion = Platform.isIOS ? 17 : 17;
  String notificationMsg = '';

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setUpactivityCount();
    });
    _configureNotification();
    initDynamicLinks();
    // _createFields();

    // initializeData();

    // _createFields();

    // _updateFields();
    // _createFields();
    // _newUserProfessionalData();
    // _newUserProfessional();
    // _newUserAuthorSettings();
    // _newUserAuthorLocation();
    // _newUserAuthor();
  }

  // Future<void> initializeData() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference sourceRef =
  //       _firestore.collection('user_general_settings');
  //   CollectionReference targetRef = _firestore.collection('new_followers');

  //   // Get documents from the source collection
  //   QuerySnapshot sourceSnapshot = await sourceRef.get();

  //   // Initialize a Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var sourceDoc in sourceSnapshot.docs) {
  //     // Assuming you want to use the source document ID
  //     String userId = sourceDoc.id;

  //     // Create a new reference in the target collection and its subcollection
  //     DocumentReference newTargetDocRef =
  //         targetRef.doc(userId).collection('userFollowers').doc(userId);

  //     // Write the source data to the new target document
  //     batch.set(
  //         newTargetDocRef,
  //         {
  //           'userId': userId,
  //         },
  //         SetOptions(merge: true));
  //   }

  //   // Commit the batch
  //   await batch.commit();
  // }
  // // _newUserAuthorSettings() async {
  // //   final _firestore = FirebaseFirestore.instance;
  // //   CollectionReference sourceRef =
  //       _firestore.collection('user_general_settings');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await sourceRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection('_new_user_general_settings') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }
  //     var disableChat = targetDoc.get('disableChat');
  //     var privateAccount = targetDoc.get('privateAccount');
  //     var disableAdvice = targetDoc.get('disableAdvice');
  //     var hideAdvice = targetDoc.get('hideAdvice');
  //     var disableBooking = targetDoc.get('disableBooking');
  //     var disabledAccount = targetDoc.get('disabledAccount');
  //     var isEmailVerified = targetDoc.get('isEmailVerified');
  //     var disableEventSuggestionNotification =
  //         targetDoc.get('disableEventSuggestionNotification');
  //     var muteEventSuggestionNotification =
  //         targetDoc.get('muteEventSuggestionNotification');
  //     var androidNotificationToken = targetDoc.get('androidNotificationToken');
  //     var preferredEventTypes = targetDoc.get('preferredEventTypes');
  //     var preferredCreatives = targetDoc.get('preferredCreatives');
  //     var disableNewCreativeNotifications =
  //         targetDoc.get('disableNewCreativeNotifications');
  //     var disableWorkVacancyNotifications =
  //         targetDoc.get('disableWorkVacancyNotifications');
  //     var muteWorkVacancyNotifications =
  //         targetDoc.get('muteWorkVacancyNotifications');
  //     var report = targetDoc.get('report');
  //     var reportConfirmed = targetDoc.get('reportConfirmed');
  //     // var country = targetDoc.get('country');
  //     // var currency = targetDoc.get('currency');
  //     // var timestamp = targetDoc.get('timestamp');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //         'disableChat': disableChat,
  //         'privateAccount': privateAccount,
  //         'disableAdvice': disableAdvice,
  //         'hideAdvice': hideAdvice,
  //         'disableBooking': disableBooking,
  //         'disabledAccount': disabledAccount,
  //         'isEmailVerified': isEmailVerified,
  //         'disableEventSuggestionNotification':
  //             disableEventSuggestionNotification,
  //         'muteEventSuggestionNotification': muteEventSuggestionNotification,
  //         'androidNotificationToken': androidNotificationToken,
  //         'preferredEventTypes': preferredEventTypes,
  //         'preferredCreatives': preferredCreatives,
  //         'disableNewCreativeNotifications': disableNewCreativeNotifications,
  //         'disableWorkVacancyNotifications': disableWorkVacancyNotifications,
  //         'muteWorkVacancyNotifications': muteWorkVacancyNotifications,
  //         'report': report,
  //         'reportConfirmed': reportConfirmed,
  //         // 'country': country,
  //         // 'currency': currency,
  //         // 'timestamp': timestamp,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  _updateFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_location_settings');

    // Start a new batch
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        // Check if "subaccount_id" field exists
        if (data.containsKey('subaccount_id')) {
          // Get the value of "subaccount_id"
          String? subaccountId = data['subaccount_id'];

          // Remove the old "subaccount_id" field
          data.remove('subaccount_id');

          // Set the new "subaccountId" field with the value
          data['subaccountId'] = subaccountId;

          // Add the updated data to the batch
          batch.set(doc.reference, data);
        }
      }
    });

    // Commit the batch
    await batch.commit();
  }

  _createFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_location_settings');

    // Start a new batch
    WriteBatch batch = firestore.batch();
    // final Random random = Random();

    // print(' dd  ' + random.nextDouble().toString());

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        // Check if "subaccount_id" field exists
        if (!data.containsKey('transferRecepientId')) {
          // Create the "subaccount_id" field without overwriting existing fields
          data['transferRecepientId'] = '';
          batch.set(doc.reference, data);
        }
      }
    });

    // Commit the batch
    await batch.commit();
  }

  // _newUserSearch() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_author');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.get('userName');
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection('_new_user_search') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }

  //     var name = targetDoc.get('name');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserProfessionalData() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection(
  //             '_new_user_professsional_data') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }
  //     var userName = targetDoc.get('userName');
  //     var profileImageUrl = targetDoc.get('profileImageUrl');
  //     var verified = targetDoc.get('verified');
  //     String profileHandle = targetDoc.get('profileHandle');
  //     var dynamicLink = targetDoc.get('dynamicLink');
  //     var terms = targetDoc.get('terms');
  //     var overview = targetDoc.get('overview');
  //     var noBooking = targetDoc.get('noBooking');
  //     String city = targetDoc.get('city');
  //     String country = targetDoc.get('country');
  //     String continent = targetDoc.get('continent');

  //     var company = targetDoc.get('company');
  //     var collaborations = targetDoc.get('collaborations');
  //     var performances = targetDoc.get('performances');
  //     var contacts = targetDoc.get('contacts');
  //     var awards = targetDoc.get('awards');
  //     var skills = targetDoc.get('skills');
  //     var links = targetDoc.get('links');
  //     var genreTags = targetDoc.get('genreTags');
  //     var professionalImageUrls = targetDoc.get('professionalImageUrls');
  //     var subAccountType = targetDoc.get('subAccountType');
  //     var priceTags = targetDoc.get('priceTags');
  //     // var country = targetDoc.get('country');
  //     // var currency = targetDoc.get('currency');
  //     // var timestamp = targetDoc.get('timestamp');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'id': id,
  //         'userName': userName,
  //         'profileImageUrl': profileImageUrl,
  //         'verified': verified,
  //         'profileHandle': profileHandle,
  //         'dynamicLink': dynamicLink,
  //         'terms': terms,
  //         'overview': overview,
  //         'noBooking': noBooking,
  //         'city': city,
  //         'country': country,
  //         'continent': continent,
  //         'company': company,
  //         'collaborations': collaborations,
  //         'performances': performances,
  //         'contacts': contacts,
  //         'awards': awards,
  //         'skills': skills,
  //         'links': links,
  //         'genreTags': genreTags,
  //         'professionalImageUrls': professionalImageUrls,
  //         'subAccountType': subAccountType,
  //         'priceTags': priceTags,
  //         'report': '',
  //         'reportConfirmed': false,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserProfessional() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and idName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection('_new_user_professsional') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }

  //     var userName = targetDoc.get('userName');
  //     var profileImageUrl = targetDoc.get('profileImageUrl');
  //     var verified = targetDoc.get('verified');
  //     String profileHandle = targetDoc.get('profileHandle');
  //     var dynamicLink = targetDoc.get('dynamicLink');
  //     var terms = targetDoc.get('terms');
  //     var overview = targetDoc.get('overview');
  //     var noBooking = targetDoc.get('noBooking');
  //     String city = targetDoc.get('city');
  //     String country = targetDoc.get('country');
  //     String continent = targetDoc.get('continent');

  //     var company = targetDoc.get('company');
  //     var collaborations = targetDoc.get('collaborations');
  //     var performances = targetDoc.get('performances');
  //     var contacts = targetDoc.get('contacts');
  //     var awards = targetDoc.get('awards');
  //     var skills = targetDoc.get('skills');
  //     var links = targetDoc.get('links');
  //     var genreTags = targetDoc.get('genreTags');
  //     var professionalImageUrls = targetDoc.get('professionalImageUrls');
  //     var subAccountType = targetDoc.get('subAccountType');
  //     var priceTags = targetDoc.get('priceTags');

  //     if (!userAuthorDoc.exists &&
  //         city.isNotEmpty &&
  //         country.isNotEmpty &&
  //         continent.isNotEmpty) {
  //       WriteBatch cityBatch = FirebaseFirestore.instance.batch();

  //       // Add the users to the nested collections based on type, continent, country, and city
  //       WriteBatch typeBatch = FirebaseFirestore.instance.batch();
  //       WriteBatch countryBatch = FirebaseFirestore.instance.batch();
  //       WriteBatch continentBatch = FirebaseFirestore.instance.batch();

  //       DocumentReference usersByTypeRef =
  //           userProfessionalRef.doc(profileHandle.toUpperCase());

  //       DocumentReference usersByContinentRef =
  //           usersByTypeRef.collection('usersByContinent').doc(continent);

  //       DocumentReference usersByCountryRef =
  //           usersByContinentRef.collection('usersByCountry').doc(country);

  //       DocumentReference usersByCityRef = usersByCountryRef
  //           .collection('usersByCity')
  //           .doc(city)
  //           .collection('users')
  //           .doc(id);

  //       // final bucket = userName[0].toUpperCase();
  //       final bucketId = id[0];

  //       // DocumentReference usersSearchRef =
  //       //     eventsSearchRef.doc(bucket).collection('bucketEvents').doc();

  //       Map<String, dynamic> userData = {
  //         'userId': id,
  //       };

  //       Map<String, dynamic> eventData2 = {
  //         'id': id,
  //         'userName': userName,
  //         'profileImageUrl': profileImageUrl,
  //         'verified': verified,
  //         'profileHandle': profileHandle,
  //         'dynamicLink': dynamicLink,
  //         'terms': terms,
  //         'overview': overview,
  //         'noBooking': noBooking,
  //         'city': city,
  //         'country': country,
  //         'continent': continent,
  //         'company': company,
  //         'collaborations': collaborations,
  //         'performances': performances,
  //         'contacts': contacts,
  //         'awards': awards,
  //         'skills': skills,
  //         'links': links,
  //         'genreTags': genreTags,
  //         'professionalImageUrls': professionalImageUrls,
  //         'subAccountType': subAccountType,
  //         'priceTags': priceTags,
  //         'report': '',
  //         'reportConfirmed': false,
  //       };

  //       // Map<String, dynamic> eventSearchData = {
  //       //   'userId': id,
  //       // };

  //       cityBatch.set(usersByCityRef, userData);

  //       typeBatch.set(usersByTypeRef.collection('users').doc(id), userData);

  //       continentBatch.set(
  //           usersByContinentRef.collection('users').doc(id), userData);

  //       countryBatch.set(
  //           usersByCountryRef.collection('users').doc(id), userData);

  //       // Prepare the batch for updating the eventsByMonthRef document
  //       // WriteBatch monthBatch = FirebaseFirestore.instance.batch();

  //       // WriteBatch userSearchBatch = FirebaseFirestore.instance.batch();

  //       // DocumentReference usersByStartIdRef = newuserProfessionalRef
  //       //     .doc(bucketId)
  //       //     .collection('bucketUserIds')
  //       //     .doc(id);

  //       // monthBatch.set(usersByStartIdRef, eventData2, SetOptions(merge: true));

  //       // userSearchBatch.set(usersSearchRef, eventSearchData);

  //       List<WriteBatch> batches = [
  //         cityBatch,
  //         typeBatch,
  //         countryBatch,
  //         continentBatch,
  //         // typeBatch,
  //         // monthBatch,
  //         // userSearchBatch,
  //       ];

  //       // Commit all batches
  //       List<Future> batchFutures =
  //           batches.map((batch) => batch.commit()).toList();
  //       await Future.wait(batchFutures);

  //       // Re-initialize your batches
  //       // cityBatch = FirebaseFirestore.instance.batch();
  //       // typeBatch = FirebaseFirestore.instance.batch();
  //       // countryBatch = FirebaseFirestore.instance.batch();
  //       // continentBatch = FirebaseFirestore.instance.batch();
  //       // monthBatch = FirebaseFirestore.instance.batch();
  //       // userSearchBatch = FirebaseFirestore.instance.batch();

  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       // if (batchSize == 500) {
  //       //   try {
  //       //     await batch.commit();
  //       //     print("Committed a batch");
  //       //   } catch (e) {
  //       //     print("Error committing batch: $e");
  //       //     return;
  //       //   }

  //       //   batchSize = 0;
  //       //   batch = _firestore.batch();
  //       // }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserAuthorSettings() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef =
  //       _firestore.collection('user_general_settings');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection('_new_user_general_settings') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }
  //     var disableChat = targetDoc.get('disableChat');
  //     var privateAccount = targetDoc.get('privateAccount');
  //     var disableAdvice = targetDoc.get('disableAdvice');
  //     var hideAdvice = targetDoc.get('hideAdvice');
  //     var disableBooking = targetDoc.get('disableBooking');
  //     var disabledAccount = targetDoc.get('disabledAccount');
  //     var isEmailVerified = targetDoc.get('isEmailVerified');
  //     var disableEventSuggestionNotification =
  //         targetDoc.get('disableEventSuggestionNotification');
  //     var muteEventSuggestionNotification =
  //         targetDoc.get('muteEventSuggestionNotification');
  //     var androidNotificationToken = targetDoc.get('androidNotificationToken');
  //     var preferredEventTypes = targetDoc.get('preferredEventTypes');
  //     var preferredCreatives = targetDoc.get('preferredCreatives');
  //     var disableNewCreativeNotifications =
  //         targetDoc.get('disableNewCreativeNotifications');
  //     var disableWorkVacancyNotifications =
  //         targetDoc.get('disableWorkVacancyNotifications');
  //     var muteWorkVacancyNotifications =
  //         targetDoc.get('muteWorkVacancyNotifications');
  //     var report = targetDoc.get('report');
  //     var reportConfirmed = targetDoc.get('reportConfirmed');
  //     // var country = targetDoc.get('country');
  //     // var currency = targetDoc.get('currency');
  //     // var timestamp = targetDoc.get('timestamp');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //         'disableChat': disableChat,
  //         'privateAccount': privateAccount,
  //         'disableAdvice': disableAdvice,
  //         'hideAdvice': hideAdvice,
  //         'disableBooking': disableBooking,
  //         'disabledAccount': disabledAccount,
  //         'isEmailVerified': isEmailVerified,
  //         'disableEventSuggestionNotification':
  //             disableEventSuggestionNotification,
  //         'muteEventSuggestionNotification': muteEventSuggestionNotification,
  //         'androidNotificationToken': androidNotificationToken,
  //         'preferredEventTypes': preferredEventTypes,
  //         'preferredCreatives': preferredCreatives,
  //         'disableNewCreativeNotifications': disableNewCreativeNotifications,
  //         'disableWorkVacancyNotifications': disableWorkVacancyNotifications,
  //         'muteWorkVacancyNotifications': muteWorkVacancyNotifications,
  //         'report': report,
  //         'reportConfirmed': reportConfirmed,
  //         // 'country': country,
  //         // 'currency': currency,
  //         // 'timestamp': timestamp,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserAuthorLocation() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef =
  //       _firestore.collection('user_location_settings');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection(
  //             '_new_user_location_settings') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }
  //     var city = targetDoc.get('city');
  //     var continent = targetDoc.get('continent');
  //     var country = targetDoc.get('country');
  //     var currency = targetDoc.get('currency');
  //     var timestamp = targetDoc.get('timestamp');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //         'city': city,
  //         'continent': continent,
  //         'country': country,
  //         'currency': currency,
  //         'timestamp': timestamp,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserAuthor() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_author');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     // var userName = targetDoc.get('userId');

  //     final bucket = id[0];

  //     // Log the current document
  //     print("Processing document with id $id and userName $bucket");

  //     // Check if the document already exists in the user_author collection
  //     CollectionReference userAuthorRef = _firestore
  //         .collection('_new_user_author') // Corrected collection name
  //         .doc(bucket)
  //         .collection('bucketUserIds');

  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef
  //           .doc(id)
  //           .get(); // Removed bucket from doc reference
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }
  //     var userName = targetDoc.get('userName');
  //     var profileImageUrl = targetDoc.get('profileImageUrl');

  //     var bio = targetDoc.get('bio');

  //     var profileHandle = targetDoc.get('profileHandle');
  //     var dynamicLink = targetDoc.get('dynamicLink');
  //     var verified = targetDoc.get('verified');
  //     var disabledAccount = targetDoc.get('disabledAccount');
  //     var reportConfirmed = targetDoc.get('reportConfirmed');
  //     var lastActiveDate = targetDoc.get('lastActiveDate');

  //     var name = targetDoc.get('name');

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef =
  //           userAuthorRef.doc(id); // Used id instead of bucket
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //         'userName': userName,
  //         'profileImageUrl': profileImageUrl,
  //         'bio': bio,
  //         'profileHandle': profileHandle,
  //         'dynamicLink': dynamicLink,
  //         'verified': verified,
  //         'disabledAccount': disabledAccount,
  //         'reportConfirmed': reportConfirmed,
  //         'name': name,
  //         'lastActiveDate': lastActiveDate,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _newUserSearchNames() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_author');
  //   CollectionReference userAuthorRef = _firestore.collection('usernames');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot;
  //   try {
  //     targetSnapshot = await targetRef.get();
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     return;
  //   }

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     var userName = targetDoc.get('userName');

  //     // Log the current document
  //     print("Processing document with id $id and userName $userName");

  //     // Check if the document already exists in the user_author collection
  //     DocumentSnapshot userAuthorDoc;
  //     try {
  //       userAuthorDoc = await userAuthorRef.doc(userName).get();
  //     } catch (e) {
  //       print("Error fetching document: $e");
  //       return;
  //     }

  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef = userAuthorRef.doc(userName);
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         try {
  //           await batch.commit();
  //           print("Committed a batch");
  //         } catch (e) {
  //           print("Error committing batch: $e");
  //           return;
  //         }

  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  //   // Commit any remaining operations
  //   if (batchSize > 0) {
  //     try {
  //       await batch.commit();
  //       print("Committed final batch");
  //     } catch (e) {
  //       print("Error committing final batch: $e");
  //     }
  //   }
  // }

  // _createFields() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference userProfessionalCollection =
  //       firestore.collection('user_general_settings');

  //   // Start a new batch
  //   WriteBatch batch = firestore.batch();

  //   QuerySnapshot querySnapshot = await userProfessionalCollection.get();
  //   querySnapshot.docs.forEach((doc) {
  //     Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

  //     // Only proceed if data is not null
  //     if (data != null) {
  //       // Check if "report" field exists
  //       if (data.containsKey('lastActiveDate')) {
  //         // Remove the "lastActiveDate" field
  //         batch.update(doc.reference, {'lastActiveDate': FieldValue.delete()});
  //       }
  //     }
  //   });

  //   // Commit the batch
  //   await batch.commit();
  // }

  // // // _newGeneralSettings() async {
  // //   final _firestore = FirebaseFirestore.instance;
  // //   CollectionReference targetRef = _firestore.collection('user_professsional');
  // //   WriteBatch batch = _firestore.batch();

  // //   // Get documents from target collection
  // //   QuerySnapshot targetSnapshot = await targetRef.get();

  // //   for (var targetDoc in targetSnapshot.docs) {
  // //     var id = targetDoc.id;
  // //     // var userName = targetDoc.get('userName');

  // //     // Create a new document reference in the user_author collection with the document ID as userId
  // //     DocumentReference userAuthorDocRef =
  // //         _firestore.collection('user_general_settings').doc(id);

  // //     // Add the set operation to the batch
  // //     batch.set(userAuthorDocRef, {
  // //       'userId': id,
  // //       'disableChat': false,
  // //       'privateAccount': false,
  // //       'disableAdvice': false,
  // //       'hideAdvice': false,
  // //       'disableBooking': false,
  // //       'disabledAccount': false,
  // //       'isEmailVerified': false,
  // //       'disableEventSuggestionNotification': false,
  // //       'muteEventSuggestionNotification': false,
  // //       'disableNewCreativeNotifications': false,
  // //       'disableWorkVacancyNotifications': false,
  // //       'muteWorkVacancyNotifications': false,
  // //       'report': false,
  // //       'reportConfirmed': false,
  // //       'preferredEventTypes': [],
  // //       'preferredCreatives': [],
  // //     });
  // //   }

  // //   // Commit the batch to create all the documents in the user_author collection
  // //   await batch.commit();
  // // }

//   _deleAFileds() async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     CollectionReference userProfessionalCollection =
//         firestore.collection('user_professsional');

// // Start a new batch
//     WriteBatch batch = firestore.batch();

//     await userProfessionalCollection.get().then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

//         // Only proceed if data is not null
//         if (data != null) {
//           // Check if "Skills" and "Terms" fields exist, if so, mark them for deletion
//           if (data.containsKey('Skills')) {
//             batch.update(doc.reference, {'Skills': FieldValue.delete()});
//           }

//         }
//       });
//     });

// // Commit the batch
//     await batch.commit();
//   }

  // _newLocationPreference() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef =
  //       _firestore.collection('user_general_settings');
  //   WriteBatch batch = _firestore.batch();

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;

  //     // Retrieve the lastActiveDate field from the target document
  //     var lastActiveDate = targetDoc.get('lastActiveDate');

  //     // Create a document reference in the user_author collection with the document ID as userId
  //     DocumentReference userAuthorDocRef =
  //         _firestore.collection('user_author').doc(id);

  //     // Add the set operation to the batch
  //     batch.set(
  //         userAuthorDocRef,
  //         {
  //           'lastActiveDate': lastActiveDate,
  //         },
  //         SetOptions(
  //             merge:
  //                 true)); // Use SetOptions with merge: true to retain existing fields in the document

  //     // Commit the batch after each iteration to update individual documents
  //     await batch.commit();

  //     // Clear the batch for the next iteration
  //     batch = _firestore.batch();
  //   }
  // }

  // _newsomeFields() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_search_names');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         // Create a new map with the desired fields to be copied
  //         var someFields = {
  //           'name': data.containsKey('name') ? data['name'] : '',
  //           'bio': data.containsKey('bio') ? data['bio'] : '',
  //         };

  //         // Write the new map to the target document
  //         batch.set(targetDoc.reference, someFields, SetOptions(merge: true));
  //       } else {
  //         print('No data for document ${sourceDoc.id}');
  //       }
  //     } else {
  //       print('No document with ID ${targetDoc.id} in source collection');
  //     }
  //   }

  //   await batch.commit();
  // }

  // _new() async {
  //   // try {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef =
  //       _firestore.collection('user_location_settings');
  //   CollectionReference sourceRef =
  //       _firestore.collection('user_general_settings');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         // print('Data for document ${sourceDoc.id}: $data'); // ADD THIS LINE

  //         var someFields = {
  //           'timestamp': data.containsKey('timestamp')
  //               ? data['timestamp']
  //               : Timestamp.fromDate(DateTime.now()),
  //           // 'bio': data.containsKey('bio') ? data['bio'] : null,
  //           // 'country': data.containsKey('country') ? data['country'] : null,
  //           // 'verified': false,
  //         };

  //         print('Fields to be copied: $someFields'); // ADD THIS LINE

  //         // Write the new map to the target document
  //         batch.set(targetDoc.reference, someFields, SetOptions(merge: true));
  //       } else {
  //         print('No data for document ${sourceDoc.id}'); // ADD THIS LINE
  //       }
  //     } else {
  //       print(
  //           'No document with ID ${targetDoc.id} in source collection'); // ADD THIS LINE
  //     }
  //   }

  //   await batch.commit();
  // }

  // _newAuthor() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference userAuthorRef = _firestore.collection('user_search_names');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   WriteBatch batch = _firestore.batch();
  //   int batchSize = 0;

  //   for (var targetDoc in targetSnapshot.docs) {
  //     var id = targetDoc.id;
  //     var userName = targetDoc.get('userName');
  //     // var profileImageUrl = targetDoc.get('profileImageUrl');
  //     // var profileHandle = targetDoc.get('profileHandle');
  //     // var verified = targetDoc.get('verified');
  //     // var dynamicLink = targetDoc.get('dynamicLink');

  //     // Check if the document already exists in the user_author collection
  //     DocumentSnapshot userAuthorDoc = await userAuthorRef.doc(id).get();
  //     if (!userAuthorDoc.exists) {
  //       var userAuthorDocRef = userAuthorRef.doc(userName);
  //       batch.set(userAuthorDocRef, {
  //         'userId': id,
  //         // 'userName': userName,
  //         // 'profileImageUrl': profileImageUrl,
  //         // 'profileHandle': profileHandle,
  //         // 'verified': verified,
  //         // 'dynamicLink': dynamicLink,
  //       });
  //       batchSize++;

  //       // Commit the batch after a certain number of operations
  //       if (batchSize == 500) {
  //         await batch.commit();
  //         batchSize = 0;
  //         batch = _firestore.batch();
  //       }
  //     }
  //   }

  // Commit the remaining batch operations
  //   if (batchSize > 0) {
  //     await batch.commit();
  //   }
  // }

//

  // _newImageUrls() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     List<dynamic>? professionalImageUrls =
  //         targetDoc.get('professionalImageUrls');

  //     // Check if professionalImageUrls is a list containing empty string elements
  //     if (professionalImageUrls is List<dynamic> &&
  //         professionalImageUrls.every((element) => element == "")) {
  //       // Update professionalImageUrls to an empty list
  //       batch.update(targetDoc.reference, {'professionalImageUrls': []});
  //     }
  //   }

  //   await batch.commit();
  // }

  // _newLink() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       // Create dynamic link
  //       String dynamicLink = await _createDynamicLink(sourceDoc);

  //       // Write the dynamic link to the target document
  //       batch.set(targetDoc.reference, {'dynamicLink': dynamicLink},
  //           SetOptions(merge: true));
  //     } else {
  //       print('No document with ID ${targetDoc.id} in source collection');
  //     }
  //   }

  //   await batch.commit();
  // }

  // Future<String> _createDynamicLink(DocumentSnapshot sourceDoc) async {
  //   String profileImageUrl = sourceDoc.get('profileImageUrl');
  //   String userName = sourceDoc.get('userName');
  //   String bio = sourceDoc.get('bio');
  //   String userId = sourceDoc.id;

  // String link = await DatabaseService.myDynamicLink(
  //   profileImageUrl,
  //   userName,
  //   bio,
  //   'https://www.barsopus.com/user_$userId',
  // );

  //   return link;
  // }

  // _brutal() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         var professionalPicture1 = data['professionalPicture1'];
  //         var profileHandle = data['profileHandle'];

  //         // Check conditions
  //         if (professionalPicture1.isEmpty && profileHandle != 'Fan') {
  //           // Delete the document from the target collection
  //           batch.delete(targetDoc.reference);
  //           print('Deleted document ${targetDoc.id}');
  //         }
  //       } else {
  //         print('No data for document ${sourceDoc.id}');
  //       }
  //     } else {
  //       print('No document with ID ${targetDoc.id} in source collection');
  //     }
  //   }

  //   await batch.commit();
  // }

  // _deleteOldDocuments() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professional');

  //   // Calculate the date 3 months ago
  //   var threeMonthsAgo = DateTime.now().subtract(Duration(days: 120));

  //   // Query documents with lastActiveDate older than three months
  //   QuerySnapshot querySnapshot = await targetRef
  //       .where('lastActiveDate', isLessThan: threeMonthsAgo)
  //       .get();

  //   // Initialize a batch for deleting documents
  //   WriteBatch batch = _firestore.batch();

  //   // Iterate over the query snapshot
  //   for (var documentSnapshot in querySnapshot.docs) {
  //     // Delete each document in the batch
  //     batch.delete(documentSnapshot.reference);
  //   }

  //   // Commit the batch delete operation
  //   await batch.commit();
  // }

  // _new2() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         var sourceFieldName = 'professionalVideo1';
  //         var targetFieldName = 'lastActiveDate';

  //         var fieldValue =
  //             data.containsKey(sourceFieldName) ? data[sourceFieldName] : null;

  //         // Write the field to the target document with the new field name
  //         batch.set(targetDoc.reference, {targetFieldName: fieldValue},
  //             SetOptions(merge: true));
  //       } else {
  //         print('No data for document ${sourceDoc.id}');
  //       }
  //     } else {
  //       print('No document with ID ${targetDoc.id} in source collection');
  //     }
  //   }

  //   await batch.commit();
  // }

  // _new() async {
  //   // try {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_professsional');
  //   CollectionReference sourceRef = _firestore.collection('users');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         // print('Data for document ${sourceDoc.id}: $data'); // ADD THIS LINE

  //         var someFields = {
  //           'continent':
  //               data.containsKey('continent') ? data['continent'] : null,
  //           'city': data.containsKey('city') ? data['city'] : null,
  //           'country': data.containsKey('country') ? data['country'] : null,
  //           // 'verified': false,
  //         };

  //         print('Fields to be copied: $someFields'); // ADD THIS LINE

  //         // Write the new map to the target document
  //         batch.set(targetDoc.reference, someFields, SetOptions(merge: true));
  //       } else {
  //         print('No data for document ${sourceDoc.id}'); // ADD THIS LINE
  //       }
  //     } else {
  //       print(
  //           'No document with ID ${targetDoc.id} in source collection'); // ADD THIS LINE
  //     }
  //   }

  //   await batch.commit();
  // }

  // _eventCopy() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('new_eventChatRooms');
  //   CollectionReference sourceRef = _firestore.collection('new_allEvents');

  //   // Get documents from source collection
  //   QuerySnapshot sourceSnapshot = await sourceRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var sourceDoc in sourceSnapshot.docs) {
  //     Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
  //     if (data != null) {
  //       print('Data for document ${sourceDoc.id}: $data');

  //       var someFields = {
  //         'linkedEventId': sourceDoc.id, // Use sourceDoc.id directly
  //         'imageUrl': data.containsKey('imageUrl') ? data['imageUrl'] : null,
  //         'timestamp': data.containsKey('timestamp') ? data['timestamp'] : null,
  //         'title': data.containsKey('title') ? data['title'] : null,
  //       };

  //       print('Fields to be copied: $someFields');

  //       // Create a new document in targetRef with the same ID as sourceDoc
  //       batch.set(targetRef.doc(sourceDoc.id), someFields);
  //     } else {
  //       print('No data for document ${sourceDoc.id}');
  //     }
  //   }

  //   await batch.commit();
  // }
// // This code helps to duplicate a collection in firebase a whole

// //   _new() async {
// //     try {
// //       final _firestore = FirebaseFirestore.instance;
// //       CollectionReference sourceRef = _firestore.collection('new_allEvents');
// //       CollectionReference targetRef = _firestore.collection('testing');

// //       // Get documents from source collection
// //       QuerySnapshot querySnapshot = await sourceRef.get();

// //       // Initialize Firestore batch
// //       WriteBatch batch = _firestore.batch();

// //       querySnapshot.docs.forEach((doc) {
// //         // Duplicate each document in the target collection
// //         batch.set(targetRef.doc(doc.id), doc.data());
// //       });

// //       await batch.commit();
// //     } catch (e) {
// //       print(e.toString());
// //     }
// //   }

// //     FirebaseFirestore firestore = FirebaseFirestore.instance;
// //     CollectionReference userProfessionalCollection =
// //         firestore.collection('user_professsional');

// // // Start a new batch
// //     WriteBatch batch = firestore.batch();

// //     await userProfessionalCollection.get().then((QuerySnapshot querySnapshot) {
// //       querySnapshot.docs.forEach((doc) {
// //         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

// //         // Only proceed if data is not null
// //         if (data != null) {
// //           // Rename "Skills" to "skills" and "Terms" to "terms"
// //           if (data.containsKey('Skills')) {
// //             data['skills'] = data['Skills'];
// //             data.remove('Skills');
// //           }

// //           if (data.containsKey('Terms')) {
// //             data['terms'] = data['Terms'];
// //             data.remove('Terms');
// //           }

// //           // Add "professionalImageUrls" field if it doesn't exist
// //           if (!data.containsKey('professionalImageUrls')) {
// //             data['professionalImageUrls'] = [];
// //           }

// //           // Add the document update operation to the batch
// //           batch.update(doc.reference, data);
// //         }
// //       });
// //     });

// // // Commit the batch
// //     await batch.commit();
//   }

  // _deleteOldDocs() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   Query usersRef = _firestore.collection('users');
  //   CollectionReference targetRef = _firestore.collection('user_professsional');

  //   // Get current date and subtract 6 months
  //   DateTime sixMonthsAgo = DateTime.now().subtract(Duration(days: 30 * 6));

  //   // Get all documents from the users collection
  //   QuerySnapshot querySnapshot = await usersRef.get();
  //   List<DocumentSnapshot> docs = querySnapshot.docs;

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   docs.forEach((doc) {
  //     String timestamp = doc['professionalVideo1'];
  //     if (timestamp.isNotEmpty) {
  //       // Truncate the timestamp string to three fractional second digits if they exist
  //       int dotIndex = timestamp.lastIndexOf('.');
  //       if (dotIndex != -1 && timestamp.length - dotIndex > 4) {
  //         timestamp = timestamp.substring(0, dotIndex + 4);
  //       }

  //       // Parse the truncated timestamp string to a DateTime object
  //       DateTime docTimestamp = DateTime.parse(timestamp);

  //       // Check if the document's timestamp is earlier than 6 months ago
  //       if (docTimestamp.isBefore(sixMonthsAgo)) {
  //         // Get the document from the target collection with the same id
  //         DocumentReference targetDoc = targetRef.doc(doc.id);

  //         // Add document deletion to the batch
  //         batch.delete(targetDoc);
  //       }
  //     }
  //   });

  //   // Commit the batch
  //   try {
  //     await batch.commit();
  //     print('Batch committed successfully.');
  //   } catch (e) {
  //     print('Error committing batch: ${e.toString()}');
  //   }
  // }

//working, copied userId and set specified user fields.
//   _new() async {
// //  try {
//     final _firestore = FirebaseFirestore.instance;
//     Query sourceRef = _firestore // Changed from CollectionReference to Query
//         .collection('users')
//         .where('professionalVideo1', isNotEqualTo: '');
//     CollectionReference targetRef = _firestore.collection('user_professsional');

//     // Get documents from source collection
//     QuerySnapshot querySnapshot = await sourceRef.get();
//     List<DocumentSnapshot> docs = querySnapshot.docs;

//     int batchLimit = 500;
//     int totalBatches = (docs.length / batchLimit).ceil();

//     for (var i = 0; i < totalBatches; i++) {
//       // Initialize Firestore batch
//       WriteBatch batch = _firestore.batch();

//       // Get a slice of the documents to be processed in this batch
//       var batchDocs = docs.skip(i * batchLimit).take(batchLimit).toList();

//       batchDocs.forEach((doc) {
//         // Create a new map that only contains the fields you're interested in
//         var someFields = {
//           'id': doc.id,
//           'company': [],
//           'performances': [],
//           'collaborations': [],
//           'awards': [],
//           // 'management': [],
//           'contacts': [],

//           'links': [],
//           'subAccountType': [],
//           'genreTags': [],
//           'priceTags': [],
//           'noBooking': false,
//           'overview': '',

// 'professionalImageUrls': [],
//  'Skills': [],
//           'Terms': '',
//         };

//         // Write the new map to the target document
//         batch.set(targetRef.doc(doc.id), someFields);
//       });

//       // Commit the batch
//       try {
//         await batch.commit();
//         print('Batch $i committed successfully.');
//       } catch (e) {
//         print('Error committing batch $i: ${e.toString()}');
//       }
//     }
//   }

// // This code helps to duplicate specific fields of collections in firebase
  // _new() async {
  //   try {
  //     final _firestore = FirebaseFirestore.instance;
  //        CollectionReference targetRef =
  //         _firestore.collection('user_professsional');
  //     CollectionReference sourceRef =  _firestore.collection('users');

  //     // Get documents from source collection
  //     QuerySnapshot querySnapshot = await sourceRef.get();

  //     // Initialize Firestore batch
  //     WriteBatch batch = _firestore.batch();

  //     querySnapshot.docs.forEach((doc) {
  //       // Create a new map that only contains the fields you're interested in
  //       var someFields = {

  //         'userName': doc.userName,
  //         'profileImageUrl':  doc.profileImageUrl,
  //         'profileHandle':  doc.profileHandle,
  //          'verified':  doc.verified,

  //       };

  //       // Write the new map to the target document
  //     batch.set(targetRef.doc(doc.id), someFields);
  //     });

  //     await batch.commit();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _setUpactivityCount() {
    var _provider = Provider.of<UserData>(context, listen: false);

    final String currentUserId = _provider.currentUserId!;
    DatabaseService.numActivities(currentUserId).listen((activityCount) {
      if (mounted) {
        _provider.setActivityCount(activityCount);
      }
    });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _configureNotification() async {
    final String? currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    if (currentUserId != null) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await usersGeneralSettingsRef
              .doc(currentUserId)
              .update({'androidNotificationToken': token});
        }
      } catch (e) {}
      try {
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          if (newToken != null) {
            usersGeneralSettingsRef
                .doc(currentUserId)
                .update({'androidNotificationToken': newToken});
          }
        });

        final authorizationStatus =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );

        if (authorizationStatus.authorizationStatus ==
            AuthorizationStatus.authorized) {
          FirebaseMessaging.instance.getInitialMessage().then((message) {
            _handleNotification(
              message,
            );
          });

          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.notification?.body ?? ""),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {},
                ),
              ),
            );
          });

          FirebaseMessaging.onMessageOpenedApp.listen((message) {
            _handleNotification(message, fromBackground: true);
          });
        }
      } catch (e) {}
    }
  }

  void _handleNotification(RemoteMessage? message,
      {bool fromBackground = false}) async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    if (message?.data != null) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'com.example.barsImpression',
        'barsImpression',
        importance: Importance.max,
        playSound: true,
      );

      const IOSNotificationDetails iosNotificationDetails =
          IOSNotificationDetails(
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      // if (!fromBackground) {
      // Extract data from the message
      if (message != null) {
        // String? recipient = message.data['recipient'];
        String? contentType = message.data['contentType'];
        String? contentId = message.data['contentId'];
        // String? title = message.data['title'];
        // String? body = message.data['body'];

        // Display the notification
        // await _notificationsPlugin.show(
        //   DateTime.now().microsecond,
        //   message.notification!.title,
        //   message.notification!.body,
        //   notificationDetails,
        // );

        // Navigate to the correct page
        if (contentId != null) {
          // if (contentType!.endsWith('message')) {
          //   try {
          //     Chat? _chat = await DatabaseService.getUserChatWithId(
          //       currentUserId,
          //       contentId,
          //     );

          //     AccountHolderAuthor? _user = await DatabaseService.getUserWithId(
          //       contentId,
          //     );

          //     _navigateToPage(
          //         context,
          //         BottomModalSheetMessage(
          //           currentUserId: currentUserId,
          //           user: null,
          //           showAppbar: true,
          //           userAuthor: _user,
          //           chatLoaded: _chat,
          //           userPortfolio: null,
          //           userId: contentId,
          //         ));
          //   } catch (e) {}
          // }
          contentType!.endsWith('ask') ||
                  contentType.endsWith('like') ||
                  contentType.endsWith('advice')
              // contentType.endsWith('ask')
              ? _navigateToPage(
                  context, NotificationPage(currentUserId: currentUserId))
              : contentType.endsWith('follow') ||
                      contentType.endsWith('ticketPurchased')
                  ? _navigateToPage(
                      context,
                      ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: contentId,
                        user: null,
                      ))
                  : contentType.endsWith('message')
                      ? _navigateToPage(
                          context,
                          ViewSentContent(
                            contentId: contentId,
                            contentType: 'message',
                          ),
                        )
                      : contentType.endsWith('eventRoom')
                          ? _navigateToPage(
                              context,
                              ViewSentContent(
                                contentId: contentId,
                                contentType: 'eventRoom',
                              ),
                            )
                          : _navigateToPage(
                              context,
                              ViewSentContent(
                                contentId: contentId,
                                contentType: contentType
                                        .endsWith('newEventInNearYou')
                                    ? 'Event'
                                    : contentType.endsWith('eventUpdate')
                                        ? 'Event'
                                        : contentType.endsWith('eventReminder')
                                            ? 'Event'
                                            : contentType
                                                    .endsWith('refundRequested')
                                                ? 'Event'
                                                : contentType.startsWith(
                                                        'inviteRecieved')
                                                    ? 'InviteRecieved'
                                                    : '',
                              ),
                            );
        }
        // }
      }
    }
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.getInitialLink();

    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) async {
      final Uri? link = dynamicLinkData?.link;
      if (link != null && link.path.isNotEmpty) {
        final List<String> parts = link.path.split("_");
        if (parts.length >= 2) {
          parts[0].endsWith('user')
              ? _navigateToPage(
                  context,
                  ProfileScreen(
                    currentUserId:
                        Provider.of<UserData>(context).currentUserId!,
                    userId: parts[1],
                    user: null,
                  ))
              : _navigateToPage(
                  context,
                  ViewSentContent(
                    contentId: parts[1],
                    contentType: parts[0].endsWith('punched')
                        ? 'Mood Punched'
                        : parts[0].endsWith('event')
                            ? 'Event'
                            : '',
                  ),
                );
        } else {
          print('Link format not as expected: $link');
        }
      }
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: FutureBuilder<UpdateApp>(
          future: DatabaseService.getUpdateInfo(),
          builder: (BuildContext context, AsyncSnapshot<UpdateApp> snapshot) {
            if (snapshot.hasError) {
              // Replace this with your own error widget
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return PostSchimmerSkeleton();
            }
            final _updateApp = snapshot.data!;
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled) => [],
                body: HomeMobile(
                  updateApp: _updateApp,
                  updateAppVersion: _updateAppVersion,
                ));
          }),
    );
  }
}

//display home screen for mobile version
class HomeMobile extends StatefulWidget {
  final UpdateApp updateApp;
  final int updateAppVersion;

  const HomeMobile(
      {Key? key, required this.updateApp, required this.updateAppVersion})
      : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile>
    with SingleTickerProviderStateMixin {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  int _currentTab = 1;
  late PageController _pageController;
  int _version = 0;
  bool _showInfo = false;
  // int _inviteCount = -1;

  List<InviteModel> _inviteList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentTab,
    );
    // _setUpInvitsCount();

    int? version = Platform.isIOS
        ? widget.updateApp.updateVersionIos
        : widget.updateApp.updateVersionAndroid;
    _version = version!;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _setUpInvites();
      await initDynamicLinks();
      _setShowDelayInfo();
    });
  }

  // _setUpInvitsCount() async {
  //   final String currentUserId =
  //       Provider.of<UserData>(context, listen: false).currentUserId!;
  //   int feedCount = await DatabaseService.numUnAnsweredInvites(currentUserId);
  //   if (mounted) {
  //     setState(() {
  //       _inviteCount = feedCount;
  //     });
  //   }
  // }

  DocumentSnapshot? lastDocument;
  final now = DateTime.now();

// Define a constant for how many documents to fetch at a time
  static const int inviteLimit = 2;

  _setUpInvites() async {
    final currentDate = DateTime(now.year, now.month, now.day);
    try {
      final String currentUserId =
          Provider.of<UserData>(context, listen: false).currentUserId!;
      QuerySnapshot eventFeedSnapShot;

      // If lastDocument is null, this is the first fetch
      if (lastDocument == null) {
        eventFeedSnapShot = await userIviteRef
            .doc(currentUserId)
            .collection('eventInvite')
            // .where('startDate', isGreaterThanOrEqualTo: currentDate)
            .orderBy('eventTimestamp', descending: true)
            .limit(inviteLimit)
            .get();
      } else {
        // If lastDocument is not null, fetch the next batch starting after the last document
        eventFeedSnapShot = await userIviteRef
            .doc(currentUserId)
            .collection('eventInvite')
            // .where('startDate', isGreaterThanOrEqualTo: currentDate)
            .orderBy('eventTimestamp', descending: true)
            .startAfterDocument(lastDocument!)
            .limit(inviteLimit)
            .get();
      }

      // If there are documents, set the last one
      if (eventFeedSnapShot.docs.isNotEmpty) {
        lastDocument = eventFeedSnapShot.docs.last;
      }

      List<InviteModel> invites = eventFeedSnapShot.docs
          .map((doc) => InviteModel.fromDoc(doc))
          .toList();

      if (mounted) {
        setState(() {
          _inviteList
              .addAll(invites); // append new invites to the existing list
        });
      }
      return invites;
    } catch (e) {
      // print('Error fetching invites: $e');
      _showBottomSheetErrorMessage('Failed to fetch invites.');
      return null; // return null or an empty list, depending on how you want to handle errors
    }
  }

  _setShowDelayInfo() {
    if (!_showInfo) {
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _showInfo = true;
          _setShowInfo();
        }
      });
    }
  }

  _setShowInfo() {
    if (_showInfo) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    FirebaseDynamicLinks.instance.getInitialLink(); //
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      final List<String> link = dynamicLinkData.link.path.toString().split("_");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewSentContent(
                  contentId: link[1],
                  contentType: link[0].endsWith('punched')
                      ? 'Mood Punched'
                      : link[0].endsWith('forum')
                          ? 'Forum'
                          : link[0].endsWith('event')
                              ? 'Event'
                              : link[0].endsWith('user')
                                  ? 'User'
                                  : '')));
    }).onError((error) {});
  }

  _tabColumn(IconData icon, int currentTab, int index) {
    var _provider = Provider.of<UserData>(context);

    return Column(
      children: [
        index != 4
            ? const SizedBox.shrink()
            : _provider.activityCount == 0
                ? const SizedBox.shrink()
                : CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 3,
                  ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 2,
          curve: Curves.easeInOut,
          width: 30.0,
          decoration: BoxDecoration(
            color: currentTab == index ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: -0.0),
          child: Icon(
            icon,
            size: 25.0,
          ),
        ),
      ],
    );
  }

  void _showBottomSheetErrorMessage(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    final String currentUserId = _provider.currentUserId!;
    final AccountHolderAuthor user = _provider.user!;
    final UserSettingsLoadingPreferenceModel userLocationSettings =
        _provider.userLocationPreference!;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    bool dontShowActivityCount = _provider.activityCount == 0 || !_showInfo;
    return widget.updateAppVersion < _version &&
            widget.updateApp.displayFullUpdate!
        ? UpdateAppInfo(
            updateNote: widget.updateApp.updateNote!,
            version: widget.updateApp.version!,
          )
        : Stack(
            alignment: FractionalOffset.center,
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: Container(
                  width: width,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      )
                    ],
                  ),
                  child:

                      // user.disabledAccount!
                      //     ? ReActivateAccount(user: user)
                      //     :

                      Stack(
                    alignment: FractionalOffset.center,
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: PageView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _pageController,
                          children: <Widget>[
                            Chats(
                              currentUserId: currentUserId,
                              userId: '',
                            ),
                            // FeedScreenSliver(
                            //   currentUserId: currentUserId,
                            // ),
                            DiscoverEventScreen(
                              currentUserId: currentUserId,
                              userLocationSettings: userLocationSettings,
                              isLiveLocation: false,
                              liveCity: '',
                              liveCountry: '',
                              liveLocationIntialPage: 0,
                              sortNumberOfDays: 0,
                            ),
                            DiscoverUser(
                              currentUserId: currentUserId,
                              isWelcome: false,
                              isLiveLocation: false,
                              liveCity: '',
                              liveCountry: '',
                              liveLocationIntialPage: 0,
                            ),
                            TicketAndCalendarFeedScreen(
                              currentUserId: currentUserId,
                            ),
                            Chats(
                              currentUserId: currentUserId,
                              userId: '',
                            ),
                            // DiscoverUser(
                            //   currentUserId: currentUserId,
                            //   isWelcome: false,
                            //   isLiveLocation: false,
                            //   liveCity: '',
                            //   liveCountry: '',
                            //   liveLocationIntialPage: 0,
                            // ),
                            ProfileScreen(
                              currentUserId: currentUserId,
                              userId: currentUserId,
                              user: user,
                            ),
                          ],
                          onPageChanged: (int index) {
                            setState(() {
                              _currentTab = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 7,
                          child: UpdateInfoMini(
                            updateNote: widget.updateApp.updateNote!,
                            showinfo: widget.updateAppVersion < _version
                                ? true
                                : false,
                            displayMiniUpdate:
                                widget.updateApp.displayMiniUpdate!,
                            onPressed: () {
                              StoreRedirect.redirect(
                                androidAppId: "com.barsOpus.barsImpression",
                                iOSAppId: "1610868894",
                              );
                            },
                          )),
                      Positioned(bottom: 7, child: NoConnection()),

                      Positioned(
                        bottom: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 800),
                            height: dontShowActivityCount ? 0.0 : 40,
                            width: dontShowActivityCount ? 1 : 150,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5)),
                            child: SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateToPage(NotificationPage(
                                      currentUserId: currentUserId));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // color: Colors.green,
                                      width: 30,
                                      child: Icon(
                                        Icons.notifications_active_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      NumberFormat.compact()
                                          .format(_provider.activityCount),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: dontShowActivityCount
                                              ? 0
                                              : ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 16.0),
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(bottom: 30, child: _createAnimator()),
                    ],
                  ),
                ),
                bottomNavigationBar:
                    //  user.disabledAccount!
                    //     ? const SizedBox.shrink()
                    //     :
                    _currentTab == 0
                        ? const SizedBox.shrink()
                        : Wrap(
                            children: [
                              BottomNavigationBar(
                                type: BottomNavigationBarType.fixed,
                                backgroundColor:
                                    // _currentTab == 1
                                    //     ? Colors.black
                                    //     :

                                    Theme.of(context).primaryColorLight,
                                currentIndex: _currentTab - 1,
                                onTap: (int index) {
                                  setState(() {
                                    _currentTab = index + 1;
                                  });

                                  _pageController.animateToPage(
                                    index + 1,
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.easeIn,
                                  );
                                },
                                showUnselectedLabels: true,
                                selectedLabelStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 10.0),
                                ), // font size of selected item
                                unselectedLabelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 10.0),
                                ),
                                unselectedItemColor: Colors.grey,
                                //     // _currentTab == 1
                                //     //     ? Colors.white
                                //     //     :

                                selectedItemColor:
                                    //     // _currentTab == 1
                                    //     //     ? Colors.white
                                    //     //     :
                                    Theme.of(context).secondaryHeaderColor,

                                items: [
                                  BottomNavigationBarItem(
                                    icon:
                                        _tabColumn(Icons.event, _currentTab, 1),
                                    label: 'Event',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _tabColumn(
                                        Icons.search, _currentTab, 2),
                                    label: 'Book',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _tabColumn(
                                        MdiIcons.ticketOutline, _currentTab, 3),
                                    label: 'Tickets',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _tabColumn(
                                        Icons.send_outlined, _currentTab, 4),
                                    label: 'Chats',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _tabColumn(
                                        Icons.account_circle_outlined,
                                        _currentTab,
                                        5),
                                    label: 'Profile',
                                  ),
                                ],
                              ),
                            ],
                          ),
              ),
              _inviteList.length < 1
                  // _inviteCount.isNegative
                  ? const SizedBox.shrink()
                  : Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(.7),
                    ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 800),
                    height: _inviteList.length < 1
                        ? 0
                        : ResponsiveHelper.responsiveHeight(context, 500.0),
                    width: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: width,
                              child: GestureDetector(
                                child: ListTile(
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _navigateToPage(InvitationPages(
                                        currentUserId: currentUserId,
                                      ));
                                    },
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14.0),
                                      ),
                                    ),
                                  ),
                                  leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    iconSize: ResponsiveHelper.responsiveHeight(
                                        context, 25.0),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () {
                                      _inviteList.clear();
                                    },
                                  ),
                                  title: Text(
                                    'Event\nInvitations',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                height: 400,
                                // color: Colors.blue,
                                child: ListView.builder(
                                  itemCount: _inviteList.length,
                                  itemBuilder: (context, index) {
                                    InviteModel invite = _inviteList[index];
                                    return InviteContainerWidget(
                                      invite: invite,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _provider.shortcutBool
                  ? Positioned(
                      bottom: 0.0,
                      child: Material(
                        child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                _provider.setShortcutBool(false);
                              }
                            },
                            child: Container()
                            // CreateContentsHome(
                            //   width: width,
                            // ),
                            ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          );
  }
}

// //Desktope version
// class HomeDesktop extends StatefulWidget {
//   final UpdateApp updateApp;
//   final int updateAppVersion;

//   const HomeDesktop(
//       {Key? key, required this.updateApp, required this.updateAppVersion})
//       : super(key: key);

//   @override
//   State<HomeDesktop> createState() => _HomeDesktopState();
// }

// class _HomeDesktopState extends State<HomeDesktop> {
//   late PageController _pageController;
//   int _currentTab = 0;
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   int _activityEventCount = 0;
//   String notificationMsg = '';
//   int _version = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     int? version = Platform.isIOS
//         ? widget.updateApp.updateVersionIos
//         : widget.updateApp.updateVersionAndroid;
//     _version = version!;
//     WidgetsFlutterBinding.ensureInitialized();

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       // _setUpInvitesActivities();
//       initDynamicLinks();
//     });
//   }

//   Future<void> initDynamicLinks() async {
//     FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//     FirebaseDynamicLinks.instance.getInitialLink();
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       final Uri uri = dynamicLinkData.link;
//       final queryParams = uri.queryParameters;
//       if (queryParams.isNotEmpty) {
//         final List<String> link = queryParams.toString().split("_");

//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => ViewSentContent(
//                     contentId: link[1],
//                     contentType: link[0].endsWith('punched')
//                         ? 'Mood Punched'
//                         : link[0].endsWith('forum')
//                             ? 'Forum'
//                             : link[0].endsWith('event')
//                                 ? 'Event'
//                                 : link[0].endsWith('user')
//                                     ? 'User'
//                                     : '')));
//       }
//     });
//   }

//   // _setUpInvitesActivities() async {
//   //   final String currentUserId =
//   //       Provider.of<UserData>(context, listen: false).currentUserId;
//   //   DatabaseService.numEventInviteActivities(currentUserId)
//   //       .listen((activityEventCount) {
//   //     if (mounted) {
//   //       setState(() {
//   //         _activityEventCount = activityEventCount;
//   //       });
//   //     }
//   //   });
//   // }

//   Future<void> _sendMail(String url) async {
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     if (await canLaunchUrl(
//       Uri.parse(url),
//     )) {
//       await (launchUrl(
//         Uri.parse(url),
//       ));
//     } else {
//       mySnackBar(context, 'Could not launch mail');

//       // Flushbar(
//       //   margin: const EdgeInsets.all(8),
//       //   boxShadows: [
//       //     const BoxShadow(
//       //       color: Colors.black,
//       //       offset: Offset(0.0, 2.0),
//       //       blurRadius: 3.0,
//       //     )
//       //   ],
//       //   flushbarPosition: FlushbarPosition.TOP,
//       //   flushbarStyle: FlushbarStyle.FLOATING,
//       //   titleText: Text(
//       //     'Sorry',
//       //     style: TextStyle(
//       //       color: Colors.white,
//       //       fontSize: width > 800 ? 22 : 14,
//       //     ),
//       //   ),
//       //   messageText: Text(
//       //     'Could\'nt launch mail',
//       //     style: TextStyle(
//       //       color: Colors.white,
//       //       fontSize: width > 800 ? 20 : 12,
//       //     ),
//       //   ),
//       //   icon: const Icon(
//       //     Icons.info_outline,
//       //     size: 28.0,
//       //     color: Colors.blue,
//       //   ),
//       //   duration: const Duration(seconds: 3),
//       //   leftBarIndicatorColor: Colors.blue,
//       // )..show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     final String currentUserId = _provider.currentUserId!;
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     AccountHolderAuthor _user = _provider.user!;
//     final UserSettingsLoadingPreferenceModel userLocationSettings =
//         _provider.userLocationPreference!;

//     return widget.updateAppVersion < _version &&
//             widget.updateApp.displayFullUpdate!
//         ? UpdateAppInfo(
//             updateNote: widget.updateApp.updateNote!,
//             version: widget.updateApp.version!,
//           )
//         : Scaffold(
//             backgroundColor: Theme.of(context).primaryColor,
//             body: _user.disabledAccount!
//                 ? ReActivateAccount(user: _user)
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Provider.of<UserData>(context, listen: false).user == null
//                           ? const SizedBox.shrink()
//                           : Container(
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColorLight,
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     offset: Offset(0, 5),
//                                     blurRadius: 8.0,
//                                     spreadRadius: 2.0,
//                                   )
//                                 ],
//                               ),
//                               width: 300,
//                               height: width * 3,
//                               child: ListView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: UserWebsite(
//                                       iconSize: 35,
//                                       padding: 5,
//                                       raduis: 100,
//                                       arrowColor: Colors.transparent,
//                                       title: '  Home',
//                                       icon: MdiIcons.home,
//                                       textColor: _currentTab != 0
//                                           ? Colors.grey
//                                           : Theme.of(context).primaryColor,
//                                       iconColor: _currentTab != 0
//                                           ? Colors.grey
//                                           : Theme.of(context).primaryColor,
//                                       onPressed: () {
//                                         _pageController.animateToPage(
//                                           _currentTab = 0,
//                                           duration:
//                                               const Duration(milliseconds: 500),
//                                           curve: Curves.easeInOut,
//                                         );
//                                       },
//                                       containerColor: null,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: UserWebsite(
//                                         containerColor: null,
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Forum',
//                                         icon: Icons.forum,
//                                         textColor: _currentTab != 1
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         iconColor: _currentTab != 1
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 1,
//                                             duration: const Duration(
//                                                 milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         }),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: UserWebsite(
//                                         containerColor: null,
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Event',
//                                         icon: Icons.event,
//                                         textColor: _currentTab != 2
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         iconColor: _currentTab != 2
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 2,
//                                             duration: const Duration(
//                                                 milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         }),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: UserWebsite(
//                                         containerColor: null,
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Discover',
//                                         icon: Icons.search,
//                                         textColor: _currentTab != 3
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         iconColor: _currentTab != 3
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 3,
//                                             duration: const Duration(
//                                                 milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         }),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: UserWebsite(
//                                         containerColor: null,
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Profile',
//                                         icon: Icons.account_circle,
//                                         textColor: _currentTab != 4
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         iconColor: _currentTab != 4
//                                             ? Colors.grey
//                                             : Theme.of(context).primaryColor,
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 4,
//                                             duration: const Duration(
//                                                 milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         }),
//                                   ),
//                                   const SizedBox(
//                                     height: 30,
//                                   ),
//                                   AnimatedContainer(
//                                     curve: Curves.easeInOut,
//                                     duration: const Duration(milliseconds: 800),
//                                     height:
//                                         _activityEventCount != 0 ? 80.0 : 0.0,
//                                     width: width - 10,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[400],
//                                     ),
//                                     child: Material(
//                                         color: Colors.transparent,
//                                         child: ListTile(
//                                             leading: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 8.0),
//                                               child: Icon(
//                                                 Icons.info,
//                                                 color: _activityEventCount != 0
//                                                     ? Colors.black
//                                                     : Colors.transparent,
//                                                 size: 25.0,
//                                               ),
//                                             ),
//                                             trailing: IconButton(
//                                               icon: const Icon(
//                                                   Icons.event_available),
//                                               iconSize: 25.0,
//                                               color: _activityEventCount != 0
//                                                   ? Colors.black
//                                                   : Colors.transparent,
//                                               onPressed: () {},
//                                             ),
//                                             title: Text(
//                                                 '${_activityEventCount.toString()}  Event Invitations',
//                                                 style: const TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors.black,
//                                                 )),
//                                             subtitle: Text(
//                                               'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
//                                               style: const TextStyle(
//                                                 fontSize: 11.0,
//                                                 color: Colors.black,
//                                               ),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             onTap: () {})),
//                                   ),
//                                   const SizedBox(
//                                     height: 30,
//                                   ),
//                                   NoConnection(),
//                                   const SizedBox(
//                                     height: 30,
//                                   ),
//                                   const Divider(color: Colors.grey),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 30.0, left: 30, bottom: 30),
//                                     child: Text(
//                                       'Bars \nImpression',
//                                       style: TextStyle(
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.w100,
//                                         color: Theme.of(context)
//                                             .secondaryHeaderColor,
//                                       ),
//                                     ),
//                                   ),
//                                   const Divider(color: Colors.grey),
//                                   Container(
//                                     color: Colors.grey[300],
//                                     child: UpdateInfoMini(
//                                       updateNote: widget.updateApp.updateNote!,
//                                       showinfo:
//                                           widget.updateAppVersion < _version
//                                               ? true
//                                               : false,
//                                       displayMiniUpdate:
//                                           widget.updateApp.displayMiniUpdate!,
//                                       onPressed: () {
//                                         StoreRedirect.redirect(
//                                           androidAppId:
//                                               "com.barsOpus.barsImpression",
//                                           iOSAppId: "1610868894",
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 60,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 30.0, left: 30),
//                                     child: GestureDetector(
//                                       onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             SuggestionBox()));
//                                       },
//                                       child: const Text(
//                                         'Suggestion Box',
//                                         style: TextStyle(color: Colors.blue),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 30.0, left: 30),
//                                     child: GestureDetector(
//                                       onTap: () => Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => AboutUs())),
//                                       child: const Text(
//                                         'About us',
//                                         style: TextStyle(color: Colors.blue),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 30.0, left: 30),
//                                     child: GestureDetector(
//                                       onTap: () => setState(() {
//                                         _sendMail(
//                                             'mailto:support@barsopus.com');
//                                       }),
//                                       child: const Text(
//                                         'Contact us',
//                                         style: TextStyle(color: Colors.blue),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       Container(
//                         width: 600,
//                         decoration: const BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               offset: Offset(0, 10),
//                               blurRadius: 8.0,
//                               spreadRadius: 2.0,
//                             )
//                           ],
//                         ),
//                         child: PageView(
//                           physics: const NeverScrollableScrollPhysics(),
//                           controller: _pageController,
//                           children: <Widget>[
//                             // FeedScreenSliver(
//                             //   currentUserId: currentUserId,
//                             // ),
//                             EventPage(
//                                 currentUserId: currentUserId,
//                                 userLocationSettings: userLocationSettings,
//                                 isLiveLocation: false,
//                                 liveCity: '',
//                                 liveCountry: '',
//                                 liveLocationIntialPage: 0,
//                                 sortNumberOfDays: 0),
//                             // ForumFeed(
//                             //   currentUserId: currentUserId,
//                             // ),
//                             EventsFeed(
//                               currentUserId: currentUserId,
//                             ),
//                             DiscoverUser(
//                               isLiveLocation: false,
//                               liveCity: '',
//                               liveCountry: '',
//                               liveLocationIntialPage: 0,
//                               isWelcome: false,
//                               currentUserId: currentUserId,
//                             ),
//                             ProfileScreen(
//                               currentUserId: currentUserId,
//                               userId: currentUserId,
//                               user: _user,
//                             ),
//                           ],
//                           onPageChanged: (int index) {
//                             setState(() {
//                               _currentTab = index;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//           );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   static final id = 'Home_screen';

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _updateAppVersion = Platform.isIOS ? 17 : 17;
//   String notificationMsg = '';

//   @override
//   void initState() {
//     super.initState();
//     LocalNotificationService.initilize();
//     _configureNotification();
//   }

//   _configureNotification() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     FirebaseMessaging.instance.getToken().then((token) => {
//           usersRef
//               .doc(currentUserId)
//               .update({'androidNotificationToken': token})
//         });

//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       FirebaseMessaging.instance.getInitialMessage().then((event) {
//         if (event != null) {
//           setState(() {
//             notificationMsg =
//                 "${event.notification!.title}  ${event.notification!.body}";
//           });
//         }
//       });

//       FirebaseMessaging.onMessageOpenedApp.listen((event) {
//         setState(() {
//           notificationMsg =
//               "${event.notification!.title}  ${event.notification!.body}";
//         });
//       });
//     }

//     FirebaseMessaging.onMessage.listen((event) {
//       final String recipientId = event.data['recipient'];
//       if (recipientId == currentUserId) {
//         LocalNotificationService.showNotificationOnForeground(event);
//         setState(() {
//           notificationMsg =
//               "${event.notification!.title}  ${event.notification!.body}";
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//       child: FutureBuilder(
//           future: DatabaseService.getUpdateInfo(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return ResponsiveScaffold(child: PostSchimmerSkeleton());
//             }
//             UpdateApp _updateApp = snapshot.data;
//             return NestedScrollView(
//                 headerSliverBuilder: (context, innerBoxScrolled) => [],
//                 body: Responsive.isDesktop(context)
//                     ? HomeDesktop(
//                         updateApp: _updateApp,
//                         updateAppVersion: _updateAppVersion,
//                       )
//                     : HomeMobile(
//                         updateApp: _updateApp,
//                         updateAppVersion: _updateAppVersion,
//                       ));
//           }),
//     );
//   }
// }

// class HomeMobile extends StatefulWidget {
//   final UpdateApp updateApp;
//   final int updateAppVersion;

//   const HomeMobile(
//       {Key? key, required this.updateApp, required this.updateAppVersion})
//       : super(key: key);

//   @override
//   State<HomeMobile> createState() => _HomeMobileState();
// }

// class _HomeMobileState extends State<HomeMobile> {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   int _activityEventCount = 0;
//   int _currentTab = 0;
//   late PageController _pageController;
//   int _version = 0;
//   bool _showInfo = false;
//   // bool _showInfoWidgets = false;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();

//     int? version = Platform.isIOS
//         ? widget.updateApp.updateVersionIos
//         : widget.updateApp.updateVersionAndroid;
//     _version = version!;
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _setUpInvitesActivities();
//       _setUpLastActiveDate();

//       initDynamicLinks();
//     });
//     __setShowDelsyInfo();
//   }

//   __setShowDelsyInfo() async {
//     if (!_showInfo) {
//       Timer(Duration(seconds: 3), () {
//         if (mounted) {
//           // setState(() {
//           _showInfo = true;
//           // });
//           __setShowInfo();
//         }
//       });
//     }
//   }

//   __setShowInfo() async {
//     if (_showInfo) {
//       Timer(Duration(seconds: 3), () {
//         if (mounted) {
//           // setState(() {
//           _showInfo = false;
//           // });
//         }
//       });
//     }
//   }

// Future<void> initDynamicLinks() async {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   FirebaseDynamicLinks.instance.getInitialLink(); //
//   dynamicLinks.onLink.listen((dynamicLinkData) {
//     final List<String> link = dynamicLinkData.link.path.toString().split("_");

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => ViewSentContent(
//                 contentId: link[1],
//                 contentType: link[0].endsWith('punched')
//                     ? 'Mood Punched'
//                     : link[0].endsWith('forum')
//                         ? 'Forum'
//                         : link[0].endsWith('event')
//                             ? 'Event'
//                             : link[0].endsWith('user')
//                                 ? 'User'
//                                 : '')));
//   }).onError((error) {});
// }

//   _setUpLastActiveDate() {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     usersRef
//         .doc(currentUserId)
//         .update({'professionalVideo1': DateTime.now().toString()});
//   }

//   _setUpInvitesActivities() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     DatabaseService.numEventInviteActivities(currentUserId)
//         .listen((activityEventCount) {
//       if (mounted) {
//         setState(() {
//           _activityEventCount = activityEventCount;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId =_provider.currentUserId;
//     final AccountHolder user = Provider.of<UserData>(context).user!;
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
//     return widget.updateAppVersion < _version &&
//             widget.updateApp.displayFullUpdate!
//         ? UpdateAppInfo(
//             updateNote: widget.updateApp.updateNote!,
//             version: widget.updateApp.version!,
//           )
//         : Stack(
//             alignment: FractionalOffset.center,
//             children: [
//               Scaffold(
//                 body: Container(
//                   width: width,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         offset: Offset(0, 10),
//                         blurRadius: 8.0,
//                         spreadRadius: 2.0,
//                       )
//                     ],
//                   ),
//                   child: _user.disabledAccount!
//                       ? ReActivateAccount(user: _user)
//                       : Stack(
//                           alignment: FractionalOffset.center,
//                           children: [
//                             Container(
//                               height: double.infinity,
//                               width: double.infinity,
//                               child: PageView(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 controller: _pageController,
//                                 children: <Widget>[
//                                   FeedScreenSliver(
//                                     currentUserId: currentUserId,
//                                   ),
//                                   ForumFeed(
//                                     currentUserId: currentUserId,
//                                   ),
//                                   EventsFeed(
//                                     currentUserId: currentUserId,
//                                   ),
//                                   DiscoverUser(
//                                     currentUserId: currentUserId,
//                                     isWelcome: false,
//                                   ),
//                                   ProfileScreen(
//                                     currentUserId: currentUserId,
//                                     userId: currentUserId,
//                                     user: user,
//                                   ),
//                                 ],
//                                 onPageChanged: (int index) {
//                                   setState(() {
//                                     _currentTab = index;
//                                   });
//                                 },
//                               ),
//                             ),
//                             Positioned(
//                                 bottom: 7,
//                                 child: UpdateInfoMini(
//                                   updateNote: widget.updateApp.updateNote!,
//                                   showinfo: widget.updateAppVersion < _version
//                                       ? true
//                                       : false,
//                                   displayMiniUpdate:
//                                       widget.updateApp.displayMiniUpdate!,
//                                   onPressed: () {
//                                     StoreRedirect.redirect(
//                                       androidAppId:
//                                           "com.barsOpus.barsImpression",
//                                       iOSAppId: "1610868894",
//                                     );
//                                   },
//                                 )),
//                             Positioned(bottom: 7, child: NoConnection()),
//                             Positioned(
//                               bottom: 7,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: AnimatedContainer(
//                                   curve: Curves.easeInOut,
//                                   duration: Duration(milliseconds: 800),
//                                   height: _activityEventCount != 0 ? 80.0 : 0.0,
//                                   width: width - 10,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Material(
//                                       color: Colors.transparent,
//                                       child: ListTile(
//                                         leading: Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 8.0),
//                                           child: Icon(
//                                             Icons.info,
//                                             color: Colors.black,
//                                             size: 25.0,
//                                           ),
//                                         ),
//                                         trailing: IconButton(
//                                           icon: Icon(Icons.event_available),
//                                           iconSize: 25.0,
//                                           color: Colors.black,
//                                           onPressed: () {},
//                                         ),
//                                         title: Text(
//                                             '${_activityEventCount.toString()}  Event Invitations',
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colors.black,
//                                             )),
//                                         subtitle: Text(
//                                           'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
//                                           style: TextStyle(
//                                             fontSize: 11.0,
//                                             color: Colors.black,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         onTap: () => Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (_) =>
//                                                   ActivityEventInvitation(
//                                                 currentUserId:
//                                                     Provider.of<UserData>(
//                                                             context,
//                                                             listen: false)
//                                                         .currentUserId,
//                                                 count: _activityEventCount,
//                                               ),
//                                             )),
//                                       )),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 30,
//                               // right: 5,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   HapticFeedback.heavyImpact();
//                                   if (mounted) {
//                                     // setState(() {
//                                     // _showInfoWidgets = true;
//                                     Provider.of<UserData>(context,
//                                             listen: false)
//                                         .setShortcutBool(true);
//                                     // });
//                                   }
//                                 },
//                                 child: AnimatedContainer(
//                                   curve: Curves.easeInOut,
//                                   duration: Duration(milliseconds: 400),
//                                   height: Provider.of<UserData>(context,
//                                               listen: false)
//                                           .showUsersTab
//                                       ? null
//                                       : 0.0,
//                                   width: Provider.of<UserData>(context,
//                                               listen: false)
//                                           .showUsersTab
//                                       ? null
//                                       : 0.0,
//                                   child: ShakeTransition(
//                                     axis: Axis.vertical,
//                                     curve: Curves.easeInOut,
//                                     duration: Duration(milliseconds: 800),
//                                     child: AnimatedContainer(
//                                       curve: Curves.easeInOut,
//                                       duration: Duration(milliseconds: 800),
//                                       height: _currentTab == 4
//                                           ? 0.0
//                                           : _showInfo
//                                               ? 50.0
//                                               : 20.0,
//                                       width: _currentTab == 4
//                                           ? 0.0
//                                           : _showInfo
//                                               ? 50.0
//                                               : 20.0,
//                                       decoration: BoxDecoration(
//                                           color: _currentTab == 0 ||
//                                                   ConfigBloc().darkModeOn
//                                               ? Colors.grey[300]
//                                               : Colors.grey[700],
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Material(
//                                         color: Colors.transparent,
//                                         child: IconButton(
//                                             icon: Icon(Icons.create),
//                                             iconSize: 25.0,
//                                             color: !_showInfo
//                                                 ? Colors.transparent
//                                                 : ConfigBloc().darkModeOn ||
//                                                         _currentTab == 0
//                                                     ? Colors.black
//                                                     : Colors.white,
//                                             onPressed: () {
//                                               HapticFeedback.heavyImpact();
//                                               if (mounted) {
//                                                 // setState(() {
//                                                 // _showInfoWidgets = true;
//                                                 Provider.of<UserData>(context,
//                                                         listen: false)
//                                                     .setShortcutBool(true);
//                                                 // });
//                                               }
//                                             }

//                                             //  => Navigator.push(
//                                             //   context,
//                                             //   MaterialPageRoute(
//                                             //     builder: (_) => CreateContents(
//                                             //       user: user,
//                                             //       from: 'Home',
//                                             //     ),
//                                             //   ),
//                                             // ),
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//                 bottomNavigationBar: _user.disabledAccount!
//                     ? const SizedBox.shrink()
//                     : Container(
//                         child: Wrap(
//                           children: [
//                             CupertinoTabBar(
//                               backgroundColor: ConfigBloc().darkModeOn
//                                   ? Color(0xFF1a1a1a)
//                                   : Colors.white,
//                               currentIndex: _currentTab,
//                               onTap: (int index) {
//                                 setState(() {
//                                   _currentTab = index;
//                                 });

//                                 _pageController.animateToPage(
//                                   index,
//                                   duration: Duration(milliseconds: 10),
//                                   curve: Curves.easeIn,
//                                 );
//                               },
//                               activeColor: ConfigBloc().darkModeOn
//                                   ? Colors.white
//                                   : Colors.black,
//                               items: [
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 0
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: const Icon(
//                                           MdiIcons.home,
//                                           size: 25.0,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Home',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 1
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child:
//                                             const Icon(Icons.forum, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Forum',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 2
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child:
//                                             const Icon(Icons.event, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Event',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 3
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: Icon(Icons.search, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Discover',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 4
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: const Icon(Icons.account_circle,
//                                             size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Profile',
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//               Provider.of<UserData>(context, listen: false).shortcutBool
//                   ? Positioned(
//                       bottom: 0.0,
//                       child: Material(
//                         child: GestureDetector(
//                           onTap: () {
//                             if (mounted) {
//                               // setState(() {
//                               // _showInfoWidgets = false;
//                               Provider.of<UserData>(context, listen: false)
//                                   .setShortcutBool(false);
//                               // });
//                             }
//                           },
//                           child: CreateContentsHome(
//                             width: width,
//                           ),
//                         ),
//                       ),
//                     )
//                   : const SizedBox.shrink()
//             ],
//           );
//   }
// }

// class HomeDesktop extends StatefulWidget {
//   final UpdateApp updateApp;
//   final int updateAppVersion;

//   const HomeDesktop(
//       {Key? key, required this.updateApp, required this.updateAppVersion})
//       : super(key: key);

//   @override
//   State<HomeDesktop> createState() => _HomeDesktopState();
// }

// class _HomeDesktopState extends State<HomeDesktop> {
//   late PageController _pageController;
//   int _currentTab = 0;
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   int _activityEventCount = 0;
//   String notificationMsg = '';
//   int _version = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     int? version = Platform.isIOS
//         ? widget.updateApp.updateVersionIos
//         : widget.updateApp.updateVersionAndroid;
//     _version = version!;
//     WidgetsFlutterBinding.ensureInitialized();

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _setUpInvitesActivities();
//       initDynamicLinks();
//     });
//   }

//   Future<void> initDynamicLinks() async {
//     FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//     FirebaseDynamicLinks.instance.getInitialLink();
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       final Uri uri = dynamicLinkData.link;
//       final queryParams = uri.queryParameters;
//       if (queryParams.isNotEmpty) {
//         print("Incoming Link :" + uri.toString());
//         final List<String> link = queryParams.toString().split("_");

//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => ViewSentContent(
//                     contentId: link[1],
//                     contentType: link[0].endsWith('punched')
//                         ? 'Mood Punched'
//                         : link[0].endsWith('forum')
//                             ? 'Forum'
//                             : link[0].endsWith('event')
//                                 ? 'Event'
//                                 : link[0].endsWith('user')
//                                     ? 'User'
//                                     : '')));
//       }
//     });
//   }

//   _setUpInvitesActivities() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     DatabaseService.numEventInviteActivities(currentUserId)
//         .listen((activityEventCount) {
//       if (mounted) {
//         setState(() {
//           _activityEventCount = activityEventCount;
//         });
//       }
//     });
//   }

//   Future<void> _sendMail(String url) async {
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     if (await canLaunchUrl(
//       Uri.parse(url),
//     )) {
//       await (launchUrl(
//         Uri.parse(url),
//       ));
//     } else {
//       Flushbar(
//         margin: EdgeInsets.all(8),
//         boxShadows: [
//           BoxShadow(
//             color: Colors.black,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 3.0,
//           )
//         ],
//         flushbarPosition: FlushbarPosition.TOP,
//         flushbarStyle: FlushbarStyle.FLOATING,
//         titleText: Text(
//           'Sorry',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 22 : 14,
//           ),
//         ),
//         messageText: Text(
//           'Could\'nt launch mail',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 20 : 12,
//           ),
//         ),
//         icon: Icon(
//           Icons.info_outline,
//           size: 28.0,
//           color: Colors.blue,
//         ),
//         duration: Duration(seconds: 3),
//         leftBarIndicatorColor: Colors.blue,
//       )..show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = Provider.of<UserData>(context).currentUserId;
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
//     return widget.updateAppVersion < _version &&
//             widget.updateApp.displayFullUpdate!
//         ? UpdateAppInfo(
//             updateNote: widget.updateApp.updateNote!,
//             version: widget.updateApp.version!,
//           )
//         : Scaffold(
//             backgroundColor:
//                 ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Color(0xFFf2f2f2),
//             body: _user.disabledAccount!
//                 ? ReActivateAccount(user: _user)
//                 : Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Provider.of<UserData>(context, listen: false).user ==
//                                 null
//                             ? const SizedBox.shrink()
//                             : Container(
//                                 decoration: BoxDecoration(
//                                   color: ConfigBloc().darkModeOn
//                                       ? Color(0xFF1a1a1a)
//                                       : Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       offset: Offset(0, 5),
//                                       blurRadius: 8.0,
//                                       spreadRadius: 2.0,
//                                     )
//                                   ],
//                                 ),
//                                 width: 300,
//                                 height: width * 3,
//                                 child: ListView(
//                                   physics: AlwaysScrollableScrollPhysics(),
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Home',
//                                         icon: MdiIcons.home,
//                                         textColor: _currentTab != 0
//                                             ? Colors.grey
//                                             : ConfigBloc().darkModeOn
//                                                 ? Color(0xFFf2f2f2)
//                                                 : Color(0xFF1a1a1a),
//                                         iconColor: _currentTab != 0
//                                             ? Colors.grey
//                                             : ConfigBloc().darkModeOn
//                                                 ? Color(0xFFf2f2f2)
//                                                 : Color(0xFF1a1a1a),
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 0,
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         },
//                                         containerColor: null,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Forum',
//                                           icon: Icons.forum,
//                                           textColor: _currentTab != 1
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 1
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 1,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Event',
//                                           icon: Icons.event,
//                                           textColor: _currentTab != 2
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 2
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 2,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Discover',
//                                           icon: Icons.search,
//                                           textColor: _currentTab != 3
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 3
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 3,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Profile',
//                                           icon: Icons.account_circle,
//                                           textColor: _currentTab != 4
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 4
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 4,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     AnimatedContainer(
//                                       curve: Curves.easeInOut,
//                                       duration: Duration(milliseconds: 800),
//                                       height:
//                                           _activityEventCount != 0 ? 80.0 : 0.0,
//                                       width: width - 10,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[400],
//                                       ),
//                                       child: Material(
//                                           color: Colors.transparent,
//                                           child: ListTile(
//                                             leading: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 8.0),
//                                               child: Icon(
//                                                 Icons.info,
//                                                 color: _activityEventCount != 0
//                                                     ? Colors.black
//                                                     : Colors.transparent,
//                                                 size: 25.0,
//                                               ),
//                                             ),
//                                             trailing: IconButton(
//                                               icon: Icon(Icons.event_available),
//                                               iconSize: 25.0,
//                                               color: _activityEventCount != 0
//                                                   ? Colors.black
//                                                   : Colors.transparent,
//                                               onPressed: () {},
//                                             ),
//                                             title: Text(
//                                                 '${_activityEventCount.toString()}  Event Invitations',
//                                                 style: TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors.black,
//                                                 )),
//                                             subtitle: Text(
//                                               'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
//                                               style: TextStyle(
//                                                 fontSize: 11.0,
//                                                 color: Colors.black,
//                                               ),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             onTap: () => Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       ActivityEventInvitation(
//                                                     currentUserId:
//                                                         Provider.of<UserData>(
//                                                                 context,
//                                                                 listen: false)
//                                                             .currentUserId,
//                                                     count: _activityEventCount,
//                                                   ),
//                                                 )),
//                                           )),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     NoConnection(),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     Divider(color: Colors.grey),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30, bottom: 30),
//                                       child: Text(
//                                         'Bars \nImpression',
//                                         style: TextStyle(
//                                             fontSize: 30,
//                                             fontWeight: FontWeight.w100,
//                                             color: ConfigBloc().darkModeOn
//                                                 ? Colors.white
//                                                 : Colors.black),
//                                       ),
//                                     ),
//                                     Divider(color: Colors.grey),
//                                     Container(
//                                       color: Colors.grey[300],
//                                       child: UpdateInfoMini(
//                                         updateNote:
//                                             widget.updateApp.updateNote!,
//                                         showinfo:
//                                             widget.updateAppVersion < _version
//                                                 ? true
//                                                 : false,
//                                         displayMiniUpdate:
//                                             widget.updateApp.displayMiniUpdate!,
//                                         onPressed: () {
//                                           StoreRedirect.redirect(
//                                             androidAppId:
//                                                 "com.barsOpus.barsImpression",
//                                             iOSAppId: "1610868894",
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 60,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       SuggestionBox()));
//                                         },
//                                         child: Text(
//                                           'Suggestion Box',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () => Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (_) => AboutUs())),
//                                         child: Text(
//                                           'About us',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () => setState(() {
//                                           _sendMail(
//                                               'mailto:support@barsopus.com');
//                                         }),
//                                         child: Text(
//                                           'Contact us',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                         SizedBox(
//                           width: 30,
//                         ),
//                         Container(
//                           width: 600,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 offset: Offset(0, 10),
//                                 blurRadius: 8.0,
//                                 spreadRadius: 2.0,
//                               )
//                             ],
//                           ),
//                           child: PageView(
//                             physics: NeverScrollableScrollPhysics(),
//                             controller: _pageController,
//                             children: <Widget>[
//                               FeedScreenSliver(
//                                 currentUserId: currentUserId,
//                               ),
//                               ForumFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               EventsFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               DiscoverUser(
//                                 isWelcome: false,
//                                 currentUserId: currentUserId,
//                               ),
//                               ProfileScreen(
//                                 currentUserId: currentUserId,
//                                 userId: currentUserId,
//                                 user: _user,
//                               ),
//                             ],
//                             onPageChanged: (int index) {
//                               setState(() {
//                                 _currentTab = index;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           );
//   }
// }

// import 'package:bars/general/pages/discover/discover_user.dart';
// import 'package:bars/general/pages/forum_and_blog/forum/forum_feed.dart';
// import 'package:bars/general/pages/profile/create/create_home.dart';
// import 'package:bars/utilities/local_notification.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:bars/utilities/exports.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:store_redirect/store_redirect.dart';

// class HomeScreen extends StatefulWidget {
//   static final id = 'Home_screen';

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _updateAppVersion = Platform.isIOS ? 17 : 17;
//   String notificationMsg = '';

//   @override
//   void initState() {
//     super.initState();
//     LocalNotificationService.initilize();
//     _configureNotification();
//   }

//   _configureNotification() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     FirebaseMessaging.instance.getToken().then((token) => {
//           usersRef
//               .doc(currentUserId)
//               .update({'androidNotificationToken': token})
//         });

//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       FirebaseMessaging.instance.getInitialMessage().then((event) {
//         if (event != null) {
//           setState(() {
//             notificationMsg =
//                 "${event.notification!.title}  ${event.notification!.body}";
//           });
//         }
//       });

//       FirebaseMessaging.onMessageOpenedApp.listen((event) {
//         setState(() {
//           notificationMsg =
//               "${event.notification!.title}  ${event.notification!.body}";
//         });
//       });
//     }

//     FirebaseMessaging.onMessage.listen((event) {
//       final String recipientId = event.data['recipient'];
//       if (recipientId == currentUserId) {
//         LocalNotificationService.showNotificationOnForeground(event);
//         setState(() {
//           notificationMsg =
//               "${event.notification!.title}  ${event.notification!.body}";
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//       child: FutureBuilder(
//           future: DatabaseService.getUpdateInfo(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return ResponsiveScaffold(child: PostSchimmerSkeleton());
//             }
//             UpdateApp _updateApp = snapshot.data;
//             return NestedScrollView(
//                 headerSliverBuilder: (context, innerBoxScrolled) => [],
//                 body: Responsive.isDesktop(context)
//                     ? HomeDesktop(
//                         updateApp: _updateApp,
//                         updateAppVersion: _updateAppVersion,
//                       )
//                     : HomeMobile(
//                         updateApp: _updateApp,
//                         updateAppVersion: _updateAppVersion,
//                       ));
//           }),
//     );
//   }
// }

// class HomeMobile extends StatefulWidget {
//   final UpdateApp updateApp;
//   final int updateAppVersion;

//   const HomeMobile(
//       {Key? key, required this.updateApp, required this.updateAppVersion})
//       : super(key: key);

//   @override
//   State<HomeMobile> createState() => _HomeMobileState();
// }

// class _HomeMobileState extends State<HomeMobile> {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   int _activityEventCount = 0;
//   int _currentTab = 0;
//   late PageController _pageController;
//   int _version = 0;
//   bool _showInfo = false;
//   // bool _showInfoWidgets = false;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();

//     int? version = Platform.isIOS
//         ? widget.updateApp.updateVersionIos
//         : widget.updateApp.updateVersionAndroid;
//     _version = version!;
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     _setUpInvitesActivities();
//     _setUpLastActiveDate();

//     initDynamicLinks();
//   });
//   __setShowDelsyInfo();
// }

//   __setShowDelsyInfo() async {
//     if (!_showInfo) {
//       Timer(Duration(seconds: 3), () {
//         if (mounted) {
//           // setState(() {
//           _showInfo = true;
//           // });
//           __setShowInfo();
//         }
//       });
//     }
//   }

//   __setShowInfo() async {
//     if (_showInfo) {
//       Timer(Duration(seconds: 3), () {
//         if (mounted) {
//           // setState(() {
//           _showInfo = false;
//           // });
//         }
//       });
//     }
//   }

//   Future<void> initDynamicLinks() async {
//     FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//     FirebaseDynamicLinks.instance.getInitialLink(); //
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       final List<String> link = dynamicLinkData.link.path.toString().split("_");

//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => ViewSentContent(
//                   contentId: link[1],
//                   contentType: link[0].endsWith('punched')
//                       ? 'Mood Punched'
//                       : link[0].endsWith('forum')
//                           ? 'Forum'
//                           : link[0].endsWith('event')
//                               ? 'Event'
//                               : link[0].endsWith('user')
//                                   ? 'User'
//                                   : '')));
//     }).onError((error) {});
//   }

//   _setUpLastActiveDate() {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     usersRef
//         .doc(currentUserId)
//         .update({'professionalVideo1': DateTime.now().toString()});
//   }

//   _setUpInvitesActivities() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     DatabaseService.numEventInviteActivities(currentUserId)
//         .listen((activityEventCount) {
//       if (mounted) {
//         setState(() {
//           _activityEventCount = activityEventCount;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = Provider.of<UserData>(context).currentUserId;
//     final AccountHolder user = Provider.of<UserData>(context).user!;
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
//     return widget.updateAppVersion < _version &&
//             widget.updateApp.displayFullUpdate!
//         ? UpdateAppInfo(
//             updateNote: widget.updateApp.updateNote!,
//             version: widget.updateApp.version!,
//           )
//         : Stack(
//             alignment: FractionalOffset.center,
//             children: [
//               Scaffold(
//                 body: Container(
//                   width: width,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         offset: Offset(0, 10),
//                         blurRadius: 8.0,
//                         spreadRadius: 2.0,
//                       )
//                     ],
//                   ),
//                   child: _user.disabledAccount!
//                       ? ReActivateAccount(user: _user)
//                       :
//                       // Stack(
//                       //     // alignment: FractionalOffset.center,
//                       //     children: [
//                       Container(
//                           height: double.infinity,
//                           width: double.infinity,
//                           child: PageView(
//                             physics: NeverScrollableScrollPhysics(),
//                             controller: _pageController,
//                             children: <Widget>[
//                               FeedScreenSliver(
//                                 currentUserId: currentUserId,
//                               ),
//                               ForumFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               EventsFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               DiscoverUser(
//                                 currentUserId: currentUserId,
//                                 isWelcome: false,
//                               ),
//                               ProfileScreen(
//                                 currentUserId: currentUserId,
//                                 userId: currentUserId,
//                                 user: user,
//                               ),
//                             ],
//                             onPageChanged: (int index) {
//                               setState(() {
//                                 _currentTab = index;
//                               });
//                             },
//                           ),
//                         ),

//                   //   ],
//                   // ),
//                 ),
//                 bottomNavigationBar: _user.disabledAccount!
//                     ? const SizedBox.shrink()
//                     : Container(
//                         child: Wrap(
//                           children: [
//                             CupertinoTabBar(
//                               backgroundColor: ConfigBloc().darkModeOn
//                                   ? Color(0xFF1a1a1a)
//                                   : Colors.white,
//                               currentIndex: _currentTab,
//                               onTap: (int index) {
//                                 setState(() {
//                                   _currentTab = index;
//                                 });

//                                 _pageController.animateToPage(
//                                   index,
//                                   duration: Duration(milliseconds: 10),
//                                   curve: Curves.easeIn,
//                                 );
//                               },
//                               activeColor: ConfigBloc().darkModeOn
//                                   ? Colors.white
//                                   : Colors.black,
//                               items: [
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 0
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: const Icon(
//                                           MdiIcons.home,
//                                           size: 25.0,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Home',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 1
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child:
//                                             const Icon(Icons.forum, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Forum',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 2
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child:
//                                             const Icon(Icons.event, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Event',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 3
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: Icon(Icons.search, size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Discover',
//                                 ),
//                                 BottomNavigationBarItem(
//                                   icon: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 0.0),
//                                           child: AnimatedContainer(
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             height: 2,
//                                             curve: Curves.easeInOut,
//                                             width: 30.0,
//                                             decoration: BoxDecoration(
//                                               color: _currentTab == 4
//                                                   ? Colors.blue
//                                                   : Colors.transparent,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           )),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 1.0),
//                                         child: const Icon(Icons.account_circle,
//                                             size: 25.0),
//                                       ),
//                                     ],
//                                   ),
//                                   label: 'Profile',
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//               Positioned(
//                   bottom: 7,
//                   child: UpdateInfoMini(
//                     updateNote: widget.updateApp.updateNote!,
//                     showinfo: widget.updateAppVersion < _version ? true : false,
//                     displayMiniUpdate: widget.updateApp.displayMiniUpdate!,
//                     onPressed: () {
//                       StoreRedirect.redirect(
//                         androidAppId: "com.barsOpus.barsImpression",
//                         iOSAppId: "1610868894",
//                       );
//                     },
//                   )),
//               Positioned(bottom: 7, child: NoConnection()),
//               Positioned(
//                 bottom: 7,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: AnimatedContainer(
//                     curve: Curves.easeInOut,
//                     duration: Duration(milliseconds: 800),
//                     height: _activityEventCount != 0 ? 80.0 : 0.0,
//                     width: width - 10,
//                     decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Material(
//                         color: Colors.transparent,
//                         child: ListTile(
//                           leading: Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Icon(
//                               Icons.info,
//                               color: Colors.black,
//                               size: 25.0,
//                             ),
//                           ),
//                           trailing: IconButton(
//                             icon: Icon(Icons.event_available),
//                             iconSize: 25.0,
//                             color: Colors.black,
//                             onPressed: () {},
//                           ),
//                           title: Text(
//                               '${_activityEventCount.toString()}  Event Invitations',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 color: Colors.black,
//                               )),
//                           subtitle: Text(
//                             'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
//                             style: TextStyle(
//                               fontSize: 11.0,
//                               color: Colors.black,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ActivityEventInvitation(
//                                   currentUserId: Provider.of<UserData>(context,
//                                           listen: false)
//                                       .currentUserId,
//                                   count: _activityEventCount,
//                                 ),
//                               )),
//                         )),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 30,
//                 // right: 5,
//                 child: GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     if (mounted) {
//                       // setState(() {
//                       // _showInfoWidgets = true;
//                       Provider.of<UserData>(context, listen: false)
//                           .setShortcutBool(true);
//                       // });
//                     }
//                   },
//                   child: AnimatedContainer(
//                     curve: Curves.easeInOut,
//                     duration: Duration(milliseconds: 400),
//                     height: Provider.of<UserData>(context, listen: false)
//                             .showUsersTab
//                         ? null
//                         : 0.0,
//                     width: Provider.of<UserData>(context, listen: false)
//                             .showUsersTab
//                         ? null
//                         : 0.0,
//                     child: ShakeTransition(
//                       axis: Axis.vertical,
//                       curve: Curves.easeInOut,
//                       duration: Duration(milliseconds: 800),
//                       child: AnimatedContainer(
//                         curve: Curves.easeInOut,
//                         duration: Duration(milliseconds: 800),
//                         height: _currentTab == 4
//                             ? 0.0
//                             : _showInfo
//                                 ? 50.0
//                                 : 20.0,
//                         width: _currentTab == 4
//                             ? 0.0
//                             : _showInfo
//                                 ? 50.0
//                                 : 20.0,
//                         decoration: BoxDecoration(
//                             color: _currentTab == 0 || ConfigBloc().darkModeOn
//                                 ? Colors.grey[300]
//                                 : Colors.grey[700],
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: IconButton(
//                               icon: Icon(Icons.create),
//                               iconSize: 25.0,
//                               color: !_showInfo
//                                   ? Colors.transparent
//                                   : ConfigBloc().darkModeOn || _currentTab == 0
//                                       ? Colors.black
//                                       : Colors.white,
//                               onPressed: () {
//                                 HapticFeedback.heavyImpact();
//                                 if (mounted) {
//                                   // setState(() {
//                                   // _showInfoWidgets = true;
//                                   Provider.of<UserData>(context, listen: false)
//                                       .setShortcutBool(true);
//                                   // });
//                                 }
//                               }

//                               //  => Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (_) => CreateContents(
//                               //       user: user,
//                               //       from: 'Home',
//                               //     ),
//                               //   ),
//                               // ),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Provider.of<UserData>(context, listen: false).shortcutBool
//                   ? Positioned(
//                       bottom: 0.0,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (mounted) {
//                             // setState(() {
//                             // _showInfoWidgets = false;
//                             Provider.of<UserData>(context, listen: false)
//                                 .setShortcutBool(false);
//                             // });
//                           }
//                         },
//                         child: CreateContentsHome(
//                           width: width,
//                         ),
//                       ),
//                     )
//                   : const SizedBox.shrink()
//             ],
//           );
//   }
// }

// class HomeDesktop extends StatefulWidget {
//   final UpdateApp updateApp;
//   final int updateAppVersion;

//   const HomeDesktop(
//       {Key? key, required this.updateApp, required this.updateAppVersion})
//       : super(key: key);

//   @override
//   State<HomeDesktop> createState() => _HomeDesktopState();
// }

// class _HomeDesktopState extends State<HomeDesktop> {
//   late PageController _pageController;
//   int _currentTab = 0;
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   int _activityEventCount = 0;
//   String notificationMsg = '';
//   int _version = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     int? version = Platform.isIOS
//         ? widget.updateApp.updateVersionIos
//         : widget.updateApp.updateVersionAndroid;
//     _version = version!;
//     WidgetsFlutterBinding.ensureInitialized();

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _setUpInvitesActivities();
//       initDynamicLinks();
//     });
//   }

//   Future<void> initDynamicLinks() async {
//     FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//     FirebaseDynamicLinks.instance.getInitialLink();
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       final Uri uri = dynamicLinkData.link;
//       final queryParams = uri.queryParameters;
//       if (queryParams.isNotEmpty) {
//         print("Incoming Link :" + uri.toString());
//         final List<String> link = queryParams.toString().split("_");

//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => ViewSentContent(
//                     contentId: link[1],
//                     contentType: link[0].endsWith('punched')
//                         ? 'Mood Punched'
//                         : link[0].endsWith('forum')
//                             ? 'Forum'
//                             : link[0].endsWith('event')
//                                 ? 'Event'
//                                 : link[0].endsWith('user')
//                                     ? 'User'
//                                     : '')));
//       }
//     });
//   }

//   _setUpInvitesActivities() async {
//     final String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     DatabaseService.numEventInviteActivities(currentUserId)
//         .listen((activityEventCount) {
//       if (mounted) {
//         setState(() {
//           _activityEventCount = activityEventCount;
//         });
//       }
//     });
//   }

//   Future<void> _sendMail(String url) async {
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     if (await canLaunchUrl(
//       Uri.parse(url),
//     )) {
//       await (launchUrl(
//         Uri.parse(url),
//       ));
//     } else {
//       Flushbar(
//         margin: EdgeInsets.all(8),
//         boxShadows: [
//           BoxShadow(
//             color: Colors.black,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 3.0,
//           )
//         ],
//         flushbarPosition: FlushbarPosition.TOP,
//         flushbarStyle: FlushbarStyle.FLOATING,
//         titleText: Text(
//           'Sorry',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 22 : 14,
//           ),
//         ),
//         messageText: Text(
//           'Could\'nt launch mail',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 20 : 12,
//           ),
//         ),
//         icon: Icon(
//           Icons.info_outline,
//           size: 28.0,
//           color: Colors.blue,
//         ),
//         duration: Duration(seconds: 3),
//         leftBarIndicatorColor: Colors.blue,
//       )..show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = Provider.of<UserData>(context).currentUserId;
//     final double width = Responsive.isDesktop(
//       context,
//     )
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
//     return widget.updateAppVersion < _version &&
//             widget.updateApp.displayFullUpdate!
//         ? UpdateAppInfo(
//             updateNote: widget.updateApp.updateNote!,
//             version: widget.updateApp.version!,
//           )
//         : Scaffold(
//             backgroundColor:
//                 ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Color(0xFFf2f2f2),
//             body: _user.disabledAccount!
//                 ? ReActivateAccount(user: _user)
//                 : Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Provider.of<UserData>(context, listen: false).user ==
//                                 null
//                             ? const SizedBox.shrink()
//                             : Container(
//                                 decoration: BoxDecoration(
//                                   color: ConfigBloc().darkModeOn
//                                       ? Color(0xFF1a1a1a)
//                                       : Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       offset: Offset(0, 5),
//                                       blurRadius: 8.0,
//                                       spreadRadius: 2.0,
//                                     )
//                                   ],
//                                 ),
//                                 width: 300,
//                                 height: width * 3,
//                                 child: ListView(
//                                   physics: AlwaysScrollableScrollPhysics(),
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                         iconSize: 35,
//                                         padding: 5,
//                                         raduis: 100,
//                                         arrowColor: Colors.transparent,
//                                         title: '  Home',
//                                         icon: MdiIcons.home,
//                                         textColor: _currentTab != 0
//                                             ? Colors.grey
//                                             : ConfigBloc().darkModeOn
//                                                 ? Color(0xFFf2f2f2)
//                                                 : Color(0xFF1a1a1a),
//                                         iconColor: _currentTab != 0
//                                             ? Colors.grey
//                                             : ConfigBloc().darkModeOn
//                                                 ? Color(0xFFf2f2f2)
//                                                 : Color(0xFF1a1a1a),
//                                         onPressed: () {
//                                           _pageController.animateToPage(
//                                             _currentTab = 0,
//                                             duration:
//                                                 Duration(milliseconds: 500),
//                                             curve: Curves.easeInOut,
//                                           );
//                                         },
//                                         containerColor: null,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Forum',
//                                           icon: Icons.forum,
//                                           textColor: _currentTab != 1
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 1
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 1,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Event',
//                                           icon: Icons.event,
//                                           textColor: _currentTab != 2
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 2
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 2,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Discover',
//                                           icon: Icons.search,
//                                           textColor: _currentTab != 3
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 3
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 3,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(20),
//                                       child: UserWebsite(
//                                           containerColor: null,
//                                           iconSize: 35,
//                                           padding: 5,
//                                           raduis: 100,
//                                           arrowColor: Colors.transparent,
//                                           title: '  Profile',
//                                           icon: Icons.account_circle,
//                                           textColor: _currentTab != 4
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           iconColor: _currentTab != 4
//                                               ? Colors.grey
//                                               : ConfigBloc().darkModeOn
//                                                   ? Color(0xFFf2f2f2)
//                                                   : Color(0xFF1a1a1a),
//                                           onPressed: () {
//                                             _pageController.animateToPage(
//                                               _currentTab = 4,
//                                               duration:
//                                                   Duration(milliseconds: 500),
//                                               curve: Curves.easeInOut,
//                                             );
//                                           }),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     AnimatedContainer(
//                                       curve: Curves.easeInOut,
//                                       duration: Duration(milliseconds: 800),
//                                       height:
//                                           _activityEventCount != 0 ? 80.0 : 0.0,
//                                       width: width - 10,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[400],
//                                       ),
//                                       child: Material(
//                                           color: Colors.transparent,
//                                           child: ListTile(
//                                             leading: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 8.0),
//                                               child: Icon(
//                                                 Icons.info,
//                                                 color: _activityEventCount != 0
//                                                     ? Colors.black
//                                                     : Colors.transparent,
//                                                 size: 25.0,
//                                               ),
//                                             ),
//                                             trailing: IconButton(
//                                               icon: Icon(Icons.event_available),
//                                               iconSize: 25.0,
//                                               color: _activityEventCount != 0
//                                                   ? Colors.black
//                                                   : Colors.transparent,
//                                               onPressed: () {},
//                                             ),
//                                             title: Text(
//                                                 '${_activityEventCount.toString()}  Event Invitations',
//                                                 style: TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors.black,
//                                                 )),
//                                             subtitle: Text(
//                                               'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
//                                               style: TextStyle(
//                                                 fontSize: 11.0,
//                                                 color: Colors.black,
//                                               ),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             onTap: () => Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       ActivityEventInvitation(
//                                                     currentUserId:
//                                                         Provider.of<UserData>(
//                                                                 context,
//                                                                 listen: false)
//                                                             .currentUserId,
//                                                     count: _activityEventCount,
//                                                   ),
//                                                 )),
//                                           )),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     NoConnection(),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     Divider(color: Colors.grey),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30, bottom: 30),
//                                       child: Text(
//                                         'Bars \nImpression',
//                                         style: TextStyle(
//                                             fontSize: 30,
//                                             fontWeight: FontWeight.w100,
//                                             color: ConfigBloc().darkModeOn
//                                                 ? Colors.white
//                                                 : Colors.black),
//                                       ),
//                                     ),
//                                     Divider(color: Colors.grey),
//                                     Container(
//                                       color: Colors.grey[300],
//                                       child: UpdateInfoMini(
//                                         updateNote:
//                                             widget.updateApp.updateNote!,
//                                         showinfo:
//                                             widget.updateAppVersion < _version
//                                                 ? true
//                                                 : false,
//                                         displayMiniUpdate:
//                                             widget.updateApp.displayMiniUpdate!,
//                                         onPressed: () {
//                                           StoreRedirect.redirect(
//                                             androidAppId:
//                                                 "com.barsOpus.barsImpression",
//                                             iOSAppId: "1610868894",
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 60,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       SuggestionBox()));
//                                         },
//                                         child: Text(
//                                           'Suggestion Box',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () => Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (_) => AboutUs())),
//                                         child: Text(
//                                           'About us',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 30.0, left: 30),
//                                       child: GestureDetector(
//                                         onTap: () => setState(() {
//                                           _sendMail(
//                                               'mailto:support@barsopus.com');
//                                         }),
//                                         child: Text(
//                                           'Contact us',
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                         SizedBox(
//                           width: 30,
//                         ),
//                         Container(
//                           width: 600,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 offset: Offset(0, 10),
//                                 blurRadius: 8.0,
//                                 spreadRadius: 2.0,
//                               )
//                             ],
//                           ),
//                           child: PageView(
//                             physics: NeverScrollableScrollPhysics(),
//                             controller: _pageController,
//                             children: <Widget>[
//                               FeedScreenSliver(
//                                 currentUserId: currentUserId,
//                               ),
//                               ForumFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               EventsFeed(
//                                 currentUserId: currentUserId,
//                               ),
//                               DiscoverUser(
//                                 isWelcome: false,
//                                 currentUserId: currentUserId,
//                               ),
//                               ProfileScreen(
//                                 currentUserId: currentUserId,
//                                 userId: currentUserId,
//                                 user: _user,
//                               ),
//                             ],
//                             onPageChanged: (int index) {
//                               setState(() {
//                                 _currentTab = index;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           );
//   }
// }
