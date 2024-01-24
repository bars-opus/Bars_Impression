// import 'package:bars/utilities/exports.dart';
// import 'package:uuid/uuid.dart';

// class EventDatabaseService {
//   static Future<QuerySnapshot> searchEvent(String title) {
//     String trimedTitle = title.toUpperCase().trim();

//     Future<QuerySnapshot> events =
//         allEventsRef.orderBy('title').startAt([trimedTitle]).limit(10).get();
//     return events;
//   }

//   static Stream<int> numChatRoomMessage(String chatId) {
//     return eventsChatRoomsConverstionRef
//         .doc(chatId)
//         .collection('roomChats')
//         .snapshots()
//         .map((documentSnapshot) => documentSnapshot.docs.length);
//   }

//   static void roomChatMessage({
//     required EventRoomMessageModel message,
//     required String eventId,
//   }) async {
//     eventsChatRoomsConverstionRef.doc(eventId).collection('roomChats').add({
//       'senderId': message.senderId,
//       'content': message.content,
//       'eventId': message.eventId,
//       'authorName': message.authorName,
//       'authorProfileHanlde': message.authorProfileHanlde,
//       'authorProfileImageUrl': message.authorProfileImageUrl,
//       'authorVerification': message.authorVerification,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isRead': message.isRead,
//       'isSent': message.isSent,
//       'isLiked': message.isLiked,
//       'sendContent':
//           message.sendContent == null ? null : message.sendContent!.toMap(),
//       'replyToMessage': message.replyToMessage == null
//           ? null
//           : message.replyToMessage!.toMap(),
//       'attachments': message.attachments
//           .map((attachments) => attachments.toJson())
//           .toList(),
//     });
//   }

//   static Future<void> createEvent(Event event) async {
//     // Create a toJson method inside Event class to serialize the object into a map
//     Map<String, dynamic> eventData = event.toJson();

//     // Prepare the batch
//     WriteBatch batch = FirebaseFirestore.instance.batch();

//     // Add the event to 'eventsRef'
//     DocumentReference eventRef =
//         eventsRef.doc(event.authorId).collection('userEvents').doc(event.id);
//     batch.set(eventRef, eventData);

//     // Add the event to 'allEventsRef'
//     DocumentReference allEventRef = allEventsRef.doc(event.id);
//     // FirebaseFirestore.instance.collection('new_allEvents').doc(event.id);
//     batch.set(allEventRef, eventData);

//     // Add the event to 'eventsChatRoomsRef'
//     DocumentReference chatRoomRef = eventsChatRoomsRef.doc(event.id);
//     batch.set(chatRoomRef, {
//       'title': event.title,
//       'linkedEventId': event.id,
//       'imageUrl': event.imageUrl,
//       'report': event.report,
//       'reportConfirmed': event.reportConfirmed,
//       'isClossed': false,
//       'timestamp': event.timestamp,
//     });

//     // Commit the batch
//     await batch.commit();

//     // Fetch users in the same city
//     QuerySnapshot querySnapshot = await usersAuthorRef
//         .where('city', isEqualTo: event.city)
//         .where('country', isEqualTo: event.country)
//         .get();

//     // Prepare the batch for user activities
//     WriteBatch activitiesBatch = FirebaseFirestore.instance.batch();

//     // Loop over the users and create an activity document for each one
//     for (var doc in querySnapshot.docs) {
//       // Get the user's ID
//       String userId = doc.id;

//       // Create the activity document
//       DocumentReference userActivityRef =
//           activitiesRef.doc(userId).collection('userActivities').doc();
//       activitiesBatch.set(userActivityRef, {
//         'authorId': event.authorId,
//         'postId': event.id,
//         'seen': false,
//         'type': 'newEventInNearYou',
//         'postImageUrl': event.imageUrl,
//         'comment':
//             MyDateFormat.toDate(event.startDate.toDate()) + '\n${event.title}',
//         'timestamp': Timestamp.fromDate(DateTime.now()),
//         'authorProfileImageUrl': '',
//         'authorName': 'New event in ${event.city}',
//         'authorProfileHandle': '',
//         'authorVerification': ''
//       });
//     }

//     // Commit the batch
//     await activitiesBatch.commit();
//   }

