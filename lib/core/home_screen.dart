// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bars/features/events/event_room_and_chat/presentation/screens/chats.dart';
import 'package:bars/features/gemini_ai/presentation/widgets/hope_action.dart';

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
  final int _updateAppVersion = Platform.isIOS ? 27 : 27;
  String notificationMsg = '';
  // bool _isFecthing = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setUpactivityCount();
      _configureNotification();
      initDynamicLinks();
      // _setBrandTarget();
      // _new();
      // _updateFields();
    });
    // if (Platform.isIOS) showAnalytics();
  }

  // showAnalytics() async {
  //   // Check the tracking authorization status
  //   final TrackingStatus status =
  //       await AppTrackingTransparency.trackingAuthorizationStatus;

  //   // If the authorization status has not been determined, show the bottom sheet
  //   if (status == TrackingStatus.notDetermined) {
  //     showTrackingExplanationBottomSheet(context);
  //   } else {
  //     // Otherwise, proceed with initializing Firebase Analytics
  //     initFirebaseAnalytics(status);
  //   }
  // }

  // Future<void> initFirebaseAnalytics(TrackingStatus status) async {
  //   FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  //   // If the authorization status is not determined, request authorization
  //   if (status == TrackingStatus.notDetermined) {
  //     status = await AppTrackingTransparency.requestTrackingAuthorization();
  //   }

  //   // Use the updated status after the request authorization
  //   if (status == TrackingStatus.authorized) {
  //     // User has authorized tracking
  //     await analytics.setAnalyticsCollectionEnabled(true);

  //     // // Log an event to signify that analytics has started
  //     // await analytics.logEvent(
  //     //   name: 'analytics_enabled',
  //     //   parameters: <String, dynamic>{
  //     //     'enabled': true,
  //     //   },
  //     // );
  //   } else {
  //     // If the user has denied tracking or it is restricted/disallowed for some reason,
  //     // you might want to disable analytics collection or handle this case accordingly
  //     await analytics.setAnalyticsCollectionEnabled(false);
  //   }
  // }

  // Future<void> showTrackingExplanationBottomSheet(BuildContext context) async {
  //   await showModalBottomSheet(
  //     isDismissible: false,
  //     enableDrag: false,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext context) {
  //       var bodyMeduim = TextStyle(
  //           fontSize: ResponsiveHelper.responsiveFontSize(
  //             context,
  //             14,
  //           ),
  //           color: Colors.white);
  //       var bodyLarge = TextStyle(
  //           fontSize: ResponsiveHelper.responsiveFontSize(
  //             context,
  //             16,
  //           ),
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white);
  //       return Container(
  //         padding: EdgeInsets.all(26),
  //         decoration: BoxDecoration(
  //           color: Color(0xFF1a1a1a),
  //           borderRadius: BorderRadius.circular(30),
  //         ),

  //         height: ResponsiveHelper.responsiveHeight(
  //             context, 500), // Adjust the height as needed
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Icon(
  //               Icons.data_exploration_outlined,
  //               color: Colors.white,
  //               size: ResponsiveHelper.responsiveHeight(context, 40.0),
  //             ),
  //             const SizedBox(height: 5),
  //             ShakeTransition(
  //               child: Text(
  //                 'Help Improve\nBars Impression',
  //                 style: TextStyle(
  //                     fontSize:
  //                         ResponsiveHelper.responsiveFontSize(context, 20),
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             RichText(
  //                              textScaler: MediaQuery.of(context).textScaler,

  //               text: TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     text:
  //                         "Allowing tracking helps us to improve the app by understanding how it is used. which leads to better features and performance improvements.",
  //                     style: bodyMeduim,
  //                   ),
  //                   TextSpan(
  //                     text: "\n\nYour privacy is important to us.",
  //                     style: bodyLarge,
  //                   ),
  //                   TextSpan(
  //                     text:
  //                         "\n - We only collect anonymous usage statistics and performance data.\n- We never sell your data or use it for any purpose other than improving Bars Impression.\n- You can change your decision at any time in the app settings.\n\nThank you for helping us make Bars Impression better for everyone!.",
  //                     style: bodyMeduim,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Text(
  //             //   ' \n\n',
  //             //   style: TextStyle(
  //             //       fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
  //             //       color: Colors.white),
  //             // ),
  //             const SizedBox(height: 30),
  //             // Spacer(),
  //             MiniCircularProgressButton(
  //               text: 'Continue',
  //               onPressed: () {
  //                 // Close the bottom sheet and request tracking permission
  //                 Navigator.pop(context);
  //                 AppTrackingTransparency.requestTrackingAuthorization().then(
  //                   (status) {
  //                     initFirebaseAnalytics(status);
  //                   },
  //                 );
  //               },
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  _updateMistakFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_professsional');

    // Start a new batch
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        // Check if "subaccount_id" field exists
        if (data.containsKey('contacts')) {
          // Get the value of "subaccount_id"
          // String? subaccountId = data['contacts'];

          // // Remove the old "subaccount_id" field
          // data.remove('subaccount_id');

          // // Set the new "subaccountId" field with the value
          data['contacts'] = [];

          // Add the updated data to the batch
          batch.set(doc.reference, data);
        }
      }
    });

    // Commit the batch
    await batch.commit();
  }

  void updateProfessionalContacts2() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final QuerySnapshot professionalSnapshot =
        await _firestore.collection('user_professsional').get();

    for (var professionalDoc in professionalSnapshot.docs) {
      final String userId = professionalDoc.id;
      final DocumentSnapshot userProfessionalDoc = professionalDoc;
      final Map<String, dynamic>? professionalData =
          userProfessionalDoc.data() as Map<String, dynamic>?;

      // Check if contacts is empty or field does not exist
      if (professionalData != null &&
          (professionalData['contacts'] == null ||
              professionalData['contacts'].isEmpty)) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          final String email = userData?['email'] ?? '';

          // Create the email PortfolioContactModel
          final emailContactModel = PortfolioContactModel(
            id: UniqueKey().toString(),
            email: email,
            number:
                '', // Assuming '0' is the default value for the number field.
          );

          // Update the user_professional document with the new contact information
          await _firestore.collection('user_professsional').doc(userId).update({
            'contacts': FieldValue.arrayUnion([emailContactModel.toJson()])
          });
        }
      }
    }
  }

  void updateProfessionalContacts() async {
    final _firestore = FirebaseFirestore.instance;

    final professionalSnapshot =
        await _firestore.collection('user_professsional').get();

    for (var professionalDoc in professionalSnapshot.docs) {
      final userId = professionalDoc.id;
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        final String email = userData?['email'] ?? '';
        // final String contactString = userData?['contacts'] ?? '';
        // int contactNumber;

        // try {
        //   contactNumber = int.parse(contactString);
        // } catch (e) {
        //   // If the contact is not a number, you might want to log this information or handle it.
        //   contactNumber =
        //       0; // Or any default/fallback value you consider appropriate.
        // }

        // For the email PortfolioContactModel
        final emailContactModel = PortfolioContactModel(
          id: UniqueKey().toString(),
          email: email,
          number: '', // Assuming '0' is the default value for the number field.
        );

        // // For the number PortfolioContactModel
        // final numberContactModel = PortfolioContactModel(
        //   id: UniqueKey().toString(),
        //   email:
        //       '', // Assuming empty string is the default value for the email field.
        //   number: contactNumber,
        // );

        // Update the user_professional document with the new contact information
        await _firestore.collection('user_professsional').doc(userId).update({
          'contacts': FieldValue.arrayUnion([
            emailContactModel.toJson(),
            // numberContactModel.toJson(),
          ])
        });
      }
    }
  }

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

  // Future<void> initializeData() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference sourceRef =
  //       _firestore.collection('user_general_settings');
  //   CollectionReference targetRef = _firestore.collection('new_followers');o

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
        firestore.collection('user_professsional');

    // Start a new batch
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        // Check if "id" field exists
        if (data.containsKey('id')) {
          // Get the value of "id"
          String? newuserId = data['id'];

          // Remove the old "id" field
          data.remove('id');

          // Set the new "userId" field with the value
          data['userId'] = newuserId;

          // Add the updated data to the batch
          batch.set(doc.reference, data);
        } else if (data.containsKey('userId')) {
          // Skip the document if "id" field doesn't exist but "userId" field does
          print(
              'Skipping document: ${doc.id} because "id" field doesn\'t exist but "userId" field does.');
          continue;
        } else {
          // Skip the document if neither "id" nor "userId" field exists
          print(
              'Skipping document: ${doc.id} because neither "id" nor "userId" field exists.');
          continue;
        }
      }
    }

    // Commit the batch
    await batch.commit();
  }

  // _updateFields() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference userProfessionalCollection =
  //       firestore.collection('user_professsional');

  //   // Start a new batch
  //   WriteBatch batch = firestore.batch();

  //   QuerySnapshot querySnapshot = await userProfessionalCollection.get();
  //   querySnapshot.docs.forEach((doc) {
  //     Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

  //     // Only proceed if data is not null
  //     if (data != null) {
  //       // Check if "subaccount_id" field exists
  //       if (data.containsKey('id')) {
  //         // Get the value of "subaccount_id"
  //         String? newuserId = data['id'];

  //         // Remove the old "subaccount_id" field
  //         data.remove('id');

  //         // Set the new "newuserId" field with the value
  //         data['userId'] = newuserId;

  //         // Add the updated data to the batch
  //         batch.set(doc.reference, data);
  //       }
  //     }
  //   });

  //   // Commit the batch
  //   await batch.commit();
  // }

  _deleteFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_author');

    // Start a new batch
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    for (var doc in querySnapshot.docs) {
      // Prepare the updates with FieldValue.delete()
      Map<String, dynamic> updates = {};
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Check if the fields exist before deletion
      if (data.containsKey('disableAdvice')) {
        updates['disableAdvice'] = FieldValue.delete();
      }
      if (data.containsKey('hideAdvice')) {
        updates['hideAdvice'] = FieldValue.delete();
      }

      // Only update if there are fields to delete
      if (updates.isNotEmpty) {
        batch.update(doc.reference, updates);
      }
    }

    // Commit the batch
    await batch.commit();
  }

  _createFieldMultiples() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_author');

    // Start a new batch
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        // Initialize updateData as Map<String, dynamic>
        Map<String, dynamic> updateData = {};
        if (!data.containsKey('disableChat')) {
          // Add "disableChat" field if it does not exist
          updateData['disableChat'] = false;
        }
        // if (!data.containsKey('hideAdvice')) {
        //   // Add "hideAdvice" field if it does not exist
        //   updateData['hideAdvice'] = false;
        // }

        // If there are fields to update, add the update to the batch
        if (updateData.isNotEmpty) {
          batch.update(doc.reference, updateData);
        }
      }
    });

    // Commit the batch
    await batch.commit();
  }

  _updateOldFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_author');