//   static void editEvent(Event event) {
//     eventsRef
//         .doc(event.authorId)
//         .collection('userEvents')
//         .doc(event.id)
//         .update({
//       'title': event.title,
//       'rate': event.rate,
//       'venue': event.venue,
//       'theme': event.theme,
//       'dressCode': event.dressCode,
//       // 'dj': event.dj,
//       // 'guess': event.guess,
//       // 'host': event.host,
//       // 'artist': event.artist,
//       'previousEvent': event.previousEvent,
//       'clossingDay': event.clossingDay,
//       'triller': event.triller,
//       'city': event.city,
//       'country': event.country,
//       'ticketSite': event.ticketSite,
//       'blurHash': event.blurHash,
//     });
//   }

//   static Future<void> deleteEvent({
//     required String currentUserId,
//     required Event event,
//     required String photoId,
//   }) async {
//     // Helper function to delete documents in batches
//     Future<void> deleteInBatches(Query query) async {
//       while (true) {
//         QuerySnapshot querySnapshot = await query.limit(500).get();
//         if (querySnapshot.docs.isEmpty) {
//           return;
//         }

//         WriteBatch batch = FirebaseFirestore.instance.batch();

//         for (final doc in querySnapshot.docs) {
//           batch.delete(doc.reference);
//         }

//         await batch.commit();
//       }
//     }

//     // Delete event tickets
//     await deleteInBatches(
//         newEventTicketOrderRef.doc(event.id).collection('eventInvite'));

//     // Delete sent event invites
//     await deleteInBatches(
//         sentEventIviteRef.doc(event.id).collection('eventInvite'));

//     // Delete asks
//     await deleteInBatches(asksRef.doc(event.id).collection('eventAsks'));

//     // Delete chat room
//     DocumentSnapshot chatRoomDoc = await eventsChatRoomsRef.doc(event.id).get();
//     if (chatRoomDoc.exists) {
//       await chatRoomDoc.reference.delete();
//     }

//     // Delete chat room conversations
//     await deleteInBatches(
//         eventsChatRoomsConverstionRef.doc(event.id).collection('roomChats'));

//     // Delete user event
//     DocumentSnapshot userEventDoc = await eventsRef
//         .doc(currentUserId)
//         .collection('userEvents')
//         .doc(event.id)
//         .get();
//     if (userEventDoc.exists) {
//       await userEventDoc.reference.delete();
//     }
//   }

//   static Future<int> numEventsTypes(
//       String eventType, DateTime currentDate) async {
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         .where('type', isEqualTo: eventType)
//         .where('startDate', isGreaterThanOrEqualTo: currentDate)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<int> numEventsAll(DateTime currentDate) async {
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         // .where('startDate', isGreaterThanOrEqualTo: currentDate)

//         // .where('type', isEqualTo: eventType)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<int> numEventsAllSortNumberOfDays(
//       DateTime currentDate, int sortNumberOfDays) async {
//     final endDate = currentDate.add(Duration(days: sortNumberOfDays));
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         .where('startDate', isGreaterThanOrEqualTo: currentDate)
//         .where('startDate', isLessThanOrEqualTo: endDate)

//         // .where('type', isEqualTo: eventType)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<int> numEventsTypesSortNumberOfDays(
//       String eventType, DateTime currentDate, int sortNumberOfDays) async {
//     final endDate = currentDate.add(Duration(days: sortNumberOfDays));
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         .where('type', isEqualTo: eventType)
//         .where('startDate', isGreaterThanOrEqualTo: currentDate)
//         .where('startDate', isLessThanOrEqualTo: endDate)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<int> numEventsAllLiveLocation(
//       String liveCity, String liveCountry, DateTime currentDate) async {
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         .where('startDate', isGreaterThanOrEqualTo: currentDate)
//         .where('city', isEqualTo: liveCity)
//         .where('country', isEqualTo: liveCountry)

//         // .where('type', isEqualTo: eventType)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<int> numEventsTypesLiveLocation(String eventType,
//       String liveCity, String liveCountry, DateTime currentDate) async {
//     QuerySnapshot feedEventSnapShot = await allEventsRef
//         .where('startDate', isGreaterThanOrEqualTo: currentDate)
//         .where('type', isEqualTo: eventType)
//         .where('city', isEqualTo: liveCity)
//         .where('country', isEqualTo: liveCountry)
//         // .where('showOnExplorePage', isEqualTo: true)
//         .get();
//     return feedEventSnapShot.docs.length - 1;
//   }

//   static Future<List<Event>> getUserEvents(String userId) async {
//     QuerySnapshot userEventsSnapshot = await eventsRef
//         .doc(userId)
//         .collection('userEvents')
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<Event> events =
//         userEventsSnapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
//     return events;
//   }

//   static Future<TicketOrderModel?> getTicketOrderEventWithId(
//       TicketOrderModel order) async {
//     try {
//       DocumentSnapshot userDocSnapshot = await newEventTicketOrderRef
//           .doc(order.eventId)
//           .collection('eventInvite')
//           .doc(order.userOrderId)
//           .get();
//       if (userDocSnapshot.exists) {
//         return TicketOrderModel.fromDoc(userDocSnapshot);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   static Future<Event?> getEventWithId(String eventId) async {
//     try {
//       DocumentSnapshot userDocSnapshot = await allEventsRef.doc(eventId).get();

//       if (userDocSnapshot.exists) {
//         return Event.fromDoc(userDocSnapshot);
//       } else {
//         return null; // return null if document does not exist
//       }
//     } catch (e) {
//       print(e);
//       return null; // return null if an error occurs
//     }
//   }

//   static Future<TicketOrderModel?> getTicketWithId(
//       String eventId, String currentUserId) async {
//     DocumentSnapshot userDocSnapshot = await userInviteRef
//         .doc(currentUserId)
//         .collection('eventInvite')
//         .doc(eventId)
//         .get();
//     if (userDocSnapshot.exists) {
//       return TicketOrderModel.fromDoc(userDocSnapshot);
//     }
//     return null; // return null if the ticket doesn't exist
//   }

//   static Future<EventRoom?> getEventRoomWithId(String eventId) async {
//     try {
//       DocumentSnapshot userDocSnapshot =
//           await eventsChatRoomsRef.doc(eventId).get();
//       if (userDocSnapshot.exists) {
//         return EventRoom.fromDoc(userDocSnapshot);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   static Future<InviteModel?> getEventIviteWithId(
//       String currentUserId, String eventId) async {
//     try {
//       DocumentSnapshot userDocSnapshot = await userIviteRef
//           .doc(currentUserId)
//           .collection('eventInvite')
//           .doc(eventId)
//           .get();
//       if (userDocSnapshot.exists) {
//         return InviteModel.fromDoc(userDocSnapshot);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   static Stream<int> numAllEventInvites(String eventId, String answer) {
//     // Check if eventId is null or empty
//     if (eventId.isEmpty || eventId.trim() == '') {
//       print("Error: eventId is null or empty.");
//       // Return an empty stream or handle the error as appropriate for your app
//       return Stream.empty();
//     }

//     return sentEventIviteRef
//         .doc(eventId)
//         .collection('eventInvite')
//         .where('answer', isEqualTo: answer)
//         .snapshots()
//         .map((documentSnapshot) => documentSnapshot.docs.length);
//   }

//   static Stream<int> numExpectedAttendees(String eventId, bool validated) {
//     if (eventId.isEmpty || eventId.trim() == '') {
//       print("Error: eventId is null or empty.");
//       // Return an empty stream or handle the error as appropriate for your app
//       return Stream.empty();
//     }
//     return newEventTicketOrderRef
//         .doc(eventId)
//         .collection('eventInvite')
//         .where('validated', isEqualTo: validated)
//         .get()
//         .then((querySnapshot) {
//       if (querySnapshot.size > 0) {
//         return querySnapshot.size;
//       } else {
//         // Return an appropriate value or handle the error case when the collection doesn't exist
//         return 0;
//       }
//     }).asStream();
//   }

//   static Stream<int> numTotalExpectedAttendees(
//     String eventId,
//   ) {
//     return newEventTicketOrderRef
//         .doc(eventId)
//         .collection('eventInvite')
//         .get()
//         .then((querySnapshot) {
//       if (querySnapshot.size > 0) {
//         return querySnapshot.size;
//       } else {
//         // Return an appropriate value or handle the error case when the collection doesn't exist
//         return 0;
//       }
//     }).asStream();
//   }

//   static Future<int> numUsersTickets(String userId) async {
//     QuerySnapshot feedSnapShot =
//         await userInviteRef.doc(userId).collection('eventInvite').get();
//     return feedSnapShot.docs.length;
//   }