// Start a new batch
    WriteBatch batch = firestore.batch();
// final Random random = Random();

// print(' dd  ' + random.nextDouble().toString());

    QuerySnapshot querySnapshot = await userProfessionalCollection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Only proceed if data is not null
      if (data != null) {
        if (!data.containsKey('profileHandle')) {
          if (data['profileHandle'] == 'Music_Video_Director') {
            data['profileHandle'] = 'Videographer';
            batch.update(doc.reference, data);
          }
        }
      }
    });

// Commit the batch
    await batch.commit();
  }

  _createFields() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userProfessionalCollection =
        firestore.collection('user_professsional');

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
        if (!data.containsKey('improvemenSuggestion')) {
          // Create the "subaccount_id" field without overwriting existing fields
          data['improvemenSuggestion'] = '';
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

  _newLink() async {
    final _firestore = FirebaseFirestore.instance;
    CollectionReference targetRef = _firestore.collection('user_author');

    // Get documents from target collection
    QuerySnapshot targetSnapshot = await targetRef.get();

    // Initialize Firestore batch
    WriteBatch batch = _firestore.batch();

    for (var targetDoc in targetSnapshot.docs) {
      DocumentReference sourceDocRef = targetRef.doc(targetDoc.id);
      DocumentReference sourceRef =
          _firestore.collection('user_professsional').doc(targetDoc.id);

      // Check if a document with the same ID exists in the source collection
      DocumentSnapshot sourceDoc = await sourceDocRef.get();
      if (sourceDoc.exists) {
        // Create dynamic link
        String dynamicLink = await _createDynamicLink(sourceDoc);

        // Write the dynamic link to the target document
        batch.update(targetDoc.reference, {'dynamicLink': dynamicLink});
        batch.update(sourceRef, {'dynamicLink': dynamicLink});
        // SetOptions(merge: true));
      } else {
        print('No document with ID ${targetDoc.id} in source collection');
      }
    }

    await batch.commit();
  }

  // _newLink() async {
  //   final _firestore = FirebaseFirestore.instance;
  //   CollectionReference targetRef = _firestore.collection('user_author');

  //   // Get documents from target collection
  //   QuerySnapshot targetSnapshot = await targetRef.get();

  //   // Initialize Firestore batch
  //   WriteBatch batch = _firestore.batch();

  //   for (var targetDoc in targetSnapshot.docs) {
  //     DocumentReference sourceDocRef = targetRef.doc(targetDoc.id);
  //     DocumentReference sourceRef =
  //         _firestore.collection('user_professional').doc(targetDoc.id);

  //     // Check if a document with the same ID exists in the source collection
  //     DocumentSnapshot sourceDoc = await sourceDocRef.get();
  //     if (sourceDoc.exists) {
  //       // Check if the document does not have a dynamic link
  //       if (!targetDoc.data()!.conta('dynamicLink')) {
  //         // Create dynamic link
  //         String dynamicLink = await _createDynamicLink(sourceDoc);

  //         // Write the dynamic link to the target document
  //         batch.update(targetDoc.reference, {'dynamicLink': dynamicLink});
  //         batch.update(sourceRef, {'dynamicLink': dynamicLink});
  //       }
  //     } else {
  //       print('No document with ID ${targetDoc.id} in source collection');
  //     }
  //   }

  //   await batch.commit();
  // }

  Future<String> _createDynamicLink(DocumentSnapshot sourceDoc) async {
    String profileImageUrl = sourceDoc.get('profileImageUrl');
    String userName = sourceDoc.get('userName');
    String bio = sourceDoc.get('bio');
    String userId = sourceDoc.id;

    String link = await DatabaseService.myDynamicLink(
      profileImageUrl, userName, bio,
      'https://www.barsopus.com/user_$userId',
      // 'https://www.barsopus.com/user_$userId',
    );

    return link;
  }

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

  _new2() async {
    // try {
    final _firestore = FirebaseFirestore.instance;
    CollectionReference targetRef = _firestore.collection('user_professsional');
    CollectionReference sourceRef =
        _firestore.collection('user_location_settings');

    // Get documents from target collection
    QuerySnapshot targetSnapshot = await targetRef.get();

    // Initialize Firestore batch
    WriteBatch batch = _firestore.batch();

    for (var targetDoc in targetSnapshot.docs) {
      DocumentReference sourceDocRef = sourceRef.doc(targetDoc.id);

      // Check if a document with the same ID exists in the source collection
      DocumentSnapshot sourceDoc = await sourceDocRef.get();
      if (sourceDoc.exists) {
        Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          // print('Data for document ${sourceDoc.id}: $data'); // ADD THIS LINE

          var someFields = {
            'transferRecepientId': data.containsKey('transferRecepientId')
                ? data['transferRecepientId']
                : null,
            // 'city': data.containsKey('city') ? data['city'] : null,
            // 'country': data.containsKey('country') ? data['country'] : null,
            // 'verified': false,
          };

          print('Fields to be copied: $someFields'); // ADD THIS LINE

          // Write the new map to the target document
          batch.set(targetDoc.reference, someFields, SetOptions(merge: true));
        } else {
          print('No data for document ${sourceDoc.id}'); // ADD THIS LINE
        }
      } else {
        print(
            'No document with ID ${targetDoc.id} in source collection'); // ADD THIS LINE
      }
    }

    await batch.commit();
  }

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
  _new() async {
    try {
      final _firestore = FirebaseFirestore.instance;
      CollectionReference targetRef = _firestore.collection('new_userRating');
      CollectionReference sourceRef =
          _firestore.collection('user_professsional');

      // Get documents from source collection
      QuerySnapshot querySnapshot = await sourceRef.get();

      // Initialize Firestore batch
      WriteBatch batch = _firestore.batch();

      querySnapshot.docs.forEach((doc) {
        // Create a new map that only contains the fields you're interested in
        var someFields = {
          ' userId': doc.id,
          'oneStar': 0,
          'twoStar': 0,
          'threeStar': 0,
          'fourStar': 0,
          'fiveStar': 0,
        };

        // Write the new map to the target document
        batch.set(targetRef.doc(doc.id), someFields);
      });

      await batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _setBrandTarget() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   _provider.setFlorenceActive(false);

  //   // Fetch the user data using whatever method you need
  //   var userSnapshot =
  //       await new_userBrandIfoRef.doc(_provider.currentUserId).get();

  //   // Check if the snapshot contains data and if the user has a private account
  //   if (userSnapshot.exists) {
  //     CreativeBrandTargetModel user =
  //         CreativeBrandTargetModel.fromDoc(userSnapshot);

  //     // Set state with the new user data to update the UI
  //     if (mounted) {
  //       setState(() {
  //         _provider.setBrandTarget(user);
  //         _isFecthing = false;
  //       });
  //     }
  //   } else {
  //     // Handle the case where the user data does not exist
  //     if (mounted) {
  //       setState(() {
  //         _isFecthing = false;
  //       });
  //     }
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

  // final FlutterLocalNotificationsPlugin _notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

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
          usersGeneralSettingsRef
              .doc(currentUserId)
              .update({'androidNotificationToken': newToken});
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
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
        String? authorId = message.data['authorId'];
        String? eventAuthorId = message.data['eventAuthorId'];

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
              : contentType.endsWith('follow')
                  ? _navigateToPage(
                      context,
                      ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!,
                        userId: authorId!,
                        user: null,
                      ))
                  : contentType.endsWith('ticketPurchased')
                      ? _navigateToPage(
                          context,
                          ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context, listen: false)
                                    .currentUserId!,
                            userId: authorId!,
                            user: null,
                          ))
                      : contentType.endsWith('message')
                          ? _navigateToPage(
                              context,
                              ViewSentContent(
                                contentId: contentId,
                                contentType: 'message',
                                eventAuthorId: '',
                                // affiliateId: '',
                              ),
                            )
                          : contentType.endsWith('eventRoom')
                              ? _navigateToPage(
                                  context,
                                  ViewSentContent(
                                    contentId: contentId,
                                    contentType: 'eventRoom',
                                    eventAuthorId: '',
                                    // affiliateId: '',
                                  ),
                                )
                              : contentType.endsWith('eventDeleted')
                                  ? _navigateToPage(
                                      context,
                                      ViewSentContent(
                                        contentId: contentId,
                                        contentType: 'eventDeleted',
                                        eventAuthorId: '',
                                        // affiliateId: '',
                                      ),
                                    )
                                  : contentType.endsWith('refundProcessed')
                                      ? _navigateToPage(
                                          context,
                                          ViewSentContent(
                                            contentId: contentId,
                                            contentType: 'refundProcessed',
                                            eventAuthorId: eventAuthorId!,
                                            // affiliateId: '',
                                          ),
                                        )
                                      : _navigateToPage(
                                          context,
                                          ViewSentContent(
                                            contentId: contentId,
                                            contentType: contentType.endsWith(
                                                    'FundsDistributed')
                                                ? 'Event'
                                                : contentType.endsWith(
                                                        'newEventInNearYou')
                                                    ? 'Event'
                                                    : contentType.endsWith(
                                                            'eventUpdate')
                                                        ? 'Event'
                                                        : contentType.endsWith(
                                                                'eventReminder')
                                                            ? 'Event'
                                                            : contentType.endsWith(
                                                                    'refundRequested')
                                                                ? 'Event'
                                                                : contentType
                                                                        .startsWith(
                                                                            'inviteRecieved')
                                                                    ? 'InviteRecieved'
                                                                    : '',
                                            // affiliateId: '',
                                            eventAuthorId: eventAuthorId!,
                                          ),
                                        );
        }
        // }
      }
    }
  }

  Future<void> initDynamicLinks() async {
    // Handle the initial dynamic link if the app was opened with one
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      await _handleDynamicLink(initialLink);
    }

    // Listen for new dynamic links while the app is running
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) async {
      await _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  Future<void> _handleDynamicLink(
      PendingDynamicLinkData? dynamicLinkData) async {
    final _provider = Provider.of<UserData>(context, listen: false);

    final Uri? link = dynamicLinkData?.link;
    if (link != null && link.path.isNotEmpty) {
      // Normalize the path by removing the leading slash if it exists
      final String normalizedPath =
          link.path.startsWith('/') ? link.path.substring(1) : link.path;
      final List<String> parts = normalizedPath.split("_");
      await AffiliateManager.saveEventAffiliateId(
          parts[1], parts.length > 3 ? parts[3].trim() : '');

      if (parts.length >= 2) {
        print('link     ' + link.toString());
        print(parts[1]);
        print(parts[0]);
        print(parts[2]);
        // print(parts.length > 3 ? 'vvvvv' + parts[3].trim() : 'zzzzz');
        //  await _provider.setMarketedAffiliateId(
        //     parts.length > 3 ? parts[3].trim() : '',
        //   );

        // print(parts[3]);

        // Handle the dynamic link based on its type
        if (parts[0].endsWith('user')) {
          _navigateToPage(
            context,
            ProfileScreen(
              currentUserId: _provider.currentUserId!,
              userId: parts[1],
              user: null,
            ),
          );
        } else {
          _navigateToPage(
            context,
            ViewSentContent(
              contentId: parts[1],
              contentType: parts[0].endsWith('punched')
                  ? 'Mood Punched'
                  : parts[0].endsWith('event')
                      ? 'Event'
                      : '',
              eventAuthorId: parts[2].trim(),
              // affiliateId: parts.length > 3 ? parts[3].trim() : '',
            ),
          );
        }
      } else {
        print('Link format not as expected: $link');
      }
    }
  }

  // Future<void> initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.getInitialLink();

  //   FirebaseDynamicLinks.instance.onLink
  //       .listen((PendingDynamicLinkData? dynamicLinkData) async {
  //     final Uri? link = dynamicLinkData?.link;
  //     if (link != null && link.path.isNotEmpty) {
  //       final List<String> parts = link.path.split("_");
  //       if (parts.length >= 2) {
  //         print(parts[1]);
  //         print(parts[0]);

  //         parts[0].endsWith('user')
  //             ? _navigateToPage(
  //                 context,
  //                 ProfileScreen(
  //                   currentUserId: Provider.of<UserData>(context, listen: false)
  //                       .currentUserId!,
  //                   userId: parts[1],
  //                   user: null,
  //                 ))
  //             : _navigateToPage(
  //                 context,
  //                 ViewSentContent(
  //                   contentId: parts[1],
  //                   contentType: parts[0].endsWith('punched')
  //                       ? 'Mood Punched'
  //                       : parts[0].endsWith('event')
  //                           ? 'Event'
  //                           : '',
  //                 ),
  //               );
  //       } else {
  //         print('Link format not as expected: $link');
  //       }
  //     }
  //   }).onError((error) {
  //     print('Dynamic Link Failed: $error');
  //   });
  // }

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
  // FirebaseDynamicLinks dynamicLi,nks = FirebaseDynamicLinks.instance;
  int _currentTab = 1;
  late PageController _pageController;
  int _version = 0;
  bool _showInfo = false;
  int _affiliateCount = 0;

  // int _inviteCount = -1;

  List<InviteModel> _inviteList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentTab,
    );
    _pageController.addListener(() {
      // Check if the scroll position indicates that the page has finished scrolling
      if ((_pageController.position.pixels %
              _pageController.position.viewportDimension) ==
          0) {
        triggerHapticFeedback(); // Trigger haptic feedback when the page finishes scrolling
      }
    });

    // _setUpInvitsCount();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      int? version = Platform.isIOS
          ? widget.updateApp.updateVersionIos
          : widget.updateApp.updateVersionAndroid;
      _version = version!;
      await _setUpInvites();
      await _setAffiliateCount();

      _setShowDelayInfo();
    });
  }

  void triggerHapticFeedback() {
    HapticFeedback.lightImpact(); // Use the desired haptic feedback method
  }
  // _setUpInvitsCount() async {
  // final String currentUserId =
  //     Provider.of<UserData>(context, listen: false).currentUserId!;
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

  _setAffiliateCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numUerAffiliates(
      currentUserId,
    ).listen((affiliateCount) {
      if (mounted) {
        setState(() {
          _affiliateCount = affiliateCount;
        });
      }
    });
  }

  _setUpInvites() async {
    final currentDate = DateTime(now.year, now.month, now.day);
    int sortNumberOfDays = 7;
    final sortDate = currentDate.add(Duration(days: sortNumberOfDays));
    try {
      final String currentUserId =
          Provider.of<UserData>(context, listen: false).currentUserId!;
      QuerySnapshot eventFeedSnapShot;

      // If lastDocument is null, this is the first fetch
      if (lastDocument == null) {
        eventFeedSnapShot = await userInvitesRef
            .doc(currentUserId)
            .collection('eventInvite')
            .where('answer', isEqualTo: '')
            .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
            .where('eventTimestamp', isLessThanOrEqualTo: sortDate)
            .orderBy('eventTimestamp')
            .limit(inviteLimit)
            .get();
      } else {
        // If lastDocument is not null, fetch the next batch starting after the last document
        eventFeedSnapShot = await userInvitesRef
            .doc(currentUserId)
            .collection('eventInvite')
            .where('answer', isEqualTo: '')
            .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
            .where('eventTimestamp', isLessThanOrEqualTo: sortDate)
            .orderBy('eventTimestamp')
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
    //  var _provider = Provider.of<UserData>(context);

    // final String currentUserId = _provider.currentUserId!;
    // final AccountHolderAuthor user = _provider.user!;

    // final UserSettingsLoadingPreferenceModel userLocationSettings =
    //     _provider.userLocationPreference!;
    var _provider = Provider.of<UserData>(context);

    // Use conditional access and provide default/fallback values or handle the case where the value might be null
    final String? currentUserId = _provider.currentUserId;
    final AccountHolderAuthor? user = _provider.user;
    final UserSettingsLoadingPreferenceModel? userLocationSettings =
        _provider.userLocationPreference;

    // If any of these values are null, we handle it by showing an error message or taking some other action
    if (currentUserId == null || user == null || userLocationSettings == null) {
      // Handle the null case here, e.g., by showing an error or a loading indicator
      return PostSchimmerSkeleton(); // or some error message
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    bool dontShowActivityCount = _provider.activityCount == 0 || !_showInfo;
    bool dontShowInvite = _inviteList.length < 1 || !_showInfo;

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
                  child: Stack(
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
                      Positioned(
                          bottom: widget.updateAppVersion < _version ? 90 : 7,
                          child: MiniAffiliateNote(
                            updateNote:
                                'Congratulations, you have one or more affiliate deals.',
                            showinfo: _affiliateCount > 0 ? true : false,
                            displayMiniUpdate:
                                widget.updateApp.displayMiniUpdate!,
                          )),
                      Positioned(bottom: 7, child: NoConnection()),
                    ],
                  ),
                ),
                bottomNavigationBar: _currentTab == 0
                    ? const SizedBox.shrink()
                    : Wrap(
                        children: [
                          BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            backgroundColor:
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

                            selectedItemColor:
                                Theme.of(context).secondaryHeaderColor,

                            items: [
                              BottomNavigationBarItem(
                                icon: _tabColumn(Icons.event, _currentTab, 1),
                                label: 'Event',
                              ),
                              BottomNavigationBarItem(
                                icon: _tabColumn(Icons.search, _currentTab, 2),
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
                                icon: _tabColumn(Icons.account_circle_outlined,
                                    _currentTab, 5),
                                label: 'Profile',
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              dontShowInvite
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
                    height: dontShowInvite
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
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 400),
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
                            child: Container()),
                      ),
                    )
                  : const SizedBox.shrink(),
              if (_provider.florenceActive)
                HopeActions(
                    showAffiliateNote: _inviteList.length > 0,
                    updateApp: widget.updateApp,
                    showUpdate: widget.updateAppVersion < _version),
              Positioned(
                bottom: ResponsiveHelper.responsiveHeight(
                    context, _provider.int2 == 3 ? 50 : 100

                    //  _inviteList.length < 1
                    //     ? 100
                    //     : 70

                    ),
                child: GestureDetector(
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    _provider.setFlorenceActive(
                        _provider.florenceActive ? false : true);
                    _provider.setInt2(0);
                  },
                  child: Container(
                    height: ResponsiveHelper.responsiveFontSize(
                        context, dontShowActivityCount ? 40 : 100),
                    width: ResponsiveHelper.responsiveFontSize(context, 60),
                    color: Colors.transparent,
                    child: AnimatedContainer(
                      margin: EdgeInsets.only(
                          bottom: dontShowActivityCount ? 0 : 50),
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800),
                      height: _provider.showEventTab && _provider.showUsersTab
                          ? 40
                          : 0,
                      width: _provider.showEventTab && _provider.showUsersTab
                          ? 40
                          : 0,
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _provider.int2 == 3
                            ? Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(.6)
                            : _provider.florenceActive
                                ? Colors.transparent
                                : Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: _provider.florenceActive
                            ? Icon(
                                Icons.close,
                                color: _provider.int2 == 3
                                    ? Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.6)
                                    : _provider.florenceActive
                                        ? Colors.white
                                        : Colors.black,
                                size: _provider.florenceActive ? 30 : 20,
                              )
                            : AnimatedCircle(
                                size: 25,
                                stroke: 2,
                                animateSize: false,
                                animateShape: false,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: _inviteList.length < 1 ? 108 : 30,
                child: GestureDetector(
                  onTap: () {
                    _navigateToPage(
                        NotificationPage(currentUserId: currentUserId));
                  },
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 800),
                    height: dontShowActivityCount ? 0.0 : 40,
                    width: dontShowActivityCount ? 1 : 150,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                NumberFormat.compact()
                                    .format(_provider.activityCount),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: dontShowActivityCount
                                        ? 0
                                        : ResponsiveHelper.responsiveFontSize(
                                            context, 16.0),
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