//   static Future<bool> isTicketOrderAvailable({
//     required Transaction transaction,
//     required String userOrderId,
//     required String eventId,
//   }) async {
//     DocumentReference ticketOrderDocRef =
//         userInviteRef.doc(userOrderId).collection('eventInvite').doc(eventId);

//     DocumentSnapshot ticketOrderDoc = await transaction.get(ticketOrderDocRef);

//     return ticketOrderDoc.exists;
//   }

//   static void purchaseMoreTicket({
//     required String userOrderId,
//     required String eventId,
//     required List<TicketModel> tickets,
//   }) {
//     // String commonId = Uuid().v4();

//     newEventTicketOrderRef
//         .doc(eventId)
//         .collection('eventInvite')
//         .doc(userOrderId)
//         .update({
//       'tickets': FieldValue.arrayUnion(
//           tickets.map((ticket) => ticket.toJson()).toList())
//     });

//     userInviteRef
//         .doc(userOrderId)
//         .collection('eventInvite')
//         .doc(eventId)
//         .update({
//       'tickets': FieldValue.arrayUnion(
//           tickets.map((ticket) => ticket.toJson()).toList())
//     });
//   }

//   static deleteTicket({
//     required TicketOrderModel ticketOrder,
//   }) {
//     // String commonId = Uuid().v4();

//     newEventTicketOrderRef
//         .doc(ticketOrder.eventId)
//         .collection('eventInvite')
//         .doc(ticketOrder.userOrderId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });

//     userInviteRef
//         .doc(ticketOrder.userOrderId)
//         .collection('eventInvite')
//         .doc(ticketOrder.eventId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//   }

//   static Future<bool> isHavingTicket(
//       {required String eventId, required String userId}) async {
//     DocumentSnapshot ticketDoc = await newEventTicketOrderRef
//         .doc(eventId)
//         .collection('eventInvite')
//         .doc(userId)
//         .get();
//     return ticketDoc.exists;
//   }

//   static answerEventInviteBatch({
//     required WriteBatch batch,
//     required Event event,
//     required String answer,
//     required AccountHolderAuthor currentUser,
//   }) async {
//     // WriteBatch batch = FirebaseFirestore.instance.batch();
//     DocumentReference newEventTicketOrderRef = sentEventIviteRef
//         .doc(event.id)
//         .collection('eventInvite')
//         .doc(currentUser.userId);
//     batch.update(newEventTicketOrderRef, {
//       'answer': answer,
//     });

//     DocumentReference userInviteRef = userIviteRef
//         .doc(currentUser.userId)
//         .collection('eventInvite')
//         .doc(event.id);
//     batch.update(userInviteRef, {
//       'answer': answer,
//     });
//   }

// // The DatabaseService.purchaseTicket method is responsible for storing the details
// // of the purchased ticket in the Firestore database. This method creates two new documents,
// //  one under the 'eventInvite' collection of the specific eventId and another under
// //  the 'eventInvite' collection of the specific userOrderId. Both documents contain
// //  the same data, which includes details about the ticket order.

//   static void purchaseTicketBatch({
//     required WriteBatch batch,
//     required TicketOrderModel ticketOrder,
//     required AccountHolderAuthor user,
//   }) {
//     // WriteBatch batch = FirebaseFirestore.instance.batch();

//     final eventInviteDocRef = newEventTicketOrderRef
//         .doc(ticketOrder.eventId)
//         .collection('eventInvite')
//         .doc(ticketOrder.userOrderId);

//     final userInviteDocRef = userInviteRef
//         .doc(ticketOrder.userOrderId)
//         .collection('eventInvite')
//         .doc(ticketOrder.eventId);

//     Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

//     batch.set(eventInviteDocRef, ticketOrderData);
//     batch.set(userInviteDocRef, ticketOrderData);

//     // Add addUserTicketIdRef to the batch
//     final userTicketIdDocRef = userTicketIdRef
//         .doc(ticketOrder.userOrderId)
//         .collection('eventInvite')
//         .doc(ticketOrder.eventId);

//     batch.set(userTicketIdDocRef, {
//       'eventId': ticketOrder.eventId,
//       'isNew': false,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     activitiesRef.doc(user.userId).collection('userActivities').add({
//       'authorId': ticketOrder.userOrderId,
//       'postId': ticketOrder.eventId,
//       'seen': false,
//       'type': 'ticketPurchased',
//       'postImageUrl': ticketOrder.eventImageUrl,
//       'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//       'authorProfileImageUrl': '',
//       'authorName': user.userName,
//       'authorProfileHandle': user.profileHandle,
//       'authorVerification': user.verified,
//     });

//     // return batch.commit();
//   }

//   static Future<void> purchaseTicketTransaction({
//     required Transaction transaction,
//     required TicketOrderModel ticketOrder,
//     required AccountHolderAuthor user,
//   }) async {
//     final eventInviteDocRef = newEventTicketOrderRef
//         .doc(ticketOrder.eventId)
//         .collection('eventInvite')
//         .doc(ticketOrder.userOrderId);

//     final userInviteDocRef = userInviteRef
//         .doc(ticketOrder.userOrderId)
//         .collection('eventInvite')
//         .doc(ticketOrder.eventId);

//     // final Map<String, dynamic> ticketOrderData = {
//     //   'orderId': ticketOrder.orderId,
//     //   'eventId': ticketOrder.eventId,
//     //   // 'validated': ticketOrder.validated,
//     //   'timestamp': ticketOrder.timestamp,
//     //   'eventTimestamp': ticketOrder.eventTimestamp,
//     //   // 'entranceId': ticketOrder.entranceId,
//     //   'eventImageUrl': ticketOrder.eventImageUrl,
//     //   'isInvited': ticketOrder.isInvited,
//     //   'orderNumber': ticketOrder.orderNumber,
//     //   'tickets': ticketOrder.tickets.map((ticket) => ticket.toJson()).toList(),
//     //   'total': ticketOrder.total,
//     //   'userOrderId': ticketOrder.userOrderId,
//     //   'eventTitle': ticketOrder.eventTitle,
//     // };
//     Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

//     transaction.set(eventInviteDocRef, ticketOrderData);
//     transaction.set(userInviteDocRef, ticketOrderData);

//     // Add addUserTicketIdRef to the transaction
//     final userTicketIdDocRef = userTicketIdRef
//         .doc(ticketOrder.userOrderId)
//         .collection('eventInvite')
//         .doc(ticketOrder.eventId);

//     transaction.set(userTicketIdDocRef, {
//       'eventId': ticketOrder.eventId,
//       'isNew': false,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     activitiesRef.doc(user.userId).collection('userActivities').add({
//       'authorId': ticketOrder.userOrderId,
//       'postId': ticketOrder.eventId,
//       'seen': false,
//       'type': 'ticketPurchased',
//       'postImageUrl': ticketOrder.eventImageUrl,
//       'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//       'authorProfileImageUrl': '',
//       'authorName': user.userName,
//       'authorProfileHandle': user.profileHandle,
//       'authorVerification': user.verified,
//     });
//   }

//   static void attendEvent({
//     required Event event,
//     required AccountHolderAuthor user,
//     required String requestNumber,
//     required String message,
//     required Timestamp eventDate,
//     required String currentUserId,
//   }) async {
//     String commonId = Uuid().v4();

//     await newEventTicketOrderRef
//         .doc(event.id)
//         .collection('eventInvite')
//         .doc(user.userId)
//         .set({
//       'orderId': commonId,
//       'eventId': event.id,
//       'commonId': commonId,
//       'validated': false,
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//       'eventTimestamp': eventDate,
//       'entranceId': '0909',
//       'eventImageUrl': event.imageUrl,
//       'invitatonMessage': '',
//       'invitedById': '',
//       'isInvited': false,
//       'orderNumber': '909',
//       'tickets': [],
//       'total': 09,
//       'userOderId': commonId,
//     });

//     await userInviteRef
//         .doc(user.userId)
//         .collection('eventInvite')
//         .doc(event.id)
//         .set({
//       'orderId': commonId,
//       'eventId': event.id,
//       'commonId': commonId,
//       'validated': false,
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//       'eventTimestamp': eventDate,
//       'entranceId': '0909',
//       'eventImageUrl': event.imageUrl,
//       'invitatonMessage': '',
//       'invitedById': '',
//       'isInvited': false,
//       'orderNumber': '909',
//       'tickets': [],
//       'total': 09,
//       'userOderId': commonId,
//     });
//   }

//   static Future<void> answerEventInviteTransaction({
//     required Transaction transaction,
//     required Event event,
//     required String answer,
//     required AccountHolderAuthor currentUser,
//   }) async {
//     DocumentReference newEventTicketOrderRef = sentEventIviteRef
//         .doc(event.id)
//         .collection('eventInvite')
//         .doc(currentUser.userId);

//     transaction.update(newEventTicketOrderRef, {
//       'answer': answer,
//     });

//     DocumentReference userInviteRef = userIviteRef
//         .doc(currentUser.userId)
//         .collection('eventInvite')
//         .doc(event.id);

//     transaction.update(userInviteRef, {
//       'answer': answer,
//     });
//   }

//   static sendEventInvite({
//     required Event event,
//     required List<AccountHolderAuthor> users,
//     required String message,
//     required String generatedMessage,
//     required AccountHolderAuthor currentUser,
//     required bool isTicketPass,
//   }) {
//     WriteBatch batch = FirebaseFirestore.instance.batch();

//     for (var user in users) {
//       DocumentReference newEventTicketOrderRef = sentEventIviteRef
//           .doc(event.id)
//           .collection('eventInvite')
//           .doc(user.userId);
//       batch.set(newEventTicketOrderRef, {
//         'eventId': event.id,
//         'inviteeId': user.userId,
//         'inviterId': currentUser.userId,
//         'inviterMessage': message,
//         'isTicketPass': isTicketPass,
//         'generatedMessage': generatedMessage,
//         'answer': '',
//         'timestamp': FieldValue.serverTimestamp(),
//         'eventTimestamp': event.startDate,
//       });

//       DocumentReference userInviteRef =
//           userIviteRef.doc(user.userId).collection('eventInvite').doc(event.id);
//       batch.set(userInviteRef, {
//         'eventId': event.id,
//         'inviteeId': user.userId,
//         'inviterId': currentUser.userId,
//         'inviterMessage': message,
//         'isTicketPass': isTicketPass,
//         'generatedMessage': generatedMessage,
//         'answer': '',
//         'timestamp': FieldValue.serverTimestamp(),
//         'eventTimestamp': event.startDate,
//       });

//       activitiesRef.doc(user.userId).collection('userActivities').add({
//         'authorId': event.authorId,
//         'postId': event.id,
//         'seen': false,
//         'type': 'inviteRecieved',
//         'postImageUrl': event.imageUrl,
//         'comment': MyDateFormat.toDate(event.startDate.toDate()) +
//             '\n${message.isEmpty ? generatedMessage : message}',
//         'timestamp': Timestamp.fromDate(DateTime.now()),
//         'authorProfileImageUrl': '',
//         'authorName': 'Cordially Invited',
//         'authorProfileHandle': '',
//         'authorVerification': ''
//       });
//       return batch.commit().then((value) => {}).catchError((error) {
//         throw error; // Re-throw the error
//       });
//     }
//   }

//   static void askAboutEvent(
//       {required String currentUserId,
//       required Event event,
//       required String ask,
//       required AccountHolderAuthor user,
//       required String reportConfirmed}) {
//     asksRef.doc(event.id).collection('eventAsks').add({
//       'content': ask,
//       'report': '',
//       'mediaType': '',
//       'mediaUrl': '',
//       'authorName': user.userName,
//       'authorProfileHanlde': user.profileHandle,
//       'authorProfileImageUrl': user.profileImageUrl,
//       'authorVerification': user.verified,
//       'reportConfirmed': reportConfirmed,
//       'authorId': currentUserId,
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//     });
//     // String commonId = Uuid().v4();

//     addActivityItem(
//       user: user,
//       event: event, comment: ask, followerUser: null, post: null,
//       type: NotificationActivityType.ask,
//       // ask: ask,
//       // commonId: commonId,
//     );

//     // addActivityEventItem(
//     //   user: user,
//     //   event: event,
//     //   ask: ask,
//     //   commonId: commonId,
//     // );
//   }

//   static Stream<int> numAsks(String eventId) {
//     return asksRef
//         .doc(eventId)
//         .collection('eventAsks')
//         .snapshots()
//         .map((documentSnapshot) => documentSnapshot.docs.length);
//   }

//   static void deleteAsk(
//       {required String currentUserId,
//       required Event event,
//       required Ask ask}) async {
//     asksRef.doc(event.id).collection('eventAsks').doc(ask.id).get().then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//   }

//   static void editAsk(
//     Ask ask,
//     Event event,
//   ) {
//     asksRef.doc(event.id).collection('eventAsks').doc(ask.id).update({
//       'content': ask.content,
//       'authorId': ask.authorId,
//       'timestamp': ask.timestamp,
//     });
//   }

//   static void addActivityItem(
//       {required AccountHolderAuthor user,
//       required AccountHolderAuthor? followerUser,
//       required Post? post,
//       required Event? event,
//       required NotificationActivityType type,
//       required String? comment}) {
//     // if (user.id != post.authorId) {
//     post != null
//         ? activitiesRef.doc(post.authorId).collection('userActivities').add({
//             'authorId': user.userId,
//             'postId': post.id,
//             'seen': false,
//             'type': type.toString().split('.').last,
//             'postImageUrl': post.imageUrl,
//             'comment': comment,
//             'timestamp': Timestamp.fromDate(DateTime.now()),
//             'authorProfileImageUrl': user.profileImageUrl,
//             'authorName': user.userName,
//             'authorProfileHandle': user.profileHandle,
//             'authorVerification': user.verified,
//           })
//         : event != null
//             ? activitiesRef
//                 .doc(event.authorId)
//                 .collection('userActivities')
//                 .add({
//                 'authorId': user.userId,
//                 'postId': event.id,
//                 'seen': false,
//                 'type': type.toString().split('.').last,
//                 'postImageUrl': event.imageUrl,
//                 'comment': comment,
//                 'timestamp': Timestamp.fromDate(DateTime.now()),
//                 'authorProfileImageUrl': user.profileImageUrl,
//                 'authorName': user.userName,
//                 'authorProfileHandle': user.profileHandle,
//                 'authorVerification': user.verified,
//               })
//             : followerUser != null
//                 ? activitiesRef
//                     .doc(followerUser.userId)
//                     .collection('userActivities')
//                     .add({
//                     'authorId': user.userId,
//                     'postId': followerUser.userId,
//                     'seen': false,
//                     'type': type.toString().split('.').last,
//                     'postImageUrl': followerUser.profileImageUrl,
//                     'comment': comment,
//                     'timestamp': Timestamp.fromDate(DateTime.now()),
//                     'authorProfileImageUrl': user.profileImageUrl,
//                     'authorName': user.userName,
//                     'authorProfileHandle': user.profileHandle,
//                     'authorVerification': user.verified,
//                   })
//                 : null;
//     // }
//   }

//   static Future<List<Activity>> getActivities(String userId) async {
//     QuerySnapshot userActivitiesSnapshot = await activitiesRef
//         .doc(userId)
//         .collection('userActivities')
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<Activity> activity = userActivitiesSnapshot.docs
//         .map((doc) => Activity.fromDoc(doc))
//         .toList();
//     return activity;
//   }

//   static void editActivity(Activity activity, String useId) {
//     activitiesRef
//         .doc(useId)
//         .collection('userActivities')
//         .doc(activity.id)
//         .update({
//       'fromUserId': activity.authorId,
//       'postId': activity.postId,
//       'seen': activity.seen,
//       'postImageUrl': activity.postImageUrl,
//       'comment': activity.comment,
//       'timestamp': activity.timestamp,
//     });
//   }

//   static Stream<int> numActivities(String userId) {
//     return activitiesRef
//         .doc(userId)
//         .collection('userActivities')
//         .where('seen', isEqualTo: false)
//         .snapshots()
//         .map((documentSnapshot) => documentSnapshot.docs.length);
//   }

//   static Future<Event> getUserEvent(String userId, String eventId) async {
//     DocumentSnapshot eventDocSnapshot =
//         await eventsRef.doc(userId).collection('userEvents').doc(eventId).get();
//     return Event.fromDoc(eventDocSnapshot);
//   }

//   static Stream<int> numRepliedComment(String postId, String commentId) {
//     return commentsRef
//         .doc(postId)
//         .collection('postComments')
//         .doc(commentId)
//         .collection('replies')
//         .snapshots()
//         .map((documentSnapshot) => documentSnapshot.docs.length);
//   }
// }
