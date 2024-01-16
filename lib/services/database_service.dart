import 'dart:math';

import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static Future<void> createUserProfileInFirestore(
      User signedInHandler, String name) async {
    final _firestore = FirebaseFirestore.instance;
    WriteBatch batch = _firestore.batch();

    DocumentReference userAuthorRef = usersAuthorRef.doc(signedInHandler.uid);
    DocumentReference userLocationSettingsRef =
        usersLocationSettingsRef.doc(signedInHandler.uid);
    DocumentReference userGeneralSettingsRef =
        usersGeneralSettingsRef.doc(signedInHandler.uid);
    DocumentReference usersProfessionalRef =
        userProfessionalRef.doc(signedInHandler.uid);

    DocumentReference followerRef = followersRef
        .doc(signedInHandler.uid)
        .collection('userFollowers')
        .doc(signedInHandler.uid);

    batch.set(followerRef, {});

    double randomId = Random().nextDouble();

    batch.set(userAuthorRef, {
      'userId': signedInHandler.uid,
      'name': signedInHandler.displayName ?? name,
      'dynamicLink': '',
      'lastActiveDate': Timestamp.fromDate(DateTime.now()),
      'userName': '',
      'profileImageUrl': '',
      'bio': '',
      'profileHandle': 'Fan',
      'verified': false,
      'disabledAccount': false,
      'reportConfirmed': false,
    });

    batch.set(userLocationSettingsRef, {
      'userId': signedInHandler.uid,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'country': '',
      'continent': '',
      'city': '',
      'currency': '',
      'subaccountId': '',
    });

    batch.set(userGeneralSettingsRef, {
      'userId': signedInHandler.uid,
      'disableChat': false,
      'privateAccount': false,
      'disableAdvice': false,
      'hideAdvice': false,
      'disableBooking': false,
      'disabledAccount': false,
      'isEmailVerified': false,
      'disableEventSuggestionNotification': false,
      'muteEventSuggestionNotification': false,
      'androidNotificationToken': '',
      'preferredEventTypes': [],
      'preferredCreatives': [],
      'report': '',
      'disableNewCreativeNotifications': false,
      'disableWorkVacancyNotifications': false,
      'muteWorkVacancyNotifications': false,
      'reportConfirmed': false,
    });

    batch.set(usersProfessionalRef, {
      'userId': signedInHandler.uid,
      'userName': '',
      'profileImageUrl': '',
      'profileHandle': 'Fan',
      'dynamicLink': '',
      'currency': '',
      'randomId': randomId,
      'verified': false,
      'terms': '',
      'overview': '',
      'city': '',
      'country': '',
      'continent': '',
      'noBooking': false,
      'company': [],
      'collaborations': [],
      'performances': [],
      'awards': [],
      'contacts': [],
      'skills': [],
      'links': [],
      'genreTags': [],
      'professionalImageUrls': [],
      'subAccountType': [],
      'priceTags': [],
    });

    // Commit the batch
    return batch.commit();
  }

  static void updateUser(AccountHolderAuthor user) {
    usersAuthorRef.doc(user.userId).update({
      'name': user.name,
      'userName': user.userName,
      'profileImageUrl': user.profileImageUrl!,
      'bio': user.bio,
      // 'favouritePunchline': user.favouritePunchline,
      // 'favouriteArtist': user.favouriteArtist,
      // 'favouriteSong': user.favouriteSong,
      // 'favouriteAlbum': user.favouriteAlbum,
      // 'company': user.company,
      // 'country': user.country,
      // 'city': user.city,
      // 'continent': user.continent,
      // 'skills': user.skills,
      // 'performances': user.performances,
      // 'collaborations': user.collaborations,
      // 'awards': user.awards,
      // 'management': user.management,
      // 'contacts': user.contacts,
      'profileHandle': user.profileHandle!,
      // 'report': user.report,
      // 'reportConfirmed': user.reportConfirmed,
      // 'website': user.website,
      // 'otherSites1': user.otherSites1,
      // 'otherSites2': user.otherSites2,
      // 'mail': user.mail,
      // 'score': user.score,
      // 'privateAccount': user.privateAccount,
      // 'androidNotificationToken': user.androidNotificationToken,
      // 'hideUploads': user.hideUploads,
      // 'verified': user.verified,
      // 'disableAdvice': user.disableAdvice,
      // 'disableChat': user.disableChat,
      // 'enableBookingOnChat': user.enableBookingOnChat,
      // 'hideAdvice': user.hideAdvice,
      // 'noBooking': user.noBooking,
      // 'disabledAccount': user.disabledAccount,
      // 'professionalPicture1': user.professionalPicture1,
      // 'professionalPicture2': user.professionalPicture2,
      // 'professionalPicture3': user.professionalPicture3,
    });
  }

  static Future<void> createUserName(
      String username, Map<String, dynamic> userData) async {
    final _firestore = FirebaseFirestore.instance;

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot usernameDoc = await transaction
          .get(_firestore.collection('usernames').doc(username));

      if (usernameDoc.exists) {
        throw Exception('Username is not unique');
      }

      // Create the user document
      DocumentReference userRef = _firestore.collection('users').doc();
      transaction.set(userRef, userData);

      // Create the username document
      DocumentReference usernameRef =
          _firestore.collection('usernames').doc(username);
      transaction.set(usernameRef, {'userId': userRef.id});
    });
  }

// static Future<void> changeUsername(String oldUsername, String newUsername) async {
//   final _firestore = FirebaseFirestore.instance;

//   await _firestore.runTransaction((transaction) async {
//     DocumentSnapshot oldUsernameDoc =
//       await transaction.get(_firestore.collection('usernames').doc(oldUsername));

//     if (!oldUsernameDoc.exists) {
//       throw Exception('Old username does not exist');
//     }

//     DocumentSnapshot newUsernameDoc =
//       await transaction.get(_firestore.collection('usernames').doc(newUsername));

//     if (newUsernameDoc.exists) {
//       throw Exception('New username is not unique');
//     }

//     // Create the new username document
//     DocumentReference newUsernameRef = _firestore.collection('usernames').doc(newUsername);
//     transaction.set(newUsernameRef, oldUsernameDoc.data());

//     // Delete the old username document
//     DocumentReference oldUsernameRef = _firestore.collection('usernames').doc(oldUsername);
//     transaction.delete(oldUsernameRef);
//   });
// }

//  static Future<bool> isUsernameUnique(String username) async {
//     final _firestore = FirebaseFirestore.instance;
//     DocumentSnapshot usernameDoc =
//         await _firestore.collection('usernames').doc(username).get();
//     return !usernameDoc.exists;
//   }

  static Future<QuerySnapshot> searchUsers(String name) {
    String trimedName = name.toUpperCase().trim();
    // String formattedName = trimedName.replaceAll(RegExp(r'[^\w\s#@]'), '');
    // String formattedName2 =
    //     formattedName.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    Future<QuerySnapshot> users = usersAuthorRef
        .orderBy('userName')
        .startAt([trimedName])
        // .endAt([formattedName2 + '\uf8ff'])
        // .where('userName', isGreaterThanOrEqualTo: name)
        .limit(15)
        .get();
    return users;
  }

  static Future<QuerySnapshot> serchTicket(String name, String currentUserId) {
    String trimedName = name.toUpperCase().trim();
    // String formattedName = trimedName.replaceAll(RegExp(r'[^\w\s#@]'), '');
    // String formattedName2 =
    //     formattedName.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    Future<QuerySnapshot> tickets = userInviteRef
        .doc(currentUserId)
        .collection('eventInvite')
        .orderBy(
            'eventTitle') // Replace 'name' with the field you want to order your documents by
        .startAt([trimedName])
        // .endAt([name + '\uf8ff'])
        .limit(10)
        .get();
    return tickets;
  }

  static Future<QuerySnapshot> searchEvent(String title) {
    String trimedTitle = title.toUpperCase().trim();

    Future<QuerySnapshot> events = allEventsRef
        .orderBy('title')
        .startAt([trimedTitle])
        // .where('title', isGreaterThanOrEqualTo: title)
        .limit(10)
        .get();
    return events;
  }

  // static Future<QuerySnapshot> searchPost(String punchline) {
  //   String trimedTitle = punchline.toUpperCase().trim();

  //   Future<QuerySnapshot> posts = allPostsRef
  //       .orderBy('punch')
  //       .startAt([trimedTitle])
  //       // .where('punch', isGreaterThanOrEqualTo: punchline)
  //       .limit(15)
  //       .get();
  //   return posts;
  // }

  // static Future<QuerySnapshot> searchForum(String title) {
  //   Future<QuerySnapshot> forums = allForumsRef
  //       .where('title', isGreaterThanOrEqualTo: title)
  //       .limit(10)
  //       .get();
  //   return forums;
  // }

  // static Future<QuerySnapshot> searchAttendeeNumber(
  //     String eventId, String barcode) {
  //   Future<QuerySnapshot> invite = newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendNumber', isEqualTo: barcode)
  //       .get();
  //   return invite;
  // }

  static Future<QuerySnapshot> searchArtist(String name) {
    Future<QuerySnapshot> users =
        usersAuthorRef.where('userName', isEqualTo: name).get();

    return users;
  }

  static void roomChatMessage({
    required EventRoomMessageModel message,
    required String eventId,
    required String currentUserId,
  }) async {
    eventsChatRoomsConverstionRef.doc(eventId).collection('roomChats').add({
      'senderId': message.senderId,
      'content': message.content,
      'eventId': message.eventId,
      'authorName': message.authorName,
      'authorProfileHanlde': message.authorProfileHanlde,
      'authorProfileImageUrl': message.authorProfileImageUrl,
      'authorVerification': message.authorVerification,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': message.isRead,
      'isSent': message.isSent,
      'isLiked': message.isLiked,
      'sendContent':
          message.sendContent == null ? null : message.sendContent!.toMap(),
      'replyToMessage': message.replyToMessage == null
          ? null
          : message.replyToMessage!.toMap(),
      'attachments': message.attachments
          .map((attachments) => attachments.toJson())
          .toList(),
    });

    WriteBatch batch = FirebaseFirestore.instance.batch();

    final sender = {
      'lastMessage': message.content,
      'isSeen': true,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final receivers = {
      'lastMessage': message.content,
      'isSeen': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final usersDocs = await newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .get();

    for (var doc in usersDocs.docs) {
      String userId = doc.id;
      final conversationRef =
          userTicketIdRef.doc(userId).collection('eventInvite').doc(eventId);

      userId == currentUserId
          ? batch.update(
              conversationRef,
              sender,
            )
          : batch.update(
              conversationRef,
              receivers,
            );
    }

    // Commit the batch
    return batch.commit();
  }

  // static void roomChatMessage({
  //   required EventRoomMessageModel message,
  //   required String eventId,
  //   required String currentUserId,
  // }) async {
  //   eventsChatRoomsConverstionRef.doc(eventId).collection('roomChats').add({
  //     'senderId': message.senderId,
  //     'content': message.content,
  //     'eventId': message.eventId,
  //     'authorName': message.authorName,
  //     'authorProfileHanlde': message.authorProfileHanlde,
  //     'authorProfileImageUrl': message.authorProfileImageUrl,
  //     'authorVerification': message.authorVerification,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     'isRead': message.isRead,
  //     'isSent': message.isSent,
  //     'isLiked': message.isLiked,
  //     'sendContent':
  //         message.sendContent == null ? null : message.sendContent!.toMap(),
  //     'replyToMessage': message.replyToMessage == null
  //         ? null
  //         : message.replyToMessage!.toMap(),
  //     'attachments': message.attachments
  //         .map((attachments) => attachments.toJson())
  //         .toList(),
  //   });

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   final usersDocs = await newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .get();

  //   final sender = {
  //     'lastMessage': message.content,
  //     'MediaType': '',
  //     'seen': true,
  //     // 'seen': currentUserId == message.senderId ? true : false,
  //     'newMessageTimestamp': FieldValue.serverTimestamp(),
  //   };

  //   final receivers = {
  //     'lastMessage': message.content,
  //     'MediaType': '',
  //     'seen': false,
  //     // 'seen': currentUserId == message.senderId ? true : false,
  //     'newMessageTimestamp': FieldValue.serverTimestamp(),
  //   };

  //   for (var doc in usersDocs.docs) {
  //     String userId = doc.id;
  //     final conversationRef =
  //         userTicketIdRef.doc(userId).collection('eventInvite');

  //     userId == currentUserId
  //         ? batch.update(conversationRef, sender)
  //         : batch.update(conversationRef, receivers);

  //     // Commit the batch
  //     return batch.commit();
  //   }
  // }
  // static Stream<int> numFavoriteArtist(String name) {
  //   return usersAuthorRef
  //       .where('favouriteArtist', isEqualTo: name)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numSongs(String song) {
  //   return usersAuthorRef
  //       .where('favouriteSong', isEqualTo: song)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numAlbums(String albums) {
  //   return usersAuthorRef
  //       .where('favouriteAlbum', isEqualTo: albums)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numChatRoomMessage(String chatId) {
  //   return eventsChatRoomsConverstionRef
  //       .doc(chatId)
  //       .collection('roomChats')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

//   static void roomChatMessage({
//     required EventRoomMessageModel message,
//     // required bool isFirstMessage,
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

//     String messageId = Uuid().v4();

//     WriteBatch batch = FirebaseFirestore.instance.batch();

//     for (var user in users) {
//       // Create a unique chatId for each user

//       final conversationRef =
//           userTicketIdRef.doc(user.userId).collection('eventInvite');

//       // Add the message to the conversation collection
//       batch.update(conversationRef.doc(), {
//         'lastMessage': message.content,
//         'MediaType': '',
//         'seen': true,
//         'newMessageTimestamp': FieldValue.serverTimestamp(),
//       });
//     }

//     // Commit the batch
//     return batch.commit();
//     // addActivityEventItem(
//     //   user: user,
//     //   event: event,
//     //   ask: ask,
//     //   commonId: commonId,
//     // );

// // Add the message ID to the sender's chats subcollection
//     // isFirstMessage
//     //     ? await usersAuthorRef
//     //         .doc(message.senderId)
//     //         .collection('new_chats')
//     //         .doc(message.receiverId)
//     //         .set({
//     //         'messageId': messageId,
//     //         'lastMessage': message.content,
//     //         'messageInitiator': '',
//     //         'restrictChat': false,
//     //         'firstMessage': message.content,
//     //         'mediaType': '',
//     //         'timestamp': FieldValue.serverTimestamp(),
//     //         'seen': true,
//     //         'fromUserId': message.senderId,
//     //         'toUserId': message.receiverId,
//     //         'newMessageTimestamp': FieldValue.serverTimestamp(),
//     //       })
//     //     : await usersAuthorRef
//     //         .doc(message.senderId)
//     //         .collection('new_chats')
//     //         .doc(message.receiverId)
//     //         .update({
//     //         'lastMessage': message.content,
//     //         'MediaType': '',
//     //         'seen': true,
//     //         'newMessageTimestamp': FieldValue.serverTimestamp(),
//     //       });

//     // // Add the message ID to the receiver's chats subcollection
//     // isFirstMessage
//     //     ? await usersAuthorRef
//     //         .doc(message.receiverId)
//     //         .collection('new_chats')
//     //         .doc(message.senderId)
//     //         .set({
//     //         'messageId': messageId,
//     //         'lastMessage': message.content,
//     //         'messageInitiator': message.senderId,
//     //         'restrictChat': false,
//     //         'firstMessage': message.content,
//     //         'mediaType': '',
//     //         'timestamp': FieldValue.serverTimestamp(),
//     //         'seen': false,
//     //         'fromUserId': message.senderId,
//     //         'toUserId': message.receiverId,
//     //         'newMessageTimestamp': FieldValue.serverTimestamp(),
//     //       })
//     //     : await usersAuthorRef
//     //         .doc(message.receiverId)
//     //         .collection('new_chats')
//     //         .doc(message.senderId)
//     //         .update({
//     //         'lastMessage': message.content,
//     //         'MediaType': '',
//     //         'seen': false,
//     //         'newMessageTimestamp': FieldValue.serverTimestamp(),
//     //       });
//   }

  static void addChatActivityItem({
    required String currentUserId,
    required String toUserId,
    required AccountHolderAuthor author,
    required String content,
  }) {
    // if (currentUserId != toUserId) {
    //   chatActivitiesRef.doc(toUserId).collection('chatActivities').add({
    //     'fromUserId': currentUserId,
    //     'authorName': author.userName,
    //     'toUserId': currentUserId,
    //     'seen': '',
    //     'comment': content,
    //     'timestamp': Timestamp.fromDate(DateTime.now()),
    //   });
    // }
  }

  static void deleteMessage({
    required String currentUserId,
    required String userId,
    required ChatMessage message,
  }) async {
    usersAuthorRef
        .doc(currentUserId)
        .collection('chats')
        .doc(userId)
        .collection('chatMessage')
        .doc(message.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
      usersAuthorRef.doc(currentUserId).collection('chats').doc(userId).update({
        'lastMessage': 'deleted message',
        'seen': 'seen',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
    usersAuthorRef
        .doc(userId)
        .collection('chats')
        .doc(currentUserId)
        .collection('chatMessage')
        .doc(message.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
      usersAuthorRef.doc(userId).collection('chats').doc(currentUserId).update({
        'lastMessage': 'deleted message',
        'seen': ' ',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
  }

  // static void likeMessage({
  //   required String currentUserId,
  //   required String userId,
  //   required bool liked,
  //   required ChatMessage message,
  // }) {
  //   usersAuthorRef
  //       .doc(currentUserId)
  //       .collection('chats')
  //       .doc(userId)
  //       .collection('chatMessage')
  //       .doc(message.id)
  //       .update({
  //     'liked': liked,
  //     'timestamp': message.timestamp,
  //   }).then((value) {
  //     usersAuthorRef.doc(currentUserId).collection('chats').doc(userId).update({
  //       'lastMessage': liked ? 'like' : 'unLike',
  //       'seen': 'seen',
  //       'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
  //     });
  //   });

  //   usersAuthorRef
  //       .doc(userId)
  //       .collection('chats')
  //       .doc(currentUserId)
  //       .collection('chatMessage')
  //       .doc(message.id)
  //       .update({
  //     'liked': liked,
  //     'timestamp': message.timestamp,
  //   }).then((value) {
  //     usersAuthorRef.doc(userId).collection('chats').doc(currentUserId).update({
  //       'lastMessage': liked ? 'like' : 'unLike',
  //       'seen': ' ',
  //       'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
  //     });
  //   });
  // }

  // static void addActivityItem({
  //   required AccountHolderAuthor user,
  //   required ChatMessage message,
  //   required NotificationActivityType type,
  // }) {
  //   // if (user.id != post.authorId) {
  //   // post != null
  //   //     ?

  //   // usersAuthorRef
  //   //       .doc(user.userId) // Use user's id from the loop
  //   //       .collection('new_chats')
  //   //       .doc(message.senderId);

  //   chatActivitiesRef.doc(user.userId).collection('messageActivities').add({
  //     'authorId': user.userId,
  //     'postId': message.id,
  //     'seen': false,
  //     'type': type.toString().split('.').last,
  //     'postImageUrl': '',
  //     'comment': message.content,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorName': user.userName,
  //     'authorProfileHandle': user.profileHandle,
  //     'authorVerification': user.verified,
  //   });

  //   // }
  // }

  static Stream<int> numChats(
    String currentUserId,
  ) {
    return usersAuthorRef
        .doc(currentUserId)
        .collection('chats')
        .where('seen', isEqualTo: " ")
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numChatsMessages(
    String currentUserId,
    String userId,
  ) {
    return usersAuthorRef
        .doc(userId)
        .collection('chats')
        .doc(currentUserId)
        .collection('chatMessage')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<void> shareBroadcastChatMessage({
    required ChatMessage message,
    required String chatId,
    required String currentUserId,
    required List<AccountHolderAuthor> users,
  }) async {
    String messageId = Uuid().v4();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var user in users) {
      // Create a unique chatId for each user
      final uniqueChatId = chatId.isEmpty ? messageId + user.userId! : chatId;

      final conversationRef =
          messageRef.doc(uniqueChatId).collection('conversation');

      final newChat = {
        'messageId': messageId,
        'lastMessage': message.content,
        'messageInitiator': message.senderId,
        'restrictChat': false,
        'muteMessage': false,
        'firstMessage': message.content,
        'mediaType': '',
        'timestamp': FieldValue.serverTimestamp(),
        'seen': chatId.isNotEmpty,
        'fromUserId': message.senderId,
        'toUserId': user.userId, // Use user's id from the loop
        'newMessageTimestamp': FieldValue.serverTimestamp(),
      };

      final updatedChat = {
        'lastMessage': message.content,
        'MediaType': '',
        'seen': true,
        'newMessageTimestamp': FieldValue.serverTimestamp(),
      };

      // Add the message to the conversation collection
      batch.set(conversationRef.doc(), {
        'senderId': message.senderId,
        'receiverId': user.userId,
        'content': message.content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': message.isRead,
        'isSent': message.isSent,
        'isLiked': message.isLiked,
        'sendContent':
            message.sendContent == null ? null : message.sendContent!.toMap(),
        'replyToMessage': message.replyToMessage == null
            ? null
            : message.replyToMessage!.toMap(),
        'attachments': message.attachments
            .map((attachments) => attachments.toJson())
            .toList(),
      });

      // Add or update the chat in the sender's new_chats collection
      final senderChatRef = usersAuthorRef
          .doc(message.senderId)
          .collection('new_chats')
          .doc(user.userId); // Use user's id from the loop

      chatId.isEmpty
          ? batch.set(senderChatRef, newChat)
          : batch.update(senderChatRef, updatedChat);

      // Add or update the chat in the receiver's new_chats collection
      final receiverChatRef = usersAuthorRef
          .doc(user.userId) // Use user's id from the loop
          .collection('new_chats')
          .doc(message.senderId);

      newChat['seen'] = false; // The receiver hasn't seen the message
      chatId.isEmpty
          ? batch.set(receiverChatRef, newChat)
          : batch.update(receiverChatRef, updatedChat);
    }

    // Commit the batch
    return batch.commit();
  }

  static Future<void> firstChatMessage({
    required ChatMessage message,
    required String chatId,
    required String messageId,
    required String currentUserId,
    required bool isAuthor,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final conversationRef = messageRef
        .doc(chatId.isEmpty ? messageId : chatId)
        .collection('conversation');

    final newChat = {
      'messageId': messageId,
      'lastMessage': message.content,
      'messageInitiator': message.senderId,
      'restrictChat': false,
      'muteMessage': false,
      'firstMessage': message.content,
      'mediaType': '',
      'timestamp': FieldValue.serverTimestamp(),
      'seen': isAuthor,
      'fromUserId': message.senderId,
      'toUserId': message.receiverId,
      'newMessageTimestamp': FieldValue.serverTimestamp(),
    };

    final updatedSenderChat = {
      'lastMessage': message.content,
      'MediaType': '',
      'seen': true,
      // 'seen': currentUserId == message.senderId ? true : false,
      'newMessageTimestamp': FieldValue.serverTimestamp(),
    };

    final updatedReceiverChat = {
      'lastMessage': message.content,
      'MediaType': '',
      'seen': false,
      // 'seen': currentUserId == message.senderId ? true : false,
      'newMessageTimestamp': FieldValue.serverTimestamp(),
    };

    // Add the message to the conversation collection
    batch.set(conversationRef.doc(), {
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'content': message.content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': message.isRead,
      'isSent': message.isSent,
      'isLiked': message.isLiked,
      'sendContent':
          message.sendContent == null ? null : message.sendContent!.toMap(),
      'replyToMessage': message.replyToMessage == null
          ? null
          : message.replyToMessage!.toMap(),
      'attachments': message.attachments
          .map((attachments) => attachments.toJson())
          .toList(),
    });

    // Add or update the chat in the sender's new_chats collection
    final senderChatRef = usersAuthorRef
        .doc(message.senderId)
        .collection('new_chats')
        .doc(message.receiverId);

    chatId.isEmpty
        ? batch.set(senderChatRef, newChat)
        : batch.update(senderChatRef, updatedSenderChat);

    // Add or update the chat in the receiver's new_chats collection
    final receiverChatRef = usersAuthorRef
        .doc(message.receiverId)
        .collection('new_chats')
        .doc(message.senderId);
    // newChat['seen'] = false; // The receiver hasn't seen the message
    chatId.isEmpty
        ? batch.set(receiverChatRef, newChat)
        : batch.update(receiverChatRef, updatedReceiverChat);

    // Commit the batch
    return batch.commit();
  }

  static Future<void> updateDeletedChatMessage({
    required ChatMessage message,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final updatedChat = {'lastMessage': 'Deleted message'};

    // Add or update the chat in the sender's new_chats collection
    final senderChatRef = usersAuthorRef
        .doc(message.senderId)
        .collection('new_chats')
        .doc(message.receiverId);

    batch.update(senderChatRef, updatedChat);

    // Add or update the chat in the receiver's new_chats collection
    final receiverChatRef = usersAuthorRef
        .doc(message.receiverId)
        .collection('new_chats')
        .doc(message.senderId); // The receiver hasn't seen the message
    batch.update(receiverChatRef, updatedChat);

    // Commit the batch
    return batch.commit();
  }

//   static firstChatMessage({
//     required ChatMessage message,
//     required String chatId,
//   }) async {
//     String messageId = Uuid().v4();

//     await messageRef
//         .doc(chatId.isEmpty ? messageId : chatId)
//         .collection('conversation')
//         .add({
//       'senderId': message.senderId,
//       'receiverId': message.receiverId,
//       'content': message.content,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isRead': message.isRead,
//       'isSent': message.isSent,
//       'isLiked': message.isLiked,
//       'sendContent':
//           message.sendContent == null ? null : message.sendContent!.toMap(),
//       'replyToMessage': message.replyToMessage == null
//           ? null
//           : message.replyToMessage!.toMap(),
//       'attachments':
//           message.attachments
//               .map((attachments) => attachments.toJson())
//               .toList(),
//     });
// // Add the message ID to the sender's chats subcollection
//     chatId.isEmpty
//         ? await usersAuthorRef
//             .doc(message.senderId)
//             .collection('new_chats')
//             .doc(message.receiverId)
//             .set({
//             'messageId': messageId,
//             'lastMessage': message.content,
//             'messageInitiator': message.senderId,
//             'restrictChat': false,
//             'firstMessage': message.content,
//             'mediaType': '',
//             'timestamp': FieldValue.serverTimestamp(),
//             'seen': true,
//             'fromUserId': message.senderId,
//             'toUserId': message.receiverId,
//             'newMessageTimestamp': FieldValue.serverTimestamp(),
//           })
//         : await usersAuthorRef
//             .doc(message.senderId)
//             .collection('new_chats')
//             .doc(message.receiverId)
  //   .update({
  //   'lastMessage': message.content,
  //   'MediaType': '',
  //   'seen': true,
  //   'newMessageTimestamp': FieldValue.serverTimestamp(),
  // });

//     // Add the message ID to the receiver's chats subcollection
//     chatId.isEmpty
//         ? await usersAuthorRef
//             .doc(message.receiverId)
//             .collection('new_chats')
//             .doc(message.senderId)
//             .set({
//             'messageId': messageId,
//             'lastMessage': message.content,
//             'messageInitiator': message.senderId,
//             'restrictChat': false,
//             'firstMessage': message.content,
//             'mediaType': '',
//             'timestamp': FieldValue.serverTimestamp(),
//             'seen': false,
//             'fromUserId': message.senderId,
//             'toUserId': message.receiverId,
//             'newMessageTimestamp': FieldValue.serverTimestamp(),
//           })
//         : await usersAuthorRef
//             .doc(message.receiverId)
//             .collection('new_chats')
//             .doc(message.senderId)
//             .update({
//             'lastMessage': message.content,
//             'MediaType': '',
//             'seen': false,
//             'newMessageTimestamp': FieldValue.serverTimestamp(),
//           });

// dfdfdf
// // addChatActivityItem(
// //         currentUserId: currentUserId,
// //         content: message,
// //         toUserId: userId,
// //         author: author);

// //     usersAuthorRef
// //         .doc(currentUserId)
// //         .collection('new_chats')
// //         .doc(userId)
// //         .collection('new_chatMessage')
// //         .doc(messageId)
// //         .set({
// //       'toUserId': userId,
// //       'fromUserId': currentUserId,
// //       'content': message,
// //       'replyingMessage': replyingMessage,
// //       'replyingAuthor': replyingAuthor,
// //       'mediaUrl': mediaUrl,
// //       'mediaType': '',
// //       'sendContentId': sendContentId,
// //       'sendPostType': sendPostType,
// //       'sendContentTitle': sendContentTitle,
// //       'report': '',
// //       'liked': false,
// //       'reportConfirmed': reportConfirmed,
// //       'authorId': currentUserId,
// //       'timestamp': Timestamp.fromDate(DateTime.now()),
// //     }).then((value) {
// //       usersAuthorRef.doc(currentUserId).collection('new_chats').doc(userId).set({
// //         'lastMessage': message,
// //         'messageInitiator': messageInitiator,
// //         'restrictChat': restrictChat,
// //         'firstMessage': message,
// //         'mediaType': mediaType,
// //         'timestamp': Timestamp.fromDate(DateTime.now()),
// //         'seen': 'seen',
// //         'fromUserId': currentUserId,
// //         'toUserId': userId,
// //         'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
// //       });
// //     });

// //     addChatActivityItem(
// //         currentUserId: currentUserId,
// //         content: message,
// //         toUserId: userId,
// //         author: author);

// //     usersAuthorRef
// //         .doc(userId)
// //         .collection('chats')
// //         .doc(currentUserId)
// //         .collection('chatMessage')
// //         .doc(messageId)
// //         .set({
// //       'toUserId': userId,
// //       'fromUserId': currentUserId,
// //       'content': message,
// //       'replyingMessage': replyingMessage,
// //       'replyingAuthor': replyingAuthor,
// //       'mediaUrl': mediaUrl,
// //       'mediaType': '',
// //       'sendContentId': sendContentId,
// //       'sendPostType': sendPostType,
// //       'sendContentTitle': sendContentTitle,
// //       'report': '',
// //       'liked': false,
// //       'reportConfirmed': reportConfirmed,
// //       'authorId': currentUserId,
// //       'timestamp': Timestamp.fromDate(DateTime.now()),
// //     }).then((value) {
// //       usersAuthorRef.doc(userId).collection('chats').doc(currentUserId).set({
// //     'lastMessage': message,
// //     'messageInitiator': messageInitiator,
// //     'restrictChat': restrictChat,
// //     'firstMessage': message,
// //     'mediaType': mediaType,
// //     'timestamp': Timestamp.fromDate(DateTime.now()),
// //     'seen': ' ',
// //     'fromUserId': currentUserId,
// //     'toUserId': userId,
// //     'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
// //       });
// //     });
// //     addChatActivityItem(
// //         currentUserId: currentUserId,
// //         content: message,
// //         toUserId: userId,
// //         author: author);
  // }

  static void likeMessage({
    required String currentUserId,
    required String userId,
    required String chatId,
    required bool liked,
    required ChatMessage message,
  }) {
    messageRef.doc(chatId).collection('conversation').doc(message.id).update({
      'isLiked': liked,
    }).then((value) {
      // Create a batch object
      WriteBatch batch = FirebaseFirestore.instance.batch();

// Get document references
      var newChatRef =
          usersAuthorRef.doc(currentUserId).collection('new_chats').doc(userId);
      var chatRef =
          usersAuthorRef.doc(userId).collection('new_chats').doc(currentUserId);

// Update documents in the batch
      batch.update(newChatRef, {
        'lastMessage': liked ? 'like' : 'unLike',
        'seen': true,
        'newMessageTimestamp': FieldValue.serverTimestamp(),
      });

      batch.update(chatRef, {
        'lastMessage': liked ? 'like' : 'unLike',
        'seen': false,
        'newMessageTimestamp': FieldValue.serverTimestamp(),
      });

// Commit the batch
      batch.commit();
    });
  }

  static void chatMessage(
      {required String currentUserId,
      required String userId,
      // required Chat chat,
      required String replyingMessage,
      required String replyingAuthor,
      required AccountHolderAuthor author,
      required String mediaUrl,
      required String sendContentId,
      required String sendPostType,
      required String message,
      required String sendContentTitle,
      required String mediaType,
      required String liked,
      required String reportConfirmed}) {
    String messageId = Uuid().v4();
    usersAuthorRef
        .doc(currentUserId)
        .collection('chats')
        .doc(userId)
        .collection('chatMessage')
        .doc(messageId)
        .set({
      'toUserId': userId,
      'fromUserId': currentUserId,
      'content': message,
      'replyingMessage': replyingMessage,
      'replyingAuthor': replyingAuthor,
      'mediaUrl': mediaUrl,
      'sendContentId': sendContentId,
      'sendContentTitle': sendContentTitle,
      'mediaType': '',
      'sendPostType': sendPostType,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersAuthorRef.doc(currentUserId).collection('chats').doc(userId).update({
        'lastMessage': message,
        'seen': 'seen',
        'MediaType': mediaType,
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });

    usersAuthorRef
        .doc(userId)
        .collection('chats')
        .doc(currentUserId)
        .collection('chatMessage')
        .doc(messageId)
        .set({
      'toUserId': userId,
      'fromUserId': currentUserId,
      'content': message,
      'replyingMessage': replyingMessage,
      'replyingAuthor': replyingAuthor,
      'mediaUrl': mediaUrl,
      'sendContentId': sendContentId,
      'mediaType': '',
      'sendPostType': sendPostType,
      'sendContentTitle': sendContentTitle,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersAuthorRef.doc(userId).collection('chats').doc(currentUserId).update({
        'lastMessage': message,
        'MediaType': mediaType,
        'seen': ' ',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
    addChatActivityItem(
        currentUserId: currentUserId,
        content: message,
        toUserId: userId,
        author: author);
  }

  static void likePost(
      {required AccountHolderAuthor user,
      required Post post,
      required NotificationActivityType type}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postRef.get().then((doc) {
      int likeCount = doc['likeCount'];
      postRef.update({'likeCount': likeCount + 1});
      likesRef.doc(post.id).collection('postLikes').doc(user.userId).set({
        'uid': user.userId,
      });
      addActivityItem(
          user: user,
          post: post,
          comment: null,
          type: type,
          event: null,
          followerUser: null,
          advicedUserId: '');
    });
  }

  // static void likeThought({
  //   required AccountHolder user,
  //   required Thought thought,
  //   required Forum forum,
  // }) {
  //   thoughtsRef
  //       .doc(forum.id)
  //       .collection('forumThoughts')
  //       .doc(thought.id)
  //       .update({'likeCount': FieldValue.increment(1)});
  //   //     .update({
  //   //   'likeCount': thought.count! + 1,
  //   // });

  //   thoughtsLikeRef
  //       .doc(thought.id)
  //       .collection('thoughtLikes')
  //       .doc(user.id)
  //       .set({
  //     'uid': user.id,
  //   });
  //   // addActivityThoughtLikeItem(
  //   //   user: user,
  //   //   forum: forum,
  //   //   thought: thought,
  //   //   isThoughtLiked: true,
  //   // );
  // }

  // static void unlikeThought(
  //     {required AccountHolder user,
  //     required Forum forum,
  //     required Thought thought}) {
  //   thoughtsRef
  //       .doc(forum.id)
  //       .collection('forumThoughts')
  //       .doc(thought.id)
  //       .update({'likeCount': FieldValue.increment(-1)});
  //   //     .update({
  //   //   'likeCount': thought.count! - 1,
  //   // });
  //   thoughtsLikeRef
  //       .doc(thought.id)
  //       .collection('thoughtLikes')
  //       .doc(user.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void createPost(Post post) {
  //   String docId =
  //       eventsRef.doc(post.authorId).collection('userPosts').doc().id;
  //   postsRef.doc(post.authorId).collection('userPosts').doc(docId).set({
  //     'postId': docId,
  //     'blurHash': post.blurHash,
  //     'imageUrl': post.imageUrl,
  //     'caption': post.caption,
  //     'artist': post.artist,
  //     'punch': post.punch,
  //     'hashTag': post.hashTag,
  //     'musicLink': post.musicLink,
  //     'likeCount': post.likeCount,
  //     'mediaType': post.mediaType,
  //     'report': post.report,
  //     'reportConfirmed': post.reportConfirmed,
  //     'disLikeCount': post.disLikeCount,
  //     'authorId': post.authorId,
  //     'peopleTagged': post.peopleTagged,
  //     'disbleSharing': post.disbleSharing,
  //     'disableReaction': post.disableReaction,
  //     'disableVibe': post.disableVibe,
  //     'timestamp': post.timestamp,
  //     'authorHandleType': post.authorHandleType,
  //     'authorIdProfileImageUrl': post.authorIdProfileImageUrl,
  //     'authorName': post.authorName,
  //     'authorVerification': post.authorVerification,
  //   });
  //   allPostsRef.doc(docId).set({
  //     'postId': docId,
  //     'blurHash': post.blurHash,
  //     'imageUrl': post.imageUrl,
  //     'caption': post.caption,
  //     'artist': post.artist,
  //     'punch': post.punch,
  //     'hashTag': post.hashTag,
  //     'musicLink': post.musicLink,
  //     'likeCount': post.likeCount,
  //     'mediaType': post.mediaType,
  //     'report': post.report,
  //     'reportConfirmed': post.reportConfirmed,
  //     'disLikeCount': post.disLikeCount,
  //     'authorId': post.authorId,
  //     'peopleTagged': post.peopleTagged,
  //     'disbleSharing': post.disbleSharing,
  //     'disableReaction': post.disableReaction,
  //     'disableVibe': post.disableVibe,
  //     'timestamp': post.timestamp,
  //     'authorHandleType': post.authorHandleType,
  //     'authorIdProfileImageUrl': post.authorIdProfileImageUrl,
  //     'authorName': post.authorName,
  //     'authorVerification': post.authorVerification,
  //   });
  //   // kpiStatisticsRef
  //   //     .doc('0SuQxtu52SyYjhOKiLsj')
  //   //     .update({'createdMoodPunched': FieldValue.increment(1)});
  // }

  // static void editPunch(Post post) {
  //   postsRef.doc(post.authorId).collection('userPosts').doc(post.id).update({
  //     'imageUrl': post.imageUrl,
  //     'caption': post.caption,
  //     'blurHash': post.blurHash,
  //     'artist': post.artist,
  //     'punch': post.punch,
  //     'hashTag': post.hashTag,
  //     'musicLink': post.musicLink,
  //     'likeCount': post.likeCount,
  //     'disLikeCount': post.disLikeCount,
  //     'authorId': post.authorId,
  //     'peopleTagged': post.peopleTagged,
  //     'disbleSharing': post.disbleSharing,
  //     'disableReaction': post.disableReaction,
  //     'disableVibe': post.disableVibe,
  //     'timestamp': post.timestamp,
  //   });
  // }

  static Future<void> createEvent(Event event) async {
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> eventData = event.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the event to 'eventsRef'
    DocumentReference eventRef =
        eventsRef.doc(event.authorId).collection('userEvents').doc(event.id);
    batch.set(eventRef, eventData);

    // Add the event to 'allEventsRef'
    DocumentReference allEventRef = allEventsRef.doc(event.id);
    // FirebaseFirestore.instance.collection('new_allEvents').doc(event.id);
    batch.set(allEventRef, eventData);

    // Add the event to 'eventsChatRoomsRef'
    DocumentReference chatRoomRef = eventsChatRoomsRef.doc(event.id);
    batch.set(chatRoomRef, {
      'title': event.title,
      'linkedEventId': event.id,
      'imageUrl': event.imageUrl,
      'report': event.report,
      'reportConfirmed': event.reportConfirmed,
      'isClossed': false,
      'timestamp': event.timestamp,
    });

    // Add addUserTicketIdRef to the transaction
    final userTicketIdDocRef = userTicketIdRef
        .doc(event.authorId)
        .collection('eventInvite')
        .doc(event.id);

    batch.set(userTicketIdDocRef, {
      'eventId': event.id,
      'lastMessage': '',
      'isNew': false,
      'isSeen': false,
      'muteNotification': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final Map<String, dynamic> ticketOrderData = {
      'orderId': event.id,
      'eventId': event.id,
      'validated': true,
      'timestamp': FieldValue.serverTimestamp(),
      'eventTimestamp': event.startDate,
      'entranceId': event.id,
      'eventImageUrl': event.imageUrl,
      'isInvited': false,
      'eventTitle': event.title,
      'orderNumber': event.id,
      'refundRequestStatus': '',
      'tickets': [],
      'total': 0,
      'userOrderId': event.authorId,
      'purchaseReferenceId': event.id,
    };

    final eventInviteDocRef = newEventTicketOrderRef
        .doc(event.id)
        .collection('eventInvite')
        .doc(event.authorId);

    final userInviteDocRef = userInviteRef
        .doc(event.authorId)
        .collection('eventInvite')
        .doc(event.id);

    // Add addUserTicketIdRef to the transaction

    batch.set(eventInviteDocRef, ticketOrderData);
    batch.set(userInviteDocRef, ticketOrderData);

    // Commit the batch
    await batch.commit();

    // Fetch users in the same city
    QuerySnapshot querySnapshot = await usersLocationSettingsRef
        .where('city', isEqualTo: event.city)
        .where('country', isEqualTo: event.country)
        .get();

    // Prepare the batch for user activities
    WriteBatch activitiesBatch = FirebaseFirestore.instance.batch();

    // Loop over the users and create an activity document for each one
    for (var doc in querySnapshot.docs) {
      // Get the user's ID
      String userId = doc.id;

      // Create the activity document
      if (userId == event.authorId) {
        DocumentReference userActivityRef =
            activitiesRef.doc(userId).collection('userActivities').doc();
        activitiesBatch.set(userActivityRef, {
          'authorId': event.authorId,
          'postId': event.id,
          'seen': false,
          'type': 'newEventInNearYou',
          'postImageUrl': event.imageUrl,
          'comment': MyDateFormat.toDate(event.startDate.toDate()) +
              '\n${event.title}',
          'timestamp': Timestamp.fromDate(DateTime.now()),
          'authorProfileImageUrl': '',
          'authorName': 'New event in ${event.city}',
          'authorProfileHandle': '',
          'authorVerification': false
        });
      }
    }

    // Commit the batch
    await activitiesBatch.commit();
  }

  static Future<void> editEvent(Event event) async {
    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    Map<String, dynamic> eventData = {
      'title': event.title,
      'theme': event.theme,
      'startDate': event.startDate,
      'address': event.address,
      'schedule': event.schedule.map((schedule) => schedule.toJson()).toList(),
      'ticket': event.ticket.map((ticket) => ticket.toJson()).toList(),
      'taggedPeople': event.taggedPeople
          .map((taggedPeople) => taggedPeople.toJson())
          .toList(),
      'termsAndConditions': event.termsAndConditions,
      'authorName': event.authorName,
      'type': event.type,
      'category': event.category,
      'rate': event.rate,
      'venue': event.venue,
      'dressCode': event.dressCode,
      'time': event.time,
      'previousEvent': event.previousEvent,
      'triller': event.triller,
      'city': event.city,
      'country': event.country,
      'virtualVenue': event.virtualVenue,
      'ticketSite': event.ticketSite,
      'clossingDay': event.clossingDay,
    };

    // Update the event in 'eventsRef'
    DocumentReference eventRef =
        eventsRef.doc(event.authorId).collection('userEvents').doc(event.id);
    batch.update(eventRef, eventData);

    // Update the event in 'allEventsRef'
    DocumentReference allEventRef = allEventsRef.doc(event.id);
    batch.update(allEventRef, eventData);

    // Update the event in 'eventsChatRoomsRef'
    DocumentReference chatRoomRef = eventsChatRoomsRef.doc(event.id);
    batch.update(chatRoomRef, {
      'title': event.title,
      'timestamp': event.timestamp,
    });

    // Get all event invites and process them in batches
    const int batchSize = 500; // Firestore limit is 500 operations per batch
    int operationCount = 0;

    Query query = newEventTicketOrderRef
        .doc(event.id)
        .collection('eventInvite')
        .orderBy(FieldPath.documentId)
        .limit(batchSize);

    DocumentSnapshot? lastDoc;
    do {
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        break;
      }

      for (var doc in querySnapshot.docs) {
        String userId = doc.id;

        // Update the user's invites
        DocumentReference userInvitesRef =
            userInviteRef.doc(userId).collection('eventInvite').doc(event.id);
        batch.update(userInvitesRef, {
          'eventTimestamp': event.startDate,
          'eventTitle': event.title,
        });

        // Update the event invites
        DocumentReference newEventsTicketOrderRef = newEventTicketOrderRef
            .doc(event.id)
            .collection('eventInvite')
            .doc(userId);
        batch.update(newEventsTicketOrderRef, {
          'eventTimestamp': event.startDate,
          'eventTitle': event.title,
        });

        operationCount += 2; // Two operations for each invite

        // Check if user is the author and add user activity
        if (userId == event.authorId) {
          DocumentReference userActivityRef =
              activitiesRef.doc(userId).collection('userActivities').doc();
          batch.set(userActivityRef, {
            'authorId': event.authorId,
            'postId': event.id,
            'seen': false,
            'type': 'eventUpdate',
            'postImageUrl': event.imageUrl,
            'comment':
                'Certain information about this event have been modified',
            'timestamp': Timestamp.fromDate(DateTime.now()),
            'authorProfileImageUrl': '',
            'authorName': 'Event informaiton updated',
            'authorProfileHandle': '',
            'authorVerification': false
          });
          operationCount++; // One operation for the user activity
        }

        // Commit batch if limit is reached and start a new batch
        if (operationCount >= batchSize) {
          await batch.commit();
          batch = FirebaseFirestore.instance.batch();
          operationCount = 0;
        }
      }

      // Remember the last document processed
      lastDoc = querySnapshot.docs.last;
    } while (lastDoc != null);

    // Commit any remaining operations in the final batch
    if (operationCount > 0) {
      await batch.commit();
    }
  }



  

  static Future<void> validateTicket(Event event, String ticketOrderId) async {
    final entranceId = Uuid().v4();
    final eventInviteRef =
        newEventTicketOrderRef.doc(event.id).collection('eventInvite');

    final ticketQuerySnapshot =
        await eventInviteRef.where('orderId', isEqualTo: ticketOrderId).get();

    final ticketDocs = ticketQuerySnapshot.docs;

    if (ticketDocs.isNotEmpty) {
      final ticketDoc = ticketDocs.first;
      final ticketData = ticketDoc.data();
      final validated = ticketData['validated'] ?? false;

      if (!validated) {
        final batch = FirebaseFirestore.instance.batch();
        final userOrderId = ticketData['userOrderId'];

        final eventInviteDocRef = eventInviteRef.doc(userOrderId);

        final userInviteDocRef = FirebaseFirestore.instance
            .collection('userInvite')
            .doc(userOrderId)
            .collection('eventInvite')
            .doc(event.id);

        final updatedData = {
          'entranceId': entranceId,
          'validated': true,
        };

        batch.update(eventInviteDocRef, updatedData);
        batch.update(userInviteDocRef, updatedData);

        await batch.commit();
      }
    }
  }

  static Future<void> requestRefund(
      Event event, RefundModel refund, AccountHolderAuthor currentUser) async {
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> refundData = refund.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the refund request to 'allRefundRequests' collection
    DocumentReference allRefundRequestRef = FirebaseFirestore.instance
        .collection('allRefundRequests')
        .doc(refund.id);

    DocumentReference userRefundRequestRef = FirebaseFirestore.instance
        .collection('userRefundRequests')
        .doc(currentUser.userId)
        .collection('refundRequests')
        .doc(refund.id);

    DocumentReference eventRefundRequestRef = FirebaseFirestore.instance
        .collection('eventRefundRequests')
        .doc(event.id)
        .collection('refundRequests')
        .doc(refund.id);

    batch.set(allRefundRequestRef, refundData);

    batch.set(userRefundRequestRef, refundData);
    batch.set(eventRefundRequestRef, refundData);

    final eventInviteDocRef = newEventTicketOrderRef
        .doc(event.id)
        .collection('eventInvite')
        .doc(currentUser.userId);

    final userInviteDocRef = userInviteRef
        .doc(currentUser.userId)
        .collection('eventInvite')
        .doc(event.id);

    batch.update(eventInviteDocRef, {
      'refundRequestStatus': 'pending',
    });
    batch.update(userInviteDocRef, {
      'refundRequestStatus': 'pending',
    });

    DocumentReference userActivityRef = FirebaseFirestore.instance
        .collection('new_activities')
        .doc(event.authorId)
        .collection('userActivities')
        .doc();
    batch.set(userActivityRef, {
      'authorId': currentUser.userId,
      'postId': event.id,
      'seen': false,
      'type': 'refundRequested',
      'postImageUrl': event.imageUrl,
      'comment': 'For: ${event.title}',
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'authorProfileImageUrl': '',
      'authorName': 'Refund requested ',
      'authorProfileHandle': '',
      'authorVerification': false
    });

    // Commit the batch
    await batch.commit();
  }

  // static Future<bool> createEvent(Event event, String ticketOrderId) async {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   String entranceId = Uuid().v4();
  //   TicketOrderModel ticket = newEventTicketOrderRef
  //       .doc(event.id)
  //       .collection('eventInvite')
  //       .where('orderId', isEqualTo: ticketOrderId);

  //   if (!ticket.validated) {
  //     final eventInviteDocRef = newEventTicketOrderRef
  //         .doc(event.id)
  //         .collection('eventInvite')
  //         .doc(ticket.userOrderId);

  //     final userInviteDocRef = userInviteRef
  //         .doc(ticket.userOrderId)
  //         .collection('eventInvite')
  //         .doc(event.id);

  //     final updatedChat = {
  //       'entranceId': entranceId,
  //       'validated': true,
  //     };

  //     // Add addUserTicketIdRef to the transaction

  //     batch.update(eventInviteDocRef, updatedChat);
  //     batch.update(userInviteDocRef, updatedChat);
  //   }

  //   // Commit the batch
  //   await batch.commit();
  // }

  // static createEvent(Event event) async {
  //   // String docId =
  //   //     eventsRef.doc(event.authorId).collection('userEvents').doc().id;
  //   eventsRef.doc(event.authorId).collection('userEvents').doc(event.id).set({
  //     'id': event.id,
  //     'address': event.address,
  //     'isTicketed': event.isTicketed,
  //     'maxAttendees': event.maxAttendees,
  //     'schedule': event.schedule.map((schedule) => schedule.toJson()).toList(),
  //     'ticket': event.ticket.map((ticket) => ticket.toJson()).toList(),
  //     'taggedPeople': event.taggedPeople
  //         .map((taggedPeople) => taggedPeople.toJson())
  //         .toList(),
  //     'ticketOrder': [],
  //     'offers': [],
  //     'termsAndConditions': event.termsAndConditions,
  //     'startDate': event.startDate,
  //     'authorName': event.authorName,
  //     'imageUrl': event.imageUrl,
  //     'title': event.title.toUpperCase(),
  //     'type': event.type,
  //     'category': event.category,
  //     'rate': event.rate,
  //     'venue': event.venue,
  //     'theme': event.theme,
  //     'dressCode': event.dressCode,
  //     'time': event.time,
  //     'report': event.report,
  //     'reportConfirmed': event.reportConfirmed,
  //     'authorId': event.authorId,
  //     'timestamp': event.timestamp,
  //     'previousEvent': event.previousEvent,
  //     'triller': event.triller,
  //     'city': event.city,
  //     'country': event.country,
  //     'virtualVenue': event.virtualVenue,
  //     'ticketSite': event.ticketSite,
  //     'isVirtual': event.isVirtual,
  //     'isPrivate': event.isPrivate,
  //     'blurHash': event.blurHash,
  //     'isFree': event.isFree,
  //     'isCashPayment': event.isCashPayment,
  //     'showToFollowers': event.showToFollowers,
  //     'showOnExplorePage': false,
  //     'clossingDay': event.clossingDay,
  //     'dynamicLink': event.dynamicLink,
  //   });

  //   allEventsRef.doc(event.id).set({
  //     'id': event.id,
  //     'address': event.address,
  //     'isTicketed': event.isTicketed,
  //     'maxAttendees': event.maxAttendees,
  //     'schedule': event.schedule.map((schedule) => schedule.toJson()).toList(),
  //     'ticket': event.ticket.map((ticket) => ticket.toJson()).toList(),
  //     'taggedPeople': event.taggedPeople
  //         .map((taggedPeople) => taggedPeople.toJson())
  //         .toList(),
  //     'ticketOrder': [],
  //     'termsAndConditions': event.termsAndConditions,
  //     'offers': [],
  //     'authorName': event.authorName,
  //     'imageUrl': event.imageUrl,
  //     'title': event.title.toLowerCase(),
  //     'type': event.type,
  //     'rate': event.rate,
  //     'venue': event.venue,
  //     'theme': event.theme,
  //     'startDate': event.startDate,
  //     'dressCode': event.dressCode,
  //     'time': event.time,
  //     'report': event.report,
  //     'reportConfirmed': event.reportConfirmed,
  //     'authorId': event.authorId,
  //     'timestamp': event.timestamp,
  //     'previousEvent': event.previousEvent,
  //     'category': event.category,
  //     'triller': event.triller,
  //     'city': event.city,
  //     'country': event.country,
  //     'virtualVenue': event.virtualVenue,
  //     'ticketSite': event.ticketSite,
  //     'isVirtual': event.isVirtual,
  //     'isPrivate': event.isPrivate,
  //     'blurHash': event.blurHash,
  //     'isFree': event.isFree,
  //     'isCashPayment': event.isCashPayment,
  //     'showToFollowers': event.showToFollowers,
  //     'showOnExplorePage': false,
  //     'clossingDay': event.clossingDay,
  //     'dynamicLink': event.dynamicLink,
  //   });
  //   eventsChatRoomsRef.doc(event.id).set({
  //     'title': event.title,
  //     'linkedEventId': event.id,
  //     'imageUrl': event.imageUrl,
  //     'report': event.report,
  //     'reportConfirmed': event.reportConfirmed,
  //     'isClossed': false,
  //     'timestamp': event.timestamp,
  //   });

  // Fetch users in the same city
  //   QuerySnapshot querySnapshot = await usersAuthorRef
  //       .where('city', isEqualTo: event.city)
  //       .where('country', isEqualTo: event.country)
  //       .get();

  //   // Loop over the users and create an activity document for each one
  //   for (var doc in querySnapshot.docs) {
  //     // Get the user's ID
  //     String userId = doc.id;
  //     // Create the activity document
  //     activitiesRef.doc(userId).collection('userActivities').add({
  //       'authorId': event.authorId,
  //       'postId': event.id,
  //       'seen': false,
  //       'type': 'newEventInNearYou',
  //       'postImageUrl': event.imageUrl,
  //       'comment':
  //           MyDateFormat.toDate(event.startDate.toDate()) + '\n${event.title}',
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': '',
  //       'authorName': 'New event in ${event.city}',
  //       'authorProfileHandle': '',
  //       'authorVerification': ''
  //     });
  //     // }
  //   }
  // }

  // static void editEvent(Event event) {
  //   eventsRef
  //       .doc(event.authorId)
  //       .collection('userEvents')
  //       .doc(event.id)
  //       .update({
  //     'title': event.title,
  //     'rate': event.rate,
  //     'venue': event.venue,
  //     'theme': event.theme,
  //     'dressCode': event.dressCode,
  //     // 'dj': event.dj,
  //     // 'guess': event.guess,
  //     // 'host': event.host,
  //     // 'artist': event.artist,
  //     'previousEvent': event.previousEvent,
  //     'clossingDay': event.clossingDay,
  //     'triller': event.triller,
  //     'city': event.city,
  //     'country': event.country,
  //     'ticketSite': event.ticketSite,
  //     'blurHash': event.blurHash,
  //   });
  // }

  // static void createForum(Forum forum) {
  //   String docId =
  //       eventsRef.doc(forum.authorId).collection('userForums').doc().id;
  // forumsRef.doc(forum.authorId).collection('userForums').doc(docId).set({
  //   'title': forum.title,
  //   'authorName': forum.authorName,
  //   'id': docId,
  //   'isPrivate': forum.isPrivate,
  //   'showOnExplorePage': false,
  //   'subTitle': forum.subTitle,
  //   'authorId': forum.authorId,
  //   'mediaType': forum.mediaType,
  //   'mediaUrl': forum.mediaUrl,
  //   'report': forum.report,
  //   'forumType': forum.forumType,
  //   'reportConfirmed': forum.reportConfirmed,
  //   'timestamp': forum.timestamp,
  //   'linkedContentId': forum.linkedContentId
  // });
  //   allForumsRef.doc(docId).set({
  //     'title': forum.title,
  //     'authorName': forum.authorName,
  //     'showOnExplorePage': false,
  //     'id': docId,
  //     'isPrivate': forum.isPrivate,
  //     'subTitle': forum.subTitle,
  //     'authorId': forum.authorId,
  //     'mediaType': forum.mediaType,
  //     'mediaUrl': forum.mediaUrl,
  //     'report': forum.report,
  //     'forumType': forum.forumType,
  //     'reportConfirmed': forum.reportConfirmed,
  //     'timestamp': forum.timestamp,
  //     'linkedContentId': forum.linkedContentId
  //   });
  //   kpiStatisticsRef
  //       .doc('0SuQxtu52SyYjhOKiLsj')
  //       .update({'createForum': FieldValue.increment(1)});
  // }

  // static void editForum(Forum forum) {
  //   forumsRef
  //       .doc(forum.authorId)
  //       .collection('userForums')
  //       .doc(forum.id)
  //       .update({
  //     'title': forum.title,
  //     'isPrivate': forum.isPrivate,
  //     'subTitle': forum.subTitle,
  //     'mediaType': forum.mediaType,
  //     'mediaUrl': forum.mediaUrl,
  //   });
  // }

  static void requestVerification(Verification verification) {
    verificationRef.doc(verification.userId).set({
      'userId': verification.userId,
      'verificationType': verification.verificationType,
      'newsCoverage': verification.newsCoverage,
      'govIdType': verification.govIdType,
      'email': verification.email,
      'phoneNumber': verification.phoneNumber,
      'profileHandle': verification.profileHandle,
      'gvIdImageUrl': verification.gvIdImageUrl,
      'website': verification.website,
      'socialMedia': verification.socialMedia,
      'wikipedia': verification.wikipedia,
      'validationImage': verification.validationImage,
      'otherLink': verification.otherLink,
      'status': verification.status,
      'rejectedReason': verification.rejectedReason,
      'timestamp': verification.timestamp,
    });
  }

  static void createSuggestion(Suggestion suggestion) {
    suggestionsRef.add({
      'suggesttion': suggestion.suggesttion,
      'authorId': suggestion.authorId,
      'timestamp': suggestion.timestamp,
    });
  }

  static void createSurvey(Survey survey) {
    surveysRef.add({
      'lessHelpfulFeature': survey.lessHelpfulFeature,
      'mostHelpfulFeature': survey.mostHelpfulFeature,
      'moreImprovement': survey.moreImprovement,
      'overRallSatisfaction': survey.overRallSatisfaction,
      'suggesttion': survey.suggesttion,
      'authorId': survey.authorId,
      'timestamp': survey.timestamp,
    });
  }

  static void createReportContent(ReportContents reportContents) {
    reportContentsRef.add({
      'contentId': reportContents.contentId,
      'contentType': reportContents.contentType,
      'reportType': reportContents.reportType,
      'repotedAuthorId': reportContents.repotedAuthorId,
      'parentContentId': reportContents.parentContentId,
      'reportConfirmation': reportContents.reportConfirmation,
      'authorId': reportContents.authorId,
      'timestamp': reportContents.timestamp,
      'comment': reportContents.comment,
    });
  }

  // static void deletePunch({
  //   required String currentUserId,
  //   required Post post,
  // }) async {
  //   print(post.id);
  //   postsRef
  //       .doc(currentUserId)
  //       .collection('userPosts')
  //       .doc(post.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   QuerySnapshot activitySnapShot = await activitiesRef
  //       .doc(currentUserId)
  //       .collection('userActivities')
  //       .where('postId', isEqualTo: post.id)
  //       .get();

  //   activitySnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   QuerySnapshot commentsSnapShot =
  //       await commentsRef.doc(post.id).collection('postComments').get();
  //   commentsSnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   // delet punch likes
  //   QuerySnapshot likeSnapshot =
  //       await likesRef.doc(post.id).collection('postLikes').get();
  //   likeSnapshot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   QuerySnapshot disLikeSnapshot =
  //       await disLikesRef.doc(post.id).collection('postDisLikes').get();
  //   disLikeSnapshot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void deleteForum({
  //   required String currentUserId,
  //   required Forum forum,
  //   required String photoId,
  // }) async {
  //   // Remove user from current user's following collection
  //   forumsRef
  //       .doc(currentUserId)
  //       .collection('userForums')
  //       .doc(forum.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   // delete activity image
  //   QuerySnapshot activitySnapShot = await activitiesForumRef
  //       .doc(currentUserId)
  //       .collection('userActivitiesForum')
  //       .where('forumId', isEqualTo: forum.id)
  //       .get();

  //   activitySnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   // delet forum thoughts
  //   QuerySnapshot thoughtsSnapShot =
  //       await thoughtsRef.doc(forum.id).collection('forumThoughts').get();
  //   thoughtsSnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  static Future<void> deleteEvent({
    required String currentUserId,
    required Event event,
    required String photoId,
  }) async {
    // Helper function to delete documents in batches
    Future<void> deleteInBatches(Query query) async {
      while (true) {
        QuerySnapshot querySnapshot = await query.limit(500).get();
        if (querySnapshot.docs.isEmpty) {
          return;
        }

        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (final doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      }
    }

    // Delete event tickets
    await deleteInBatches(
        newEventTicketOrderRef.doc(event.id).collection('eventInvite'));

    // Delete sent event invites
    await deleteInBatches(
        sentEventIviteRef.doc(event.id).collection('eventInvite'));

    // Delete asks
    await deleteInBatches(asksRef.doc(event.id).collection('eventAsks'));

    // Delete chat room
    DocumentSnapshot chatRoomDoc = await eventsChatRoomsRef.doc(event.id).get();
    if (chatRoomDoc.exists) {
      await chatRoomDoc.reference.delete();
    }

    // Delete chat room conversations
    await deleteInBatches(
        eventsChatRoomsConverstionRef.doc(event.id).collection('roomChats'));

    // Delete user event
    DocumentSnapshot userEventDoc = await eventsRef
        .doc(currentUserId)
        .collection('userEvents')
        .doc(event.id)
        .get();
    if (userEventDoc.exists) {
      await userEventDoc.reference.delete();
    }
  }

  // static void deleteEvent({
  //   required String currentUserId,
  //   required Event event,
  //   required String photoId,
  // }) async {

  //   final eventTicketQuerySnapshot = await newEventTicketOrderRef
  //       .doc(event.id)
  //       .collection('eventInvite')
  //       .get();

  //   for (final doc in eventTicketQuerySnapshot.docs) {
  //     await doc.reference.delete();
  //   }

  //   final sentQuerySnapshot =
  //       await sentEventIviteRef.doc(event.id).collection('eventInvite').get();

  //   for (final doc in sentQuerySnapshot.docs) {
  //     await doc.reference.delete();
  //   }

  //   final askQuerySnapshot =
  //       await asksRef.doc(event.id).collection('eventAsks').get();
  //   for (final doc in askQuerySnapshot.docs) {
  //     await doc.reference.delete();
  //   }

  //   await eventsChatRoomsRef.doc(event.id).get().then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   final queryeventRoomSnapshot = await eventsChatRoomsConverstionRef
  //       .doc(event.id)
  //       .collection('roomChats')
  //       .get();

  //   for (final doc in queryeventRoomSnapshot.docs) {
  //     await doc.reference.delete();
  //   }

  //   eventsRef
  //       .doc(currentUserId)
  //       .collection('userEvents')
  //       .doc(event.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  // }

  static void followUser(
      {required String currentUserId,
      required AccountHolderAuthor user,
      required AccountHolderAuthor currentUser}) {
    // Add use to current user's following collection
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(user.userId)
        .set({
      'userId': user.userId,
    });

    // addActivityFollowerItem(
    //   currentUserId: currentUserId,
    //   user: user,
    //   currentUser: currentUser,
    // );

    //Add current user to user's followers collection
    followersRef
        .doc(user.userId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({
      'userId': currentUserId,
    });

    addActivityItem(
      user: currentUser,
      event: null, comment: "${user.userName} Started following you",
      followerUser: user,
      post: null,
      type: NotificationActivityType.follow, advicedUserId: '',
      // ask: ask,
      // commonId: commonId,
    );
  }

  static void unfollowUser(
      {required String currentUserId, required String userId}) async {
    // Remove user from current user's following collection
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    //Remove current user from user's followers collection
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // deletedFollowerActivity(
    //   currentUserId: currentUserId,
    //   userId: userId,
    // );
  }

  // static void deletedFollowerActivity(
  //     {required String currentUserId, required String userId}) async {
  //   QuerySnapshot activitySnapShot = await activitiesFollowerRef
  //       .doc(userId)
  //       .collection('activitiesFollower')
  //       .where('fromUserId', isEqualTo: currentUserId)
  //       .get();
  //   activitySnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  static Future<bool> isFollowingUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<bool> isAFollowerUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot followingDoc = await followingRef
        .doc(userId)
        .collection('userFollowing')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('userFollowing').get();
    return followingSnapshot.docs.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('userFollowers').get();
    return followersSnapshot.docs.length - 1;
  }

  static void blockUser(
      {required String currentUserId,
      required AccountHolderAuthor user,
      required String userId}) {
    usersBlockedRef
        .doc(currentUserId)
        .collection('userBlocked')
        .doc(userId)
        .set({
      'uid': userId,
    });

    userBlockingRef
        .doc(userId)
        .collection('userBlocking')
        .doc(currentUserId)
        .set({
      'uid': currentUserId,
    });
  }

  static Future<bool> isBlockedUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot followingDoc = await userBlockingRef
        .doc(currentUserId)
        .collection('userBlocking')
        .doc(userId)
        .get();
    return followingDoc.exists;
  }

  static Future<bool> isBlokingUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot blockDoc = await usersBlockedRef
        .doc(currentUserId)
        .collection('userBlocked')
        .doc(userId)
        .get();
    return blockDoc.exists;
  }

  static void unBlockUser(
      {required String currentUserId, required String userId}) async {
    // Remove user from current user's following collection
    usersBlockedRef
        .doc(currentUserId)
        .collection('userBlocked')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  // static void possitivelyRateUser(
  //     {required String currentUserId, required String userId}) {
  //   possitiveRatingRef
  //       .doc(currentUserId)
  //       .collection('userPossitiveRating')
  //       .doc(userId)
  //       .set({
  //     'uid': userId,
  //   });

  //   possitveRatedRef
  //       .doc(userId)
  //       .collection('userPossitiveRated')
  //       .doc(currentUserId)
  //       .set({
  //     'uid': currentUserId,
  //   });
  // }

  // static void unPossitivelyRateUser(
  //     {required String currentUserId, required String userId}) {
  //   possitiveRatingRef
  //       .doc(currentUserId)
  //       .collection('userPossitiveRating')
  //       .doc(userId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   possitveRatedRef
  //       .doc(userId)
  //       .collection('userPossitiveRated')
  //       .doc(currentUserId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void negativelyRateUser(
  //     {required String currentUserId, required String userId}) {
  //   negativeRatingRef
  //       .doc(currentUserId)
  //       .collection('userNegativeRating')
  //       .doc(userId)
  //       .set({
  //     'uid': userId,
  //   });
  //   negativeRatedRef
  //       .doc(userId)
  //       .collection('userNegativeRated')
  //       .doc(currentUserId)
  //       .set({
  //     'uid': currentUserId,
  //   });
  // }

  // static void unNegativelyRateUser(
  //     {required String currentUserId, required String userId}) {
  //   negativeRatingRef
  //       .doc(currentUserId)
  //       .collection('userNegativeRating')
  //       .doc(userId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   negativeRatedRef
  //       .doc(userId)
  //       .collection('userNegativeRated')
  //       .doc(currentUserId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static Future<bool> isPossitivelyRatingUser(
  //     {required String currentUserId, required String userId}) async {
  //   DocumentSnapshot followingDoc = await possitveRatedRef
  //       .doc(userId)
  //       .collection('userPossitiveRated')
  //       .doc(currentUserId)
  //       .get();
  //   return followingDoc.exists;
  // }

  // static Future<int> numPossitiveRating(String userId) async {
  //   QuerySnapshot ratingSnapshot = await possitiveRatingRef
  //       .doc(userId)
  //       .collection('userPossitiveRating')
  //       .get();
  //   return ratingSnapshot.docs.length;
  // }

  // static Future<int> numPosstiveRated(String userId) async {
  //   QuerySnapshot ratedSnapshot = await possitveRatedRef
  //       .doc(userId)
  //       .collection('userPossitiveRated')
  //       .get();
  //   return ratedSnapshot.docs.length;
  // }

  // static Future<bool> isNegativelyRatingUser(
  //     {required String currentUserId, required String userId}) async {
  //   DocumentSnapshot ratingDoc = await negativeRatedRef
  //       .doc(userId)
  //       .collection('userNegativeRated')
  //       .doc(currentUserId)
  //       .get();
  //   return ratingDoc.exists;
  // }

  // static Future<int> numNegativeRating(String userId) async {
  //   QuerySnapshot ratingSnapshot = await negativeRatingRef
  //       .doc(userId)
  //       .collection('userNegativeRating')
  //       .get();
  //   return ratingSnapshot.docs.length;
  // }

  // static Future<int> numNegativeRated(String userId) async {
  //   QuerySnapshot ratedSnapshot = await negativeRatedRef
  //       .doc(userId)
  //       .collection('userNegativeRated')
  //       .get();
  //   return ratedSnapshot.docs.length;
  // }

  static Future<AccountHolderAuthor> getUseractivityFollowers(
      String userId, replyingMessage) async {
    DocumentSnapshot userDocSnapshot = await usersAuthorRef
        .doc(userId)
        .collection('userFollowers')
        .doc(userId)
        .get();
    return AccountHolderAuthor.fromDoc(userDocSnapshot);
  }

  static Future<List<Post>> getFeedPosts(String userId, int limit) async {
    QuerySnapshot feedSnapShot = await feedsRef
        .doc(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Post> posts =
        feedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<int> numUsersAll111() async {
    QuerySnapshot feedSnapShot = await userProfessionalRef
        // .where('profileHandle', isEqualTo: profileHandle)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedSnapShot.docs.length;
  }

  // static Future<int> numPostAll111() async {
  //   QuerySnapshot feedSnapShot = await allPostsRef
  //       // .where('profileHandle', isEqualTo: profileHandle)
  //       // .where('showOnExplorePage', isEqualTo: true)
  //       .get();
  //   return feedSnapShot.docs.length;
  // }

  static Future<int> numUsersAll(String profileHandle) async {
    QuerySnapshot feedSnapShot = await usersAuthorRef
        .where('profileHandle', isEqualTo: profileHandle)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedSnapShot.docs.length - 1;
  }

  static Future<int> numusersLiveLocation(
      String profileHandle, String liveCity, String liveCountry) async {
    QuerySnapshot feedSnapShot = await usersAuthorRef
        .where('profileHandle', isEqualTo: profileHandle)
        .where('city', isEqualTo: liveCity)
        .where('country', isEqualTo: liveCountry)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedSnapShot.docs.length - 1;
  }

  static Future<int> numFeedPosts(String userId) async {
    QuerySnapshot feedSnapShot =
        await feedsRef.doc(userId).collection('userFeed').get();
    return feedSnapShot.docs.length - 1;
  }

  static Future<int> numFeedEvents(String userId) async {
    QuerySnapshot feedEventSnapShot =
        await eventFeedsRef.doc(userId).collection('userEventFeed').get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numUnAnsweredInvites(
    String currentUserId,
  ) async {
    QuerySnapshot feedEventSnapShot = await userIviteRef
        .doc(currentUserId)
        .collection('eventInvite')
        .where('answer', isEqualTo: "")
        // .where('startDate', isGreaterThanOrEqualTo: currentDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsTypes(
      String eventType, DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('type', isEqualTo: eventType)
        // .where('startDate', isGreaterThanOrEqualTo: currentDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAll(DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        // .where('startDate', isGreaterThanOrEqualTo: currentDate)

        // .where('type', isEqualTo: eventType)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAllSortNumberOfDays(
      DateTime currentDate, int sortNumberOfDays) async {
    final endDate = currentDate.add(Duration(days: sortNumberOfDays));
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .where('startDate', isLessThanOrEqualTo: endDate)

        // .where('type', isEqualTo: eventType)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsTypesSortNumberOfDays(
      String eventType, DateTime currentDate, int sortNumberOfDays) async {
    final endDate = currentDate.add(Duration(days: sortNumberOfDays));
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('type', isEqualTo: eventType)
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .where('startDate', isLessThanOrEqualTo: endDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAllLiveLocation(
      String liveCity, String liveCountry, DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .where('city', isEqualTo: liveCity)
        .where('country', isEqualTo: liveCountry)

        // .where('type', isEqualTo: eventType)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsTypesLiveLocation(String eventType,
      String liveCity, String liveCountry, DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .where('type', isEqualTo: eventType)
        .where('city', isEqualTo: liveCity)
        .where('country', isEqualTo: liveCountry)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsFollowingAll(
      DateTime currentDate, String userId) async {
    QuerySnapshot feedEventSnapShot = await eventFeedsRef
        .doc(userId)
        .collection('userEventFeed')
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsFollowing(
      DateTime currentDate, String userId, String eventType) async {
    QuerySnapshot feedEventSnapShot = await eventFeedsRef
        .doc(userId)
        .collection('userEventFeed')
        .where('type', isEqualTo: eventType)
        .where('startDate', isGreaterThanOrEqualTo: currentDate)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  // static Future<int> numFeedBlogs(String userId) async {
  //   QuerySnapshot feedBlogSnapShot =
  //       await blogFeedsRef.doc(userId).collection('userBlogFeed').get();
  //   return feedBlogSnapShot.docs.length - 1;
  // }

  // static Future<int> numFeedForums(String userId) async {
  //   QuerySnapshot feedForumSnapShot =
  //       await forumFeedsRef.doc(userId).collection('userForumFeed').get();
  //   return feedForumSnapShot.docs.length - 1;
  // }

  // static Stream<int> numArtistPunch(String userId, String artist) {
  //   return allPostsRef
  //       .where('artist', isEqualTo: artist)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numPunchlinePunch(String userId, String punchline) {
  //   return allPostsRef
  //       .where('punch', isEqualTo: punchline)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numHashTagPunch(String userId, String hashTag) {
  //   return allPostsRef
  //       .where('hashTag', isEqualTo: hashTag)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .limit(9)
        .get();
    List<Post> posts =
        userPostsSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  // static Future<List<Forum>> getUserForums(String userId) async {
  //   QuerySnapshot userForumsSnapshot = await forumsRef
  //       .doc(userId)
  //       .collection('userForums')
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //   List<Forum> forums =
  //       userForumsSnapshot.docs.map((doc) => Forum.fromDoc(doc)).toList();
  //   return forums;
  // }

  static Future<List<Event>> getUserEvents(String userId) async {
    QuerySnapshot userEventsSnapshot = await eventsRef
        .doc(userId)
        .collection('userEvents')
        .orderBy('timestamp', descending: true)
        .get();
    List<Event> events =
        userEventsSnapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
    return events;
  }

  static Future<UpdateApp> getUpdateInfo() async {
    DocumentSnapshot userDocSnapshot =
        await updateAppRef.doc("vYIHcRz4yjVi74sgx19M").get();
    if (userDocSnapshot.exists) {
      return UpdateApp.fromDoc(userDocSnapshot);
    }
    return UpdateApp(
        displayFullUpdate: null,
        displayMiniUpdate: null,
        id: '',
        updateIsAvailable: null,
        timeStamp: null,
        updateNote: '',
        updateVersionAndroid: null,
        updateVersionIos: null,
        version: '');
  }

  // static Future<KPI> getKPI() async {
  //   DocumentSnapshot userDocSnapshot =
  //       await kpiStatisticsRef.doc('0SuQxtu52SyYjhOKiLsj').get();
  //   if (userDocSnapshot.exists) {
  //     return KPI.fromDoc(userDocSnapshot);
  //   }
  //   return KPI(
  //     id: '',
  //     actualllyBooked: 0,
  //     asksSent: 0,
  //     booking: 0,
  //     event: 0,
  //     eventAttend: 0,
  //     advicesSent: 0,
  //     moodPunched: 0,
  //     moodPunchedVideoAccessed: 0,
  //     comentSent: 0,
  //     thoughtSent: 0,
  //     forum: 0,
  //     createdMoodPunched: 0,
  //     createEvennt: 0,
  //     createForum: 0,
  //   );
  // }

  static Future<AccountHolderAuthor?> getUserWithId(String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await usersAuthorRef.doc(userId).get();
      if (userDocSnapshot.exists) {
        return AccountHolderAuthor.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<AccountHolderAuthor> getUserWithId(String userId) async {
  //   DocumentSnapshot userDocSnapshot = await usersAuthorRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return AccountHolderAuthor.fromDoc(userDocSnapshot);
  //   }
  //   return AccountHolderAuthor(
  //     // disabledAccount: null,
  //     // androidNotificationToken: '',
  //     // continent: '',
  //     // hideUploads: null,
  //     // favouriteSong: '',
  //     name: '',
  //     // mail: '',
  //     // noBooking: null,
  //     // hideAdvice: null,
  //     // enableBookingOnChat: null,
  //     // email: '',
  //     // disableChat: null,
  //     // disableAdvice: null,
  //     // favouritePunchline: '',
  //     // otherSites1: '',
  //     // management: '',
  //     // otherSites2: '',
  //     // performances: '',
  //     // collaborations: '',
  //     // favouriteAlbum: '',
  //     // country: '',
  //     // favouriteArtist: '',
  //     // company: '',
  //     bio: '',
  //     // awards: '',
  //     // city: '',
  //     // id: '',
  //     // contacts: '',
  //     // professionalPicture1: '',
  //     // professionalPicture2: '',
  //     // professionalPicture3: '',
  //     profileImageUrl: '',
  //     userName: '',
  //     // score: null,
  //     // privateAccount: null,
  //     // skills: '',
  //     // verified: '',
  //     // report: '',
  //     // reportConfirmed: '',
  //     // website: '',
  //     profileHandle: '', dynamicLink: '', userId: '', verified: false,
  //     disabledAccount: false, reportConfirmed: false,
  //     lastActiveDate: Timestamp.fromDate(DateTime.now()),
  //     // timestamp: Timestamp.fromDate(DateTime.now()),
  //     // disableContentSharing: null,
  //     // disableMoodPunchReaction: null,
  //     // disableMoodPunchVibe: null,
  //     // dontShowContentOnExplorePage: null,
  //     // specialtyTags: '',
  //     // professionalVideo1: '',
  //     // professionalVideo2: '',
  //     // professionalVideo3: '',
  //     // blurHash: '',
  //     // genreTags: '',
  //     // isEmailVerified: null,
  //     // subAccountType: '',
  //   );
  // }

  static Future<UserSettingsLoadingPreferenceModel?>
      getUserLocationSettingWithId(String userId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await usersLocationSettingsRef.doc(userId).get();

      if (userDocSnapshot.exists) {
        return UserSettingsLoadingPreferenceModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<UserSettingsLoadingPreferenceModel>
  //     getUserLocationSettingWithId(String userId) async {
  //   DocumentSnapshot userDocSnapshot =
  //       await usersLocationSettingsRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return UserSettingsLoadingPreferenceModel.fromDoc(userDocSnapshot);
  //   }

  //   return UserSettingsLoadingPreferenceModel(
  //     timestamp: Timestamp.fromDate(DateTime.now()),
  //     city: '',
  //     continent: '',
  //     country: '',
  //     currency: null,
  //     userId: '',
  //   );
  // }

  static Future<UserSettingsGeneralModel?> getUserGeneralSettingWithId(
      String userId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await usersGeneralSettingsRef.doc(userId).get();

      if (userDocSnapshot.exists) {
        return UserSettingsGeneralModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<UserSettingsGeneralModel> getUserGeneralSettingWithId(
  //     String userId) async {
  //   DocumentSnapshot userDocSnapshot =
  //       await usersGeneralSettingsRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return UserSettingsGeneralModel.fromDoc(userDocSnapshot);
  //   }
  //   return UserSettingsGeneralModel(
  //       androidNotificationToken: '',
  //       disableAdvice: null,
  //       disableBooking: null,
  //       disableChat: null,
  //       disabledAccount: null,
  //       disableWorkVacancyNotifications: false,
  //       disableEventSuggestionNotification: null,
  //       disableNewCreativeNotifications: false,
  //       hideAdvice: null,
  //       isEmailVerified: null,
  //       muteEventSuggestionNotification: null,
  //       muteWorkVacancyNotifications: false,
  //       preferredCreatives: [],
  //       preferredEventTypes: [],
  //       privateAccount: null,
  //       report: '',
  //       reportConfirmed: false,
  //       // timestamp: null,
  //       userId: '');
  // }

  // static Future<Chat?> getChatMesssage(
  //     String currentUserId, String userId) async {
  //   try {
  //     DocumentSnapshot userDocSnapshot = await usersAuthorRef
  //         .doc(currentUserId)
  //         .collection('new_chats')
  //         .doc(userId)
  //         .get();
  //     if (userDocSnapshot.exists) {
  //       return Chat.fromDoc(userDocSnapshot);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  static Future<Chat> getChatMesssage(
      String currentUserId, String userId) async {
    DocumentSnapshot userDocSnapshot = await usersAuthorRef
        .doc(currentUserId)
        .collection('new_chats')
        .doc(userId)
        .get();
    if (userDocSnapshot.exists) {
      return Chat.fromDoc(userDocSnapshot);
    }
    return Chat(
        messageId: '',
        firstMessage: '',
        fromUserId: '',
        id: '',
        muteMessage: false,
        lastMessage: '',
        mediaType: '',
        messageInitiator: '',
        newMessageTimestamp: Timestamp.fromDate(DateTime.now()),
        seen: false,
        restrictChat: false,
        timestamp: Timestamp.fromDate(DateTime.now()),
        toUserId: '');
  }

  // 'messageId': messageId,
  //     'lastMessage': message,
  //     'messageInitiator': messageInitiator,
  //     'restrictChat': restrictChat,
  //     'firstMessage': message,
  //     'mediaType': mediaType,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'seen': 'seen',
  //     'fromUserId': currentUserId,
  //     'toUserId': userId,
  //     'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),

  // static Future<AccountHolderAuthor> getUserAuthorWithId(String userId) async {
  //   DocumentSnapshot userDocSnapshot = await usersAuthorRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return AccountHolderAuthor.fromDoc(userDocSnapshot);
  //   }
  //   return AccountHolderAuthor(
  //     bio: '',
  //     userId: '',
  //     profileImageUrl: '',
  //     userName: '',
  //     profileHandle: '',
  //     verified: false, dynamicLink: '', name: '',
  //     // disableChat: null,
  //   );
  // }
  static Future<UserProfessionalModel?> getUserProfessionalWithId(
      String userId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await userProfessionalRef.doc(userId).get();
      if (userDocSnapshot.exists) {
        return UserProfessionalModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<WorkRequestOrOfferModel?> getUserWorkRequestlWithId(
      String userId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await userWorkRequestRef.doc(userId).get();
      if (userDocSnapshot.exists) {
        return WorkRequestOrOfferModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Chat?> getUserChatWithId(
      String currentUserId, String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await usersAuthorRef
          .doc(currentUserId)
          .collection('new_chats')
          .doc(userId)
          .get();
      if (userDocSnapshot.exists) {
        return Chat.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<UserProfessionalModel> getUserProfessionalWithId(
  //     String userId) async {
  //   DocumentSnapshot userDocSnapshot =
  //       await userProfessionalRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return UserProfessionalModel.fromDoc(userDocSnapshot);
  //   }
  //   return UserProfessionalModel(
  //       id: '',
  //       profileImageUrl: '',
  //       userName: '',
  //       profileHandle: '',
  //       verified: false,
  //       awards: [],
  //       collaborations: [],
  //       company: [],
  //       contacts: [],
  //       genreTags: [],
  //       links: [],
  //       noBooking: false,
  //       overview: '',
  //       performances: [],
  //       priceTags: [],
  //       skills: [],
  //       subAccountType: [],
  //       professionalImageUrls: [],
  //       terms: '',
  //       city: '',
  //       continent: '',
  //       country: '',
  //       dynamicLink: '');
  // }

  // static Future<WorkRequestOrOfferModel> getUserWorkRequestlWithId(
  //     String userId) async {
  //   DocumentSnapshot userDocSnapshot =
  //       await userWorkRequestRef.doc(userId).get();
  //   if (userDocSnapshot.exists) {
  //     return WorkRequestOrOfferModel.fromDoc(userDocSnapshot);
  //   }
  //   return WorkRequestOrOfferModel(
  //     availableLocations: [],
  //     currency: '',
  //     genre: [],
  //     isEvent: false,
  //     overView: '',
  //     price: 0,
  //     timestamp: null,
  //     userId: '',
  //     type: [],
  //     id: '',
  //   );
  // }

  // static Future<ActivityEvent> getEventInviteAcivityWithId(
  //     String commonId, String userId) async {
  //   // await activitiesEventRef
  //   //     .doc(userId)
  //   //     .collection('userActivitiesEvent')
  //   //     .where('commonId', isEqualTo: commonId)
  //   //     .get();

  //   return ActivityEvent(
  //       ask: '',
  //       eventId: '',
  //       eventImageUrl: '',
  //       eventInviteType: '',
  //       eventTitle: '',
  //       fromUserId: '',
  //       id: '',
  //       seen: '',
  //       timestamp: null,
  //       commonId: '',
  //       toUserId: '',
  //       invited: null,
  //       authorName: '',
  //       authorProfileHanlde: '',
  //       authorProfileImageUrl: '',
  //       authorVerification: '');
  // }

  // static Future<EventInvite> getEventInviteWithId(
  //     String eventId, String userId) async {
  //   DocumentSnapshot userDocSnapshot = await newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .doc(userId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return EventInvite.fromDoc(userDocSnapshot);
  //   }
  //   return EventInvite(
  //       anttendeeId: '',
  //       anttendeeName: '',
  //       anttendeeprofileHandle: '',
  //       anttendeeprofileImageUrl: '',
  //       attendeeStatus: '',
  //       attendNumber: '',
  //       authorId: '',
  //       eventId: '',
  //       eventImageUrl: '',
  //       eventTimestamp: null,
  //       id: '',
  //       invited: false,
  //       inviteeName: '',
  //       inviteStatus: '',
  //       message: '',
  //       requestNumber: '',
  //       timestamp: null,
  //       commonId: '',
  //       validated: false,
  //       personnelStatus: '');
  // }

  static Future<TicketOrderModel?> getTicketOrderEventWithId(
      TicketOrderModel order) async {
    try {
      DocumentSnapshot userDocSnapshot = await newEventTicketOrderRef
          .doc(order.eventId)
          .collection('eventInvite')
          .doc(order.userOrderId)
          .get();
      if (userDocSnapshot.exists) {
        return TicketOrderModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<TicketOrder> getTicketOrderEventWithId(
  //     TicketOrder order) async {
  //   DocumentSnapshot userDocSnapshot = await newEventTicketOrderRef
  //       .doc(order.eventId)
  //       .collection('eventInvite')
  //       .doc(order.userOrderId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return TicketOrder.fromDoc(userDocSnapshot);
  //   }
  //   return TicketOrder(
  //       // commonId: '',
  //       entranceId: '',
  //       eventId: '',
  //       eventImageUrl: '',
  //       eventTimestamp: null,
  //       // invitatonMessage: '',
  //       // invitedById: '',
  //       isInvited: false,
  //       orderId: '',
  //       orderNumber: '',
  //       tickets: [],
  //       timestamp: null,
  //       userOrderId: '',
  //       total: 0,
  //       validated: false,
  //       // answer: '',
  //       eventTitle: '');
  // }

  // static Future<Event> getInviteEventWithId(EventInvite invite) async {
  //   DocumentSnapshot userDocSnapshot = await eventsRef
  //       .doc(invite.authorId)
  //       .collection('userEvents')
  //       .doc(invite.eventId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return Event.fromDoc(userDocSnapshot);
  //   }
  //   return Event(
  //     isFree: false,
  //     country: '',
  //     city: '', schedule: [],
  //     ticket: [],
  //     taggedPeople: [],
  //     id: '',
  //     report: '',
  //     reportConfirmed: '',
  //     timestamp: null,
  //     // artist: '',
  //     authorId: '',
  //     blurHash: '',
  //     startDate: Timestamp.fromDate(DateTime.now()),
  //     // dj: '',
  //     dressCode: '',
  //     // guess: '',
  //     // host: '',
  //     imageUrl: '',
  //     isPrivate: false,
  //     isVirtual: false,
  //     previousEvent: '',
  //     rate: '',
  //     theme: '',
  //     ticketSite: '',
  //     time: '',
  //     title: '',
  //     triller: '',
  //     type: '',
  //     venue: '',
  //     virtualVenue: '',
  //     isCashPayment: false,
  //     showOnExplorePage: false,
  //     showToFollowers: false,
  //     // clossingDay: '',
  //     // mediaUrl: '',
  //     // mediaType: '',
  //     authorName: '',
  //     category: '',
  //     clossingDay: Timestamp.fromDate(DateTime.now()),
  //     address: '', termsAndConditions: '',
  //   );
  // }

  static Future<Event?> getEventWithId(String eventId) async {
    try {
      DocumentSnapshot userDocSnapshot = await allEventsRef.doc(eventId).get();

      if (userDocSnapshot.exists) {
        return Event.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

  // static Future<Event> getEventWithId(String eventId) async {
  //   DocumentSnapshot userDocSnapshot = await allEventsRef.doc(eventId).get();
  //   if (userDocSnapshot.exists) {
  //     return Event.fromDoc(userDocSnapshot);
  //   }
  //   return Event(
  //       isFree: false,
  //       country: '',
  //       city: '',
  //       id: '',
  //       report: '',
  //       reportConfirmed: '',
  //       timestamp: null,
  //       // artist: '',
  //       authorId: '',
  //       schedule: [],
  //       ticket: [],
  //       taggedPeople: [],
  //       blurHash: '',
  //       // date:  DateTime.now(),
  //       // dj: '',
  //       dressCode: '',
  //       // guess: '',
  //       // host: '',
  //       imageUrl: '',
  //       isPrivate: false,
  //       isVirtual: false,
  //       previousEvent: '',
  //       rate: '',
  //       theme: '',
  //       ticketSite: '',
  //       time: '',
  //       title: '',
  //       triller: '',
  //       type: '',
  //       venue: '',
  //       virtualVenue: '',
  //       isCashPayment: false,
  //       showOnExplorePage: false,
  //       showToFollowers: false,
  //       clossingDay: Timestamp.fromDate(DateTime.now()),
  //       // mediaType: '',
  //       // mediaUrl: '',
  //       authorName: '',
  //       category: '',
  //       // endDate: DateTime.now(),
  //       // location: '',
  //       startDate: Timestamp.fromDate(DateTime.now()),
  //       address: '',
  //       termsAndConditions: '',
  //       dynamicLink: '');
  // }

  static Future<TicketOrderModel?> getTicketWithId(
      String eventId, String currentUserId) async {
    DocumentSnapshot userDocSnapshot = await userInviteRef
        .doc(currentUserId)
        .collection('eventInvite')
        .doc(eventId)
        .get();
    if (userDocSnapshot.exists) {
      return TicketOrderModel.fromDoc(userDocSnapshot);
    }
    return null; // return null if the ticket doesn't exist
  }

  // static Future<TicketOrder> getTicketWithId(String eventId, String currentUserId) async {
  //   DocumentSnapshot userDocSnapshot = await userInviteRef
  //       .doc()
  //       .collection('eventInvite')
  //          .doc(eventId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return TicketOrder.fromDoc(userDocSnapshot);
  //   }
  //   return TicketOrder(
  //       answer: '',
  //       commonId: '',
  //       entranceId: '',
  //       eventId: '',
  //       eventTimestamp: null,
  //       eventImageUrl: '',
  //       invitatonMessage: '',
  //       eventTitle: '',
  //       orderNumber: '',
  //       invitedById: '',
  //       tickets: [],
  //       isInvited: false,
  //       userOrderId: '',
  //       orderId: '',
  //       timestamp: null,
  //       total: 0,
  //       validated: false);
  // }

  static Future<EventRoom?> getEventRoomWithId(String eventId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await eventsChatRoomsRef.doc(eventId).get();
      if (userDocSnapshot.exists) {
        return EventRoom.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<TicketIdModel?> getTicketIdWithId(
      String eventId, String currentUserId) async {
    try {
      DocumentSnapshot userDocSnapshot = await userTicketIdRef
          .doc(currentUserId)
          .collection('eventInvite')
          .doc(eventId)
          .get();
      if (userDocSnapshot.exists) {
        return TicketIdModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<InviteModel?> getEventIviteWithId(
      String currentUserId, String eventId) async {
    try {
      DocumentSnapshot userDocSnapshot = await userIviteRef
          .doc(currentUserId)
          .collection('eventInvite')
          .doc(eventId)
          .get();
      if (userDocSnapshot.exists) {
        return InviteModel.fromDoc(userDocSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<EventRoom> getEventRoomWithId(String eventId) async {
  //   DocumentSnapshot userDocSnapshot = await eventsChatRoomsRef
  //       .doc(eventId)
  //       // .collection('roomChats')
  //       // .doc()
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return EventRoom.fromDoc(userDocSnapshot);
  //   }
  //   return EventRoom(
  //       id: '', imageUrl: '', linkedEventId: '', timestamp: null, title: '');
  // }

  // static Future<InviteModel> getEventIviteWithId(
  //     String currentUserId, String eventId) async {
  //   DocumentSnapshot userDocSnapshot = await userIviteRef
  //       .doc(currentUserId)
  //       .collection('eventInvite')
  //       .doc(eventId)
  //       // .collection('roomChats')
  //       // .doc()
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return InviteModel.fromDoc(userDocSnapshot);
  //   }
  //   return InviteModel(
  //       answer: '',
  //       eventId: '',
  //       eventTimestamp: null,
  //       generatedMessage: '',
  //       inviteeId: '',
  //       inviterId: '',
  //       inviterMessage: '',
  //       isTicketPass: false,
  //       timestamp: null);
  // }

  static Future<Verification> getVerificationUser(String? userId) async {
    DocumentSnapshot userDocSnapshot = await verificationRef.doc(userId).get();
    if (userDocSnapshot.exists) {
      return Verification.fromDoc(userDocSnapshot);
    }
    return Verification(
      email: '',
      gvIdImageUrl: '',
      govIdType: '',
      otherLink: '',
      newsCoverage: '',
      phoneNumber: '',
      profileHandle: '',
      rejectedReason: '',
      socialMedia: '',
      status: '',
      validationImage: '',
      verificationType: '',
      website: '',
      userId: '',
      wikipedia: '',
      timestamp: null,
    );
  }

  // static Future<Forum> getForumWithId(String forumId) async {
  //   DocumentSnapshot userDocSnapshot = await allForumsRef.doc(forumId).get();
  //   if (userDocSnapshot.exists) {
  //     return Forum.fromDoc(userDocSnapshot);
  //   }
  //   return Forum(
  //       authorId: '',
  //       showOnExplorePage: false,
  //       id: '',
  //       isPrivate: false,
  //       report: '',
  //       reportConfirmed: '',
  //       subTitle: '',
  //       timestamp: null,
  //       title: '',
  //       linkedContentId: '',
  //       mediaType: '',
  //       mediaUrl: '',
  //       forumType: '',
  //       authorName: '');
  // }

  // static Future<Thought> getThoughtWithId(
  //     String forumId, String thoughtId) async {
  //   DocumentSnapshot userDocSnapshot = await thoughtsRef
  //       .doc(forumId)
  //       .collection('forumThoughts')
  //       .doc(thoughtId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return Thought.fromDoc(userDocSnapshot);
  //   }
  //   return Thought(
  //       authorId: '',
  //       id: '',
  //       report: '',
  //       reportConfirmed: '',
  //       mediaType: '',
  //       mediaUrl: '',
  //       authorName: '',
  //       authorProfileHanlde: '',
  //       authorProfileImageUrl: '',
  //       authorVerification: '',
  //       count: null,
  //       content: '',
  //       likeCount: null,
  //       timestamp: null,
  //       imported: false);
  // }

  // static Future<Post> getPostWithId(String postId) async {
  //   DocumentSnapshot userDocSnapshot = await allPostsRef.doc(postId).get();
  //   if (userDocSnapshot.exists) {
  //     return Post.fromDoc(userDocSnapshot);
  //   }
  //   return Post(
  //     authorId: '',
  //     id: '',
  //     report: '',
  //     reportConfirmed: '',
  //     timestamp: null,
  //     artist: '',
  //     blurHash: '',
  //     caption: '',
  //     disableReaction: false,
  //     disableVibe: false,
  //     disbleSharing: false,
  //     disLikeCount: 0,
  //     hashTag: '',
  //     imageUrl: '',
  //     likeCount: 0,
  //     musicLink: '',
  //     peopleTagged: '',
  //     punch: '',
  //     mediaType: '',
  //     authorHandleType: '',
  //     authorIdProfileImageUrl: '',
  //     authorName: '',
  //     authorVerification: '',
  //   );
  // }

  // static Future<int> numLikes(String? postId) async {
  //   QuerySnapshot likeSnapshot =
  //       await likesRef.doc(postId).collection('postLikes').get();
  //   return likeSnapshot.docs.length;
  // }

  // static void unlikePost({required String currentUserId, required Post post}) {
  //   DocumentReference postRef =
  //       postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
  //   postRef.get().then((doc) {
  //     int likeCount = doc['likeCount'];
  //     postRef.update({'likeCount': likeCount - 1});
  //     likesRef
  //         .doc(post.id)
  //         .collection('postLikes')
  //         .doc(currentUserId)
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) {
  //         doc.reference.delete();
  //       }
  //     });
  //   });
  // }

  // static Future<int> numDisLikes(String? postId) async {
  //   QuerySnapshot disLikeSnapshot =
  //       await disLikesRef.doc(postId).collection('postDisLikes').get();
  //   return disLikeSnapshot.docs.length;
  // }

  // static Future<bool> didLikePost(
  //     {required String currentUserId, required Post post}) async {
  //   DocumentSnapshot userDoc = await likesRef
  //       .doc(post.id)
  //       .collection('postLikes')
  //       .doc(currentUserId)
  //       .get();
  //   return userDoc.exists;
  // }

  // static Future<bool> didLikeThought(
  //     {required String currentUserId, required Thought thought}) async {
  //   DocumentSnapshot userDoc = await thoughtsLikeRef
  //       .doc(thought.id)
  //       .collection('thoughtLikes')
  //       .doc(currentUserId)
  //       .get();
  //   return userDoc.exists;
  // }

  // static void disLikePost({required String currentUserId, required Post post}) {
  //   DocumentReference postRef =
  //       postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
  //   postRef.get().then((doc) {
  //     int disLikeCount = doc['disLikeCount'];
  //     postRef.update({'disLikeCount': disLikeCount + 1});
  //     disLikesRef
  //         .doc(post.id)
  //         .collection('postDisLikes')
  //         .doc(currentUserId)
  //         .set({
  //       'uid': currentUserId,
  //     });
  //   });
  // }

  // static void unDisLikePost(
  //     {required String currentUserId, required Post post}) {
  //   DocumentReference postRef =
  //       postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
  //   postRef.get().then((doc) {
  //     int disLikeCount = doc['disLikeCount'];
  //     postRef.update({'disLikeCount': disLikeCount - 1});
  //     disLikesRef
  //         .doc(post.id)
  //         .collection('postDisLikes')
  //         .doc(currentUserId)
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) {
  //         doc.reference.delete();
  //       }
  //     });
  //   });
  // }

  // static Future<bool> didDisLikePost(
  //     {required String currentUserId, required Post post}) async {
  //   DocumentSnapshot userDoc = await disLikesRef
  //       .doc(post.id)
  //       .collection('postDisLikes')
  //       .doc(currentUserId)
  //       .get();
  //   return userDoc.exists;
  // }

  // static void commentOnPost(
  //     {required String currentUserId,
  //     required Post post,
  //     required AccountHolder user,
  //     required String comment,
  //     required NotificationActivityType type,
  //     required String reportConfirmed}) {
  //   commentsRef.doc(post.id).collection('postComments').add({
  //     'content': comment,
  //     'authorId': currentUserId,
  //     // 'mediaType': '',
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorName': user.userName,
  //     'authorProfileHanlde': user.profileHandle,
  //     'authorVerification': user.verified,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     // 'mediaUrl': '',
  //     'report': '',
  //     // 'replies': [],
  //     'reportConfirmed': reportConfirmed,
  //   });
  //   addActivityItem(
  //       user: user,
  //       post: post,
  //       comment: comment,
  //       type: type,
  //       event: null,
  //       followerUser: null);
  // }

  static void commentOnPost({
    required String currentUserId,
    required Post post,
    required AccountHolderAuthor user,
    required String comment,
    required NotificationActivityType type,
    required String reportConfirmed,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final commentRef =
        commentsRef.doc(post.id).collection('postComments').doc();

    batch.set(commentRef, {
      'content': comment,
      'authorId': currentUserId,
      'authorProfileImageUrl': user.profileImageUrl,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'report': '',
      'reportConfirmed': reportConfirmed,
    });

    try {
      await batch.commit();
      addActivityItem(
        user: user,
        post: post,
        comment: comment,
        type: type,
        event: null,
        followerUser: null,
        advicedUserId: '',
      );
    } catch (e) {
      // Handle the error appropriately (e.g., show an error message)
      // print('Error commenting on post: $e');
    }
  }

  // static void addAskReply({
  //   required String askId,
  //   required Event event,
  //   required String ask,
  //   // Reply reply,
  //   required AccountHolderAuthor user,
  // }) {
  //   asksRef
  //       .doc(event.id)
  //       .collection('eventAsks')
  //       .doc(askId)
  //       .collection('replies')
  //       .add({
  //     // 'id': reply.id,
  //     'content': ask,
  //     'authorId': user.userId,
  //     'authorName': user.userName,
  //     'authorProfileHandle': user.profileHandle,
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorVerification': user.verified,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'parentId': askId,
  //     'report': '',
  //     'reportConfirmed': '',
  //   });
  //   addActivityItem(
  //     user: user,
  //     post: null,
  //     comment: ask,
  //     type: NotificationActivityType.ask,
  //     event: event,
  //     followerUser: null,
  //   );
  // }

  static void addCommentReply({
    required String commentId,
    required Post post,
    required String comment,
    // Reply reply,
    required AccountHolderAuthor user,
  }) {
    commentsRef
        .doc(post.id)
        .collection('postComments')
        .doc(commentId)
        .collection('replies')
        .add({
      // 'id': reply.id,
      'content': comment,
      'authorId': user.userId,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorProfileImageUrl': user.profileImageUrl,
      'authorVerification': user.verified,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'parentId': commentId,
      'report': '',
      'reportConfirmed': '',
    });
    addActivityItem(
      user: user,
      post: post,
      comment: comment,
      type: NotificationActivityType.comment,
      event: null,
      followerUser: null,
      advicedUserId: '',
    );
  }

  static Stream<int> numComments(String? postId) {
    return commentsRef
        .doc(postId)
        .collection('postComments')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void deleteComment(
      {required String currentUserId,
      required Post post,
      required Comment comment}) async {
    commentsRef
        .doc(post.id)
        .collection('postComments')
        .doc(comment.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot commentsSnapShot = await commentsRef
        .doc(post.id)
        .collection('postComments')
        .doc(comment.id)
        .collection('replies')
        .get();
    commentsSnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void deleteCommentsReply({
    required String commentId,
    required String replyId,
    required Post post,
  }) async {
    commentsRef
        .doc(post.id)
        .collection('postComments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void editComments(
    String commentId,
    String commentContent,
    // String commentAu,
    Post post,
  ) {
    commentsRef.doc(post.id).collection('postComments').doc(commentId).update({
      'content': commentContent,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  static void editCommentsReply(
    String commentId,
    String replyId,
    String commentContent,
    Post post,
  ) {
    commentsRef
        .doc(post.id)
        .collection('postComments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId)
        .update({
      'content': commentContent,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  static void addAdviceReply({
    required String adviceId,
    required AccountHolderAuthor user,
    required String advice,
    required String userId,

    // Reply reply,
    // required AccountHolderAuthor user,
  }) {
    userAdviceRef
        .doc(userId)
        .collection('userAdvice')
        .doc(adviceId)
        .collection('replies')
        .add({
      // 'id': reply.id,
      'content': advice,
      'authorId': user.userId,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorProfileImageUrl': user.profileImageUrl,
      'authorVerification': user.verified,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'parentId': adviceId,
      'report': '',
      'reportConfirmed': '',
    });
    addActivityItem(
      user: user,
      post: null,
      comment: advice,
      type: NotificationActivityType.advice,
      event: null,
      followerUser: null,
      advicedUserId: '',
    );
  }

  static void userAdvice(
      {required AccountHolderAuthor currentUser,
      required String userId,
      required String advice,
      required String reportConfirmed}) {
    userAdviceRef.doc(userId).collection('userAdvice').add({
      'content': advice,
      'report': '',
      'reportConfirmed': reportConfirmed,
      'authorName': currentUser.userName,
      'authorProfileHandle': currentUser.profileHandle,
      'authorProfileImageUrl': currentUser.profileImageUrl,
      'authorVerification': currentUser.verified,
      'authorId': currentUser.userId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityItem(
      user: currentUser,
      event: null, comment: advice,
      followerUser: null,
      advicedUserId: userId,

      post: null,
      type: NotificationActivityType.advice,
      // ask: ask,
      // commonId: commonId,
    );
    // addActivityAdviceItem(currentUser: currentUser, user: user, advice: advice);
  }

  // static Stream<int> numAdvices(String userId) {
  //   return userAdviceRef
  //       .doc(userId)
  //       .collection('userAdvice')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static void deleteAdvice(
      {required String currentUserId,
      required String userId,
      required UserAdvice advice}) async {
    userAdviceRef
        .doc(userId)
        .collection('userAdvice')
        .doc(advice.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void deleteAdviceReply({
    required String adviceId,
    required String replyId,
    required String userId,
  }) async {
    userAdviceRef
        .doc(userId)
        .collection('userAdvice')
        .doc(adviceId)
        .collection('replies')
        .doc(replyId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  // static void editAdvice(
  //   UserAdvice advice,
  //   AccountHolderAuthor user,
  // ) {
  //   userAdviceRef
  //       .doc(user.userId)
  //       .collection('userAdvice')
  //       .doc(advice.id)
  //       .update({
  //     'content': advice.content,
  //     'authorId': advice.authorId,
  //     'timestamp': advice.timestamp
  //   });
  // }

  static void editAdviceReply(
    String adviceId,
    String replyId,
    String askContent,
    String userId,
  ) {
    userAdviceRef
        .doc(userId)
        .collection('userAdvice')
        .doc(adviceId)
        .collection('replies')
        .doc(replyId)
        .update({
      'content': askContent,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  static void editAdvice(
    String adviceId,
    String advice,
    String userId,
    // String commentAu,
  ) {
    userAdviceRef.doc(userId).collection('userAdvice').doc(adviceId).update({
      'content': advice,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  // static void replyThought(
  //     {required String currentUserId,
  //     required Forum forum,
  //     required Thought thought,
  //     required int count,
  //     required AccountHolder user,
  //     required String replyThought,
  //     required String reportConfirmed}) {
  //   replyThoughtsRef.doc(thought.id).collection('replyThoughts').add({
  //     'content': replyThought,
  //     'reportConfirmed': reportConfirmed,
  //     'mediaType': '',
  //     'mediaUrl': '',
  //     'report': '',
  //     'authorId': currentUserId,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorName': user.userName,
  //     'authorProfileHanlde': user.profileHandle,
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorVerification': user.verified
  //   }).then((value) => thoughtsRef
  //           .doc(forum.id)
  //           .collection('forumThoughts')
  //           .doc(thought.id)
  //           .update({
  //         'count': count,
  //       }));

  //   // addActivityForumItem(
  //   //     user: user,
  //   //     forum: forum,
  //   //     thought: replyThought,
  //   //     isThoughtLiked: false,
  //   //     thoughtId: thoughtId);

  //   // addActivityThoughtReplyItem(
  //   //   user: user,
  //   //   forum: forum,
  //   //   thought: thought,
  //   //   isThoughtLiked: false,
  //   //   replyThought: replyThought,
  //   //   isThoughtReplied: true,
  //   // );
  // }

  // static Future<Thought> getUserThought(
  //     String thoughtId, String forumId) async {
  //   DocumentSnapshot forumDocSnapshot = await thoughtsRef
  //       .doc(forumId)
  //       .collection('forumThoughts')
  //       .doc(thoughtId)
  //       .get();
  //   return Thought.fromDoc(forumDocSnapshot);
  // }

  // static void thoughtOnForum(
  //     {required String currentUserId,
  //     required Forum forum,
  //     required String thought,
  //     required String mediaType,
  //     required bool imported,
  //     required String mediaUrl,
  //     required bool isThoughtLiked,
  //     required AccountHolder user,
  //     required String reportConfirmed}) {
  //   thoughtsRef.doc(forum.id).collection('forumThoughts').add({
  //     'content': thought,
  //     'mediaType': mediaType,
  //     'mediaUrl': mediaUrl,
  //     'imported': imported,
  //     'count': 0,
  //     'likeCount': 0,
  //     'reportConfirmed': reportConfirmed,
  //     'report': '',
  //     'authorId': currentUserId,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorName': user.userName,
  //     'authorProfileHanlde': user.profileHandle,
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorVerification': user.verified,
  //   });
  //   // addActivityForumItem(
  //   //     user: user,
  //   //     forum: forum,
  //   //     thought: thought,
  //   //     isThoughtLiked: false,
  //   //     thoughtId: '');
  // }

  // static void replyThought(
  //     {required String currentUserId,
  //     required String thoughtId,
  //     required Forum forum,
  //     required int count,
  //     required AccountHolder user,
  //     required String replyThought,
  //     required String reportConfirmed}) {
  //   replyThoughtsRef.doc(thoughtId).collection('replyThoughts').add({
  //     'content': replyThought,
  //     'reportConfirmed': reportConfirmed,
  //     'mediaType': '',
  //     'mediaUrl': '',
  //     'report': '',
  //     'authorId': currentUserId,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorName': user.userName,
  //     'authorProfileHanlde': user.profileHandle,
  //     'authorProfileImageUrl': user.profileImageUrl,
  //     'authorVerification': user.verified
  //   }).then((value) => thoughtsRef
  //           .doc(forum.id)
  //           .collection('forumThoughts')
  //           .doc(thoughtId)
  //           .update({
  //         'count': count,
  //       }));

  //   addActivityForumItem(user: user, forum: forum, thought: replyThought);
  // }

  // static void deleteThought(
  //     {required String currentUserId,
  //     required Forum forum,
  //     required Thought thought}) async {
  //   thoughtsRef
  //       .doc(forum.id)
  //       .collection('forumThoughts')
  //       .doc(thought.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   QuerySnapshot replyThoughtsSnapShot = await replyThoughtsRef
  //       .doc(thought.id)
  //       .collection('replyThoughts')
  //       .get();
  //   replyThoughtsSnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   QuerySnapshot likeThoughtsSnapShot =
  //       await thoughtsLikeRef.doc(thought.id).collection('thoughtLikes').get();
  //   likeThoughtsSnapShot.docs.forEach((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void deleteReplyThought(
  //     {required Forum forum,
  //     required int count,
  //     required ReplyThought replyThought,
  //     required Thought thought}) async {
  //   replyThoughtsRef
  //       .doc(thought.id)
  //       .collection('replyThoughts')
  //       .doc(replyThought.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   thoughtsRef
  //       .doc(forum.id)
  //       .collection('forumThoughts')
  //       .doc(thought.id)
  //       .update({
  //     'count': count,
  //   });
  // }

  // static void editThought(
  //   Thought thought,
  //   Forum forum,
  // ) {
  //   thoughtsRef
  //       .doc(forum.id)
  //       .collection('forumThoughts')
  //       .doc(thought.id)
  //       .update({
  //     'content': thought.content,
  //     'authorId': thought.authorId,
  //     'timestamp': thought.timestamp,
  //   });
  // }

  static Stream<int> numThoughts(String forumId) {
    return thoughtsRef
        .doc(forumId)
        .collection('forumThoughts')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numRefunds(String eventId, String status) {
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }
    return newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .where('refundRequestStatus', isEqualTo: status)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.size;
      } else {
        // Return an appropriate value or handle the error case when the collection doesn't exist
        return 0;
      }
    }).asStream();
  }

  // static Stream<int> numEventAttendeeRequest(
  //   String eventId,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('invited', isEqualTo: false)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static Stream<int> numAllEventInvites(String eventId, String answer) {
    // Check if eventId is null or empty
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }

    return sentEventIviteRef
        .doc(eventId)
        .collection('eventInvite')
        .where('answer', isEqualTo: answer)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numExpectedAttendees(String eventId, bool validated) {
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }
    return newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .where('validated', isEqualTo: validated)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.size;
      } else {
        // Return an appropriate value or handle the error case when the collection doesn't exist
        return 0;
      }
    }).asStream();
    // return newEventTicketOrderRef
    //     .doc(eventId)
    //     .collection('eventInvite')
    //     .where('validated', isEqualTo: validated)
    //     .snapshots()
    //     .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numTotalExpectedAttendees(
    String eventId,
  ) {
    return newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.size;
      } else {
        // Return an appropriate value or handle the error case when the collection doesn't exist
        return 0;
      }
    }).asStream();
    // return newEventTicketOrderRef
    //     .doc(eventId)
    //     .collection('eventInvite')
    //     .snapshots()
    //     .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  // static Stream<int> numEventAttendeeRequestOption(
  //   String eventId,
  //   String from,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendeeStatus', isEqualTo: from)
  //       .where('invited', isEqualTo: false)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventpublicAttendee(
  //   String eventId,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeeAll(
  //   String eventId,
  //   String from,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendeeStatus', isEqualTo: from)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeeAllPublic(
  //   String eventId,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeePublicAll(
  //   String eventId,
  //   String from,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendeeStatus', isEqualTo: from)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeeRequested(
  //   String eventId,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeeValidatePrivate(
  //     String eventId, String from) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendeeStatus', isEqualTo: from)
  //       .where('validated', isEqualTo: true)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventAttendeeValidatePublic(
  //   String eventId,
  // ) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       // .where('attendeeStatus', isEqualTo: from)
  //       .where('validated', isEqualTo: true)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventInvites(String eventId, String from) {
  //   return newEventTicketOrderRef
  //       .doc(eventId)
  //       .collection('eventInvite')
  //       .where('attendeeStatus', isEqualTo: from)
  //       .where('invited', isEqualTo: true)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Future<Thought> getUserThought(
  //     String thoughtId, String forumId) async {
  //   DocumentSnapshot forumDocSnapshot = await thoughtsRef
  //       .doc(forumId)
  //       .collection('forumThoughts')
  //       .doc(thoughtId)
  //       .get();
  //   return Thought.fromDoc(forumDocSnapshot);
  // }

  // static Future<EventInvite> getThisEventAttendee(
  //     Event event, String? userId) async {
  //   DocumentSnapshot forumDocSnapshot = await newEventTicketOrderRef
  //       .doc(event.id)
  //       .collection('eventInvite')
  //       .doc(userId)
  //       .get();
  //   return EventInvite.fromDoc(forumDocSnapshot);
  // }

  // static Future<EventInvite> getEventAttendeee(
  //     Event event, String? userId) async {
  //   DocumentSnapshot userDocSnapshot = await newEventTicketOrderRef
  //       .doc(event.id)
  //       .collection('eventInvite')
  //       .doc(userId)
  //       .get();
  //   if (userDocSnapshot.exists) {
  //     return EventInvite.fromDoc(userDocSnapshot);
  //   }
  //   return EventInvite(
  //     inviteeName: '',
  //     message: '',
  //     invited: false,
  //     timestamp: null,
  //     attendeeStatus: '',
  //     anttendeeId: '',
  //     anttendeeName: '',
  //     anttendeeprofileHandle: '',
  //     anttendeeprofileImageUrl: '',
  //     attendNumber: '',
  //     authorId: '',
  //     eventId: '',
  //     eventImageUrl: '',
  //     id: '',
  //     requestNumber: '',
  //     inviteStatus: '',
  //     eventTimestamp: null,
  //     commonId: '',
  //     validated: false,
  //     personnelStatus: '',
  //   );
  // }

  static Future<int> numUsersTickets(String userId) async {
    QuerySnapshot feedSnapShot = await userInviteRef
        .doc(userId)
        .collection('eventInvite')
        // .where('profileHandle', isEqualTo: profileHandle)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedSnapShot.docs.length;
  }

  static Future<bool> isTicketOrderAvailable({
    required Transaction transaction,
    required String userOrderId,
    required String eventId,
  }) async {
    DocumentReference ticketOrderDocRef =
        userInviteRef.doc(userOrderId).collection('eventInvite').doc(eventId);

    DocumentSnapshot ticketOrderDoc = await transaction.get(ticketOrderDocRef);

    return ticketOrderDoc.exists;
  }

  // static Future<bool> isTicketOrdetAvailable({
  //   required String userOrderId,
  //   required String eventId,
  // }) async {
  //   DocumentSnapshot ticketOrderDoc = await userInviteRef
  //       .doc(userOrderId)
  //       .collection('eventInvite')
  //       .doc(eventId)
  //       .get();
  //   return ticketOrderDoc.exists;
  // }

  static void purchaseMoreTicket({
    required String userOrderId,
    required String eventId,
    required List<TicketModel> tickets,
  }) {
    // String commonId = Uuid().v4();

    newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .doc(userOrderId)
        .update({
      'tickets': FieldValue.arrayUnion(
          tickets.map((ticket) => ticket.toJson()).toList())
    });

    userInviteRef
        .doc(userOrderId)
        .collection('eventInvite')
        .doc(eventId)
        .update({
      'tickets': FieldValue.arrayUnion(
          tickets.map((ticket) => ticket.toJson()).toList())
    });
  }

  // static deleteTicket({
  //   required TicketOrderModel ticketOrder,
  // }) {
  //   // String commonId = Uuid().v4();

  //   newEventTicketOrderRef
  //       .doc(ticketOrder.eventId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.userOrderId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   userInviteRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  static Future<bool> isHavingTicket(
      {required String eventId, required String userId}) async {
    DocumentSnapshot ticketDoc = await newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .doc(userId)
        .get();
    return ticketDoc.exists;
  }

  // static void addUserTicketIdRef({
  //   required TicketOrder ticketOrder,
  // }) async {
  //   await userTicketIdRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId)
  //       .set({
  //     'eventId': ticketOrder.eventId,
  //     'isNew': false,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  static answerEventInviteBatch({
    required WriteBatch batch,
    required Event event,
    required String answer,
    required AccountHolderAuthor currentUser,
  }) async {
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference newEventTicketOrderRef = sentEventIviteRef
        .doc(event.id)
        .collection('eventInvite')
        .doc(currentUser.userId);
    batch.update(newEventTicketOrderRef, {
      'answer': answer,
    });

    DocumentReference userInviteRef = userIviteRef
        .doc(currentUser.userId)
        .collection('eventInvite')
        .doc(event.id);
    batch.update(userInviteRef, {
      'answer': answer,
    });

    // return batch.commit().then((value) => {}).catchError((error) {
    //   throw error; // Re-throw the error
    // });
  }

// The DatabaseService.purchaseTicket method is responsible for storing the details
// of the purchased ticket in the Firestore database. This method creates two new documents,
//  one under the 'eventInvite' collection of the specific eventId and another under
//  the 'eventInvite' collection of the specific userOrderId. Both documents contain
//  the same data, which includes details about the ticket order.

  static void purchaseTicketBatch({
    required WriteBatch batch,
    required TicketOrderModel ticketOrder,
    required AccountHolderAuthor user,
    required String eventAuthorId,
    required String purchaseReferenceId,
  }) {
    final eventInviteDocRef = newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('eventInvite')
        .doc(ticketOrder.userOrderId);

    final userInviteDocRef = userInviteRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId);

    Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

    batch.set(eventInviteDocRef, ticketOrderData);
    batch.set(userInviteDocRef, ticketOrderData);

    // Add addUserTicketIdRef to the batch
    final userTicketIdDocRef = userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId);

    batch.set(userTicketIdDocRef, {
      'eventId': ticketOrder.eventId,
      'isNew': false,
      'isSeen': false,
      'muteNotification': false,
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Create a new document reference for the activity within the userActivities collection
    DocumentReference activityDocRef = activitiesRef
        .doc(eventAuthorId)
        .collection('userActivities')
        .doc(); // Auto-generate a new document ID for the activity

    // Add activity creation to the batch
    batch.set(activityDocRef, {
      'authorId': ticketOrder.userOrderId,
      'postId': ticketOrder.eventId,
      'seen': false,
      'type': 'ticketPurchased',
      'postImageUrl': ticketOrder.eventImageUrl,
      'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
      'timestamp':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'authorProfileImageUrl':
          user.profileImageUrl, // Assuming there's a profileImageUrl field
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
    });

    // The batch.commit() is commented out and should be called outside this function
    // after all batch operations have been added.
    // return batch.commit();
  }

  // static void purchaseTicketBatch({
  //   required WriteBatch batch,
  //   required TicketOrderModel ticketOrder,
  //   required AccountHolderAuthor user,
  //   required String eventAuthorId,
  //   required String purchaseReferenceId,
  // }) {
  //   // WriteBatch batch = FirebaseFirestore.instance.batch();

  //   final eventInviteDocRef = newEventTicketOrderRef
  //       .doc(ticketOrder.eventId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.userOrderId);

  //   final userInviteDocRef = userInviteRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId);

  //   Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

  //   batch.set(eventInviteDocRef, ticketOrderData);
  //   batch.set(userInviteDocRef, ticketOrderData);

  //   // Add addUserTicketIdRef to the batch
  //   final userTicketIdDocRef = userTicketIdRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId);

  //   batch.set(userTicketIdDocRef, {

  //     'eventId': ticketOrder.eventId,
  //     'isNew': false,
  //     'isSeen': false,
  //     'muteNotification': false,
  //     'lastMessage': '',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });

  //   activitiesRef.doc(eventAuthorId).collection('userActivities').add({
  //     'authorId': ticketOrder.userOrderId,
  //     'postId': ticketOrder.eventId,
  //     'seen': false,
  //     'type': 'ticketPurchased',
  //     'postImageUrl': ticketOrder.eventImageUrl,
  //     'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorProfileImageUrl': '',
  //     'authorName': user.userName,
  //     'authorProfileHandle': user.profileHandle,
  //     'authorVerification': user.verified,
  //   });

  //   // return batch.commit();
  // }

  static Future<void> purchaseTicketTransaction({
    required Transaction transaction,
    required TicketOrderModel ticketOrder,
    required AccountHolderAuthor user,
    required String purchaseReferenceId,
    required String eventAuthorId,
  }) async {
    final eventInviteDocRef = newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('eventInvite')
        .doc(ticketOrder.userOrderId);

    final userInviteDocRef = userInviteRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId);

    Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

    transaction.set(eventInviteDocRef, ticketOrderData);
    transaction.set(userInviteDocRef, ticketOrderData);

    // Add userTicketIdRef to the transaction
    final userTicketIdDocRef = userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId);

    transaction.set(userTicketIdDocRef, {
      'eventId': ticketOrder.eventId,
      'isNew': false,
      'isSeen': false,
      'muteNotification': false,
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Now add the activity within the transaction
    DocumentReference activityDocRef = activitiesRef
        .doc(eventAuthorId)
        .collection('userActivities')
        .doc(); // Create a new document reference with a generated ID

    transaction.set(activityDocRef, {
      'authorId': ticketOrder.userOrderId,
      'postId': ticketOrder.eventId,
      'seen': false,
      'type': 'ticketPurchased',
      'postImageUrl': ticketOrder.eventImageUrl,
      'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
      'authorProfileImageUrl': user.profileImageUrl,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
    });
  }

  // static Future<void> purchaseTicketTransaction({
  //   required Transaction transaction,
  //   required TicketOrderModel ticketOrder,
  //   required AccountHolderAuthor user,
  //   required String purchaseReferenceId,
  //   required String eventAuthorId,
  // }) async {
  //   final eventInviteDocRef = newEventTicketOrderRef
  //       .doc(ticketOrder.eventId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.userOrderId);

  //   final userInviteDocRef = userInviteRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId);
  //   Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

  //   transaction.set(eventInviteDocRef, ticketOrderData);
  //   transaction.set(userInviteDocRef, ticketOrderData);

  //   // Add addUserTicketIdRef to the transaction
  //   final userTicketIdDocRef = userTicketIdRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId);

  //   transaction.set(userTicketIdDocRef, {
  //     'eventId': ticketOrder.eventId,
  //     'isNew': false,
  //     'isSeen': false,
  //     'muteNotification': false,
  //     'lastMessage': '',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });

  //   activitiesRef.doc(eventAuthorId).collection('userActivities').add({
  //     'authorId': ticketOrder.userOrderId,
  //     'postId': ticketOrder.eventId,
  //     'seen': false,
  //     'type': 'ticketPurchased',
  //     'postImageUrl': ticketOrder.eventImageUrl,
  //     'comment': 'Purchased a ticket for: \n${ticketOrder.eventTitle}',
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'authorProfileImageUrl': '',
  //     'authorName': user.userName,
  //     'authorProfileHandle': user.profileHandle,
  //     'authorVerification': user.verified,
  //   });
  // }

  // static Future<void> purchaseTicket({
  //   required TicketOrder ticketOrder,
  // }) async {
  //   await newEventTicketOrderRef
  //       .doc(ticketOrder.eventId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.userOrderId)
  //       .set({
  //     'orderId': ticketOrder.orderId,
  //     'eventId': ticketOrder.eventId,
  //     'validated': ticketOrder.validated,
  //     'timestamp': ticketOrder.timestamp,
  //     'eventTimestamp': ticketOrder.eventTimestamp,
  //     'entranceId': ticketOrder.entranceId,
  //     'eventImageUrl': ticketOrder.eventImageUrl,
  //     'isInvited': ticketOrder.isInvited,
  //     'orderNumber': ticketOrder.orderNumber,
  //     'tickets': ticketOrder.tickets.map((ticket) => ticket.toJson()).toList(),
  //     'total': ticketOrder.total,
  //     'userOrderId': ticketOrder.userOrderId,
  //     'eventTitle': ticketOrder.eventTitle,
  //   });

  //   await userInviteRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId)
  //       .set({
  //     'orderId': ticketOrder.orderId,
  //     'eventId': ticketOrder.eventId,
  //     'validated': ticketOrder.validated,
  //     'timestamp': ticketOrder.timestamp,
  //     'eventTimestamp': ticketOrder.eventTimestamp,
  //     'entranceId': ticketOrder.entranceId,
  //     'eventImageUrl': ticketOrder.eventImageUrl,
  //     'isInvited': ticketOrder.isInvited,
  //     'orderNumber': ticketOrder.orderNumber,
  //     'tickets': ticketOrder.tickets.map((ticket) => ticket.toJson()).toList(),
  //     'total': ticketOrder.total,
  //     'userOrderId': ticketOrder.userOrderId,
  //     'eventTitle': ticketOrder.eventTitle,
  //   });
  //   // !event.isPrivate
  //   //     ? activitiesEventRef
  //   //         .doc(event.id)
  //   //         .collection('userActivitiesEvent')
  //   //         .doc(commonId)
  //   //         .set({
  //   //         'toUserId': currentUserId,
  //   //         'fromUserId': currentUserId,
  //   //         'eventId': event.id,
  //   //         'eventInviteType': 'AttendRequest',
  //   //         'invited': false,
  //   //         'seen': '',
  //   //         'eventImageUrl': event.imageUrl,
  //   //         'eventTitle': event.title,
  //   //         'commonId': commonId,
  //   //         'ask': '',
  //   //         'timestamp': Timestamp.fromDate(DateTime.now()),
  //   //       })
  //   //     // ignore: unnecessary_statements
  //   //     : () {};
  // }

  static Future<void> deleteTicket({
    required TicketOrderModel ticketOrder,
  }) async {
    newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('eventInvite')
        .doc(ticketOrder.userOrderId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    userInviteRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('eventInvite')
        .doc(ticketOrder.eventId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void attendEvent({
    required Event event,
    required AccountHolderAuthor user,
    required String requestNumber,
    required String message,
    required Timestamp eventDate,
    required String currentUserId,
  }) async {
    String commonId = Uuid().v4();

    await newEventTicketOrderRef
        .doc(event.id)
        .collection('eventInvite')
        .doc(user.userId)
        .set({
      'orderId': commonId,
      'eventId': event.id,
      'commonId': commonId,
      'validated': false,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'eventTimestamp': eventDate,
      'entranceId': '0909',
      'eventImageUrl': event.imageUrl,
      'invitatonMessage': '',
      'invitedById': '',
      'isInvited': false,
      'orderNumber': '909',
      'tickets': [],
      'total': 09,
      'userOderId': commonId,
      // 'eventId': event.id,
      // 'inviteeName': '',
      // 'commonId': commonId,
      // 'requestNumber': requestNumber,
      // 'attendNumber': '',
      // 'anttendeeId': user.id,
      // 'message': message,
      // 'inviteStatus': '',
      // 'personnelStatus': '',
      // 'invited': false,
      // 'validated': false,
      // 'attendeeStatus': '',
      // 'anttendeeName': user.userName,
      // 'anttendeeprofileHandle': user.profileHandle,
      // 'anttendeeprofileImageUrl': user.profileImageUrl,
      // 'eventImageUrl': event.imageUrl,
      // 'authorId': event.authorId,
      // 'timestamp': Timestamp.fromDate(DateTime.now()),
      // 'eventTimestamp': eventDate,
    });

    await userInviteRef
        .doc(user.userId)
        .collection('eventInvite')
        .doc(event.id)
        .set({
      'orderId': commonId,
      'eventId': event.id,
      'commonId': commonId,
      'validated': false,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'eventTimestamp': eventDate,
      'entranceId': '0909',
      'eventImageUrl': event.imageUrl,
      'invitatonMessage': '',
      'invitedById': '',
      'isInvited': false,
      'orderNumber': '909',
      'tickets': [],
      'total': 09,
      'userOderId': commonId,
      // 'eventId': event.id,
      // 'requestNumber': requestNumber,
      // 'commonId': commonId,
      // 'attendNumber': '',
      // 'inviteeName': '',
      // 'anttendeeId': user.id,
      // 'message': message,
      // 'inviteStatus': '',
      // 'personnelStatus': '',
      // 'invited': false,
      // 'validated': false,
      // 'attendeeStatus': '',
      // 'anttendeeName': user.userName,
      // 'anttendeeprofileHandle': user.profileHandle,
      // 'anttendeeprofileImageUrl': user.profileImageUrl,
      // 'eventImageUrl': event.imageUrl,
      // 'authorId': event.authorId,
      // 'timestamp': Timestamp.fromDate(DateTime.now()),
      // 'eventTimestamp': eventDate,
    });
    // !event.isPrivate
    //     ? activitiesEventRef
    //         .doc(event.id)
    //         .collection('userActivitiesEvent')
    //         .doc(commonId)
    //         .set({
    //         'toUserId': currentUserId,
    //         'fromUserId': currentUserId,
    //         'eventId': event.id,
    //         'eventInviteType': 'AttendRequest',
    //         'invited': false,
    //         'seen': '',
    //         'eventImageUrl': event.imageUrl,
    //         'eventTitle': event.title,
    //         'commonId': commonId,
    //         'ask': '',
    //         'timestamp': Timestamp.fromDate(DateTime.now()),
    //       })
    //     // ignore: unnecessary_statements
    //     : () {};
  }

  static Future<void> answerEventInviteTransaction({
    required Transaction transaction,
    required Event event,
    required String answer,
    required AccountHolderAuthor currentUser,
  }) async {
    DocumentReference newEventTicketOrderRef = sentEventIviteRef
        .doc(event.id)
        .collection('eventInvite')
        .doc(currentUser.userId);

    transaction.update(newEventTicketOrderRef, {
      'answer': answer,
    });

    DocumentReference userInviteRef = userIviteRef
        .doc(currentUser.userId)
        .collection('eventInvite')
        .doc(event.id);

    transaction.update(userInviteRef, {
      'answer': answer,
    });
  }

  static sendEventInvite({
    required Event event,
    required List<AccountHolderAuthor> users,
    required String message,
    required String generatedMessage,
    required AccountHolderAuthor currentUser,
    required bool isTicketPass,
  }) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var user in users) {
      // String commonId = Uuid().v4();
      DocumentReference newEventTicketOrderRef = sentEventIviteRef
          .doc(event.id)
          .collection('eventInvite')
          .doc(user.userId);
      batch.set(newEventTicketOrderRef, {
        'eventId': event.id,
        'inviteeId': user.userId,
        'inviterId': currentUser.userId,
        'inviterMessage': message,
        'isTicketPass': isTicketPass,
        'generatedMessage': generatedMessage,
        'answer': '',
        'timestamp': FieldValue.serverTimestamp(),
        'eventTimestamp': event.startDate,
      });

      DocumentReference userInviteRef =
          userIviteRef.doc(user.userId).collection('eventInvite').doc(event.id);
      batch.set(userInviteRef, {
        'eventId': event.id,
        'inviteeId': user.userId,
        'inviterId': currentUser.userId,
        'inviterMessage': message,
        'isTicketPass': isTicketPass,
        'generatedMessage': generatedMessage,
        'answer': '',
        'timestamp': FieldValue.serverTimestamp(),
        'eventTimestamp': event.startDate,
      });

      activitiesRef.doc(user.userId).collection('userActivities').add({
        'authorId': event.authorId,
        'postId': event.id,
        'seen': false,
        'type': 'inviteRecieved',
        'postImageUrl': event.imageUrl,
        'comment': MyDateFormat.toDate(event.startDate.toDate()) +
            '\n${message.isEmpty ? generatedMessage : message}',
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'authorProfileImageUrl': '',
        'authorName': 'Cordially Invited',
        'authorProfileHandle': '',
        'authorVerification': user.verified,
      });
      return batch.commit().then((value) => {}).catchError((error) {
        throw error; // Re-throw the error
      });
    }
  }

  // static void sendEventInvite({
  //   required Event event,
  //   required AccountHolder user,
  //   required String requestNumber,
  //   required String message,
  //   required DateTime eventDate,
  //   required AccountHolder currentUser,
  // }) {
  //   String commonId = Uuid().v4();

  //   newEventTicketOrderRef.doc(event.id).collection('eventInvite').doc(user.id).set({
  //     'eventId': event.id,
  //     'requestNumber': requestNumber,
  //     'attendNumber': '',
  //     'commonId': commonId,
  //     'anttendeeId': user.id,
  //     'message': message,
  //     'inviteStatus': '',
  //     'personnelStatus': '',
  //     'inviteeName': user.userName,
  //     'invited': true,
  //     'validated': false,
  //     'attendeeStatus': '',
  //     'anttendeeName': user.userName,
  //     'anttendeeprofileHandle': user.profileHandle,
  //     'anttendeeprofileImageUrl': user.profileImageUrl,
  //     'eventImageUrl': event.imageUrl,
  //     'authorId': event.authorId,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'eventTimestamp': eventDate,
  //   });

  //   // activitiesEventRef
  //   //     .doc(user.id)
  //   //     .collection('userActivitiesEvent')
  //   //     .doc(commonId)
  //   //     .set({
  //   //   'toUserId': user.id,
  //   //   'fromUserId': currentUser.id,
  //   //   'eventId': event.id,
  //   //   'eventInviteType': event.title,
  //   //   'invited': true,
  //   //   'seen': '',
  //   //   'eventImageUrl': event.imageUrl,
  //   //   'eventTitle': event.title,
  //   //   'commonId': commonId,
  //   //   'ask': null,
  //   //   'timestamp': Timestamp.fromDate(DateTime.now()),
  //   //   'authorProfileImageUrl': user.profileImageUrl,
  //   //   'authorName': user.userName,
  //   //   'authorProfileHanlde': user.profileHandle,
  //   //   'authorVerification': user.verified,
  //   // });

  //   // addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  // }

  // static void addEventInviteToAttending({
  //   required Event event,
  //   required AccountHolder user,
  //   required String requestNumber,
  //   required String message,
  //   required DateTime eventDate,
  //   required String currentUserId,
  //   required String answer,
  //   required EventInvite eventInvite,
  //   required String attendeeNumber,
  // }) {
  //   String commonId = Uuid().v4();

  //   userInviteRef.doc(user.id).collection('eventInvite').doc(event.id).set({
  //     'eventId': event.id,
  //     'requestNumber': requestNumber,
  //     'commonId': commonId,
  //     'attendNumber': attendeeNumber,
  //     'anttendeeId': user.id,
  //     'message': message,
  //     'inviteStatus': 'Accepted',
  //     'personnelStatus': '',
  //     'inviteeName': '',
  //     'invited': true,
  //     'validated': false,
  //     'attendeeStatus': 'Accepted',
  //     'anttendeeName': user.userName,
  //     'anttendeeprofileHandle': user.profileHandle,
  //     'anttendeeprofileImageUrl': user.profileImageUrl,
  //     'eventImageUrl': event.imageUrl,
  //     'authorId': event.authorId,
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //     'eventTimestamp': eventDate,
  //   });

  //   newEventTicketOrderRef.doc(event.id).collection('eventInvite').doc(user.id).update({
  //     'attendeeStatus': 'Accepted',
  //     'inviteStatus': 'Accepted',
  //     'attendNumber': attendeeNumber,
  //   });

  //   // activitiesEventRef
  //   //     .doc(user.id)
  //   //     .collection('userActivitiesEvent')
  //   //     .doc(eventInvite.commonId)
  //   //     .update({
  //   //   'seen': 'seen',
  //   //   'timestamp': Timestamp.fromDate(DateTime.now()),
  //   // });
  // }

  // static void deleteUnAvailableTicketOrder({
  //   required TicketOrder ticketOrder,
  // }) {
  //   userInviteRef
  //       .doc(ticketOrder.userOrderId)
  //       .collection('eventInvite')
  //       .doc(ticketOrder.eventId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void deleteUnAvailableEvent({
  //   required EventInvite eventInvite,
  // }) {
  //   userInviteRef
  //       .doc(eventInvite.anttendeeId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.eventId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static void cancelInvite({
  //   required EventInvite eventInvite,
  // }) {
  //   newEventTicketOrderRef
  //       .doc(eventInvite.eventId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.anttendeeId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   userInviteRef
  //       .doc(eventInvite.anttendeeId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.eventId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });

  //   // activitiesEventRef
  //   //     .doc(eventInvite.anttendeeId)
  //   //     .collection('userActivitiesEvent')
  //   //     .doc(eventInvite.commonId)
  //   //     .get()
  //   //     .then((doc) {
  //   //   if (doc.exists) {
  //   //     doc.reference.delete();
  //   //   }
  //   // });

  //   // addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  // }

  // static void answerEventAttendeeReques({
  //   required EventInvite eventInvite,
  //   required String answer,
  // }) {
  //   String commonId = Uuid().v4();
  //   newEventTicketOrderRef
  //       .doc(eventInvite.eventId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.anttendeeId)
  //       .update({
  //     'attendeeStatus': answer,
  //     'attendNumber':
  //         answer.startsWith('Rejected') ? '' : commonId.substring(0, 3),
  //   });

  //   userInviteRef
  //       .doc(eventInvite.anttendeeId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.eventId)
  //       .update({
  //     'attendeeStatus': answer,
  //     'attendNumber':
  //         answer.startsWith('Rejected') ? '' : commonId.substring(0, 3),
  //     'timestamp': Timestamp.fromDate(DateTime.now()),
  //   });

  //   // addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  // }

  // static void validateEventAttendee({
  //   required EventInvite eventInvite,
  //   required bool validate,
  // }) {
  //   newEventTicketOrderRef
  //       .doc(eventInvite.eventId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.anttendeeId)
  //       .update({
  //     'validated': validate,
  //   });

  //   userInviteRef
  //       .doc(eventInvite.anttendeeId)
  //       .collection('eventInvite')
  //       .doc(eventInvite.eventId)
  //       .update({
  //     'validated': validate,
  //   });

  //   // addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  // }

  // addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  // }

  static void askAboutEvent(
      {required String currentUserId,
      required Event event,
      required String ask,
      required AccountHolderAuthor user,
      required String reportConfirmed}) {
    asksRef.doc(event.id).collection('eventAsks').add({
      'content': ask,
      'report': '',
      'mediaType': '',
      'mediaUrl': '',
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorProfileImageUrl': user.profileImageUrl,
      'authorVerification': user.verified,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    // String commonId = Uuid().v4();

    addActivityItem(
      user: user,
      event: event, comment: ask, followerUser: null, post: null,
      type: NotificationActivityType.ask, advicedUserId: '',
      // ask: ask,
      // commonId: commonId,
    );

    // addActivityEventItem(
    //   user: user,
    //   event: event,
    //   ask: ask,
    //   commonId: commonId,
    // );
  }

  // static Stream<int> numAsks(String eventId) {
  //   return asksRef
  //       .doc(eventId)
  //       .collection('eventAsks')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static void deleteAsk(
      {required String currentUserId,
      required Event event,
      required Ask ask}) async {
    asksRef.doc(event.id).collection('eventAsks').doc(ask.id).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void editAsk(
    Ask ask,
    Event event,
  ) {
    asksRef.doc(event.id).collection('eventAsks').doc(ask.id).update({
      'content': ask.content,
      'authorId': ask.authorId,
      'timestamp': ask.timestamp,
    });
  }

  // static void addActivityFollowerItem(
  //     {required String currentUserId,
  //     required AccountHolder user,
  //     required AccountHolder currentUser}) {
  //   if (currentUserId != user.id) {
  //     activitiesFollowerRef.doc(user.id).collection('activitiesFollower').add({
  //       'fromUserId': currentUserId,
  //       'userId': user.id,
  //       'seen': '',
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': currentUser.profileImageUrl,
  //       'authorName': currentUser.userName,
  //       'authorProfileHanlde': currentUser.profileHandle,
  //       'authorVerification': currentUser.verified,
  //     });
  //   }
  // }

  // static void editActivityFollower(ActivityFollower activity, String useId) {
  //   activitiesFollowerRef
  //       .doc(useId)
  //       .collection('activitiesFollower')
  //       .doc(activity.id)
  //       .update({
  //     'fromUserId': activity.fromUserId,
  //     'userId': activity.userId,
  //     'seen': activity.seen,
  //     'timestamp': activity.timestamp,
  //   });
  // }

  // static Stream<int> numActivitiesFollower(String userId) {
  //   return activitiesFollowerRef
  //       .doc(userId)
  //       .collection('activitiesFollower')
  //       .where('seen', isEqualTo: '')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static void addActivityItem(
      {required AccountHolderAuthor user,
      required AccountHolderAuthor? followerUser,
      required Post? post,
      required String? advicedUserId,
      required Event? event,
      required NotificationActivityType type,
      required String? comment}) {
    // if (user.id != post.authorId) {
    post != null
        ? activitiesRef.doc(post.authorId).collection('userActivities').add({
            'authorId': user.userId,
            'postId': post.id,
            'seen': false,
            'type': type.toString().split('.').last,
            'postImageUrl': post.imageUrl,
            'comment': comment,
            'timestamp': Timestamp.fromDate(DateTime.now()),
            'authorProfileImageUrl': user.profileImageUrl,
            'authorName': user.userName,
            'authorProfileHandle': user.profileHandle,
            'authorVerification': user.verified,
          })
        : event != null
            ? activitiesRef
                .doc(event.authorId)
                .collection('userActivities')
                .add({
                'authorId': user.userId,
                'postId': event.id,
                'seen': false,
                'type': type.toString().split('.').last,
                'postImageUrl': event.imageUrl,
                'comment': comment,
                'timestamp': Timestamp.fromDate(DateTime.now()),
                'authorProfileImageUrl': user.profileImageUrl,
                'authorName': user.userName,
                'authorProfileHandle': user.profileHandle,
                'authorVerification': user.verified,
              })
            : followerUser != null
                ? activitiesRef
                    .doc(followerUser.userId)
                    .collection('userActivities')
                    .add({
                    'authorId': user.userId,
                    'postId': followerUser.userId,
                    'seen': false,
                    'type': type.toString().split('.').last,
                    'postImageUrl': followerUser.profileImageUrl,
                    'comment': comment,
                    'timestamp': Timestamp.fromDate(DateTime.now()),
                    'authorProfileImageUrl': user.profileImageUrl,
                    'authorName': user.userName,
                    'authorProfileHandle': user.profileHandle,
                    'authorVerification': user.verified,
                  })
                : followerUser != null
                    ? activitiesRef
                        .doc(advicedUserId)
                        .collection('userActivities')
                        .add({
                        'authorId': user.userId,
                        'postId': followerUser.userId,
                        'seen': false,
                        'type': type.toString().split('.').last,
                        'postImageUrl': followerUser.profileImageUrl,
                        'comment': comment,
                        'timestamp': Timestamp.fromDate(DateTime.now()),
                        'authorProfileImageUrl': user.profileImageUrl,
                        'authorName': user.userName,
                        'authorProfileHandle': user.profileHandle,
                        'authorVerification': user.verified,
                      })
                    : null;
    // }
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();
    List<Activity> activity = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();
    return activity;
  }

  static void editActivity(Activity activity, String useId) {
    activitiesRef
        .doc(useId)
        .collection('userActivities')
        .doc(activity.id)
        .update({
      'fromUserId': activity.authorId,
      'postId': activity.postId,
      'seen': activity.seen,
      'postImageUrl': activity.postImageUrl,
      'comment': activity.comment,
      'timestamp': activity.timestamp,
    });
  }

  static Stream<int> numActivities(String userId) {
    return activitiesRef
        .doc(userId)
        .collection('userActivities')
        .where('seen', isEqualTo: false)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  // static void addActivityAdviceItem(
  //     {required AccountHolder currentUser,
  //     required AccountHolder user,
  //     required String advice}) {
  //   if (currentUser.id != user.id) {
  //     activitiesAdviceRef.doc(user.id).collection('userActivitiesAdvice').add({
  //       'fromUserId': currentUser.id,
  //       'userId': user.id,
  //       'seen': '',
  //       'advice': advice,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': currentUser.profileImageUrl,
  //       'authorName': currentUser.userName,
  //       'authorProfileHanlde': currentUser.profileHandle,
  //       'authorVerification': currentUser.verified,
  //     });
  //   }
  // }

  // static void editActivityAdvice(ActivityAdvice activityAdvice, String useId) {
  //   activitiesAdviceRef
  //       .doc(useId)
  //       .collection('userActivitiesAdvice')
  //       .doc(activityAdvice.id)
  //       .update({
  //     'fromUserId': activityAdvice.fromUserId,
  //     'userId': activityAdvice.userId,
  //     'seen': activityAdvice.seen,
  //     'advice': activityAdvice.advice,
  //     'timestamp': activityAdvice.timestamp,
  //   });
  // }

  // static Stream<int> numActivitiesAdvice(String userId) {
  //   return activitiesAdviceRef
  //       .doc(userId)
  //       .collection('userActivitiesAdvice')
  //       .where('seen', isEqualTo: '')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot =
        await postsRef.doc(userId).collection('userPosts').doc(postId).get();
    return Post.fromDoc(postDocSnapshot);
  }

  // static void addActivityForumItem(
  //     {required Forum forum,
  //     required AccountHolder user,
  //     required bool isThoughtLiked,
  //     required String thoughtId,
  //     required String thought}) {
  //   if (user.id != forum.authorId) {
  //     activitiesForumRef
  //         .doc(forum.authorId)
  //         .collection('userActivitiesForum')
  //         .add({
  //       'fromUserId': user.id,
  //       'forumId': forum.id,
  //       'forumAuthorId': forum.authorId,
  //       'isThoughtReplied': false,
  //       'seen': '',
  //       'isThoughtLike': isThoughtLiked,
  //       'forumTitle': forum.title,
  //       'thought': thought,
  //       'thoughtId': thoughtId,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': user.profileImageUrl,
  //       'authorName': user.userName,
  //       'authorProfileHanlde': user.profileHandle,
  //       'authorVerification': user.verified,
  //     });
  //   }
  // }

  // static void addActivityThoughtReplyItem(
  //     {required Forum forum,
  //     required AccountHolder user,
  //     required String replyThought,
  //     required bool isThoughtLiked,
  //     required bool isThoughtReplied,
  //     required Thought thought}) {
  //   if (user.id != thought.authorId) {
  //     activitiesForumRef
  //         .doc(thought.authorId)
  //         .collection('userActivitiesForum')
  //         .add({
  //       'fromUserId': user.id,
  //       'forumId': forum.id,
  //       'forumAuthorId': forum.authorId,
  //       'seen': '',
  //       'isThoughtLike': isThoughtLiked,
  //       'isThoughtReplied': isThoughtReplied,
  //       'forumTitle': forum.title,
  //       'thought': replyThought,
  //       'thoughtId': thought.id,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': user.profileImageUrl,
  //       'authorName': user.userName,
  //       'authorProfileHanlde': user.profileHandle,
  //       'authorVerification': user.verified,
  //     });
  //   }
  // }

  // static void addActivityThoughtLikeItem(
  //     {required Forum forum,
  //     required AccountHolder user,
  //     required bool isThoughtLiked,
  //     required Thought thought}) {
  //   if (user.id != thought.authorId) {
  //     activitiesForumRef
  //         .doc(thought.authorId)
  //         .collection('userActivitiesForum')
  //         .add({
  //       'fromUserId': user.id,
  //       'forumId': forum.id,
  //       'forumAuthorId': forum.authorId,
  //       'seen': '',
  //       'isThoughtLike': isThoughtLiked,
  //       'isThoughtReplied': false,
  //       'forumTitle': forum.title,
  //       'thought': thought.content,
  //       'thoughtId': thought.id,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': user.profileImageUrl,
  //       'authorName': user.userName,
  //       'authorProfileHanlde': user.profileHandle,
  //       'authorVerification': user.verified,
  //     });
  //   }
  // }

  // static void editActivityForum(ActivityForum activityForum, String userId) {
  //   activitiesForumRef
  //       .doc(userId)
  //       .collection('userActivitiesForum')
  //       .doc(activityForum.id)
  //       .update({
  //     'fromUserId': activityForum.fromUserId,
  //     'forumId': activityForum.forumId,
  //     'seen': activityForum.seen,
  //     'forumTitle': activityForum.forumTitle,
  //     'thought': activityForum.thought,
  //     'timestamp': activityForum.timestamp,
  //   });
  // }

  // static Stream<int> numForumActivities(String userId) {
  //   return activitiesForumRef
  //       .doc(userId)
  //       .collection('userActivitiesForum')
  //       .where('seen', isEqualTo: '')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Future<Forum> getUserForum(String userId, String forumId) async {
  //   DocumentSnapshot forumDocSnapshot =
  //       await forumsRef.doc(userId).collection('userForums').doc(forumId).get();
  //   return Forum.fromDoc(forumDocSnapshot);
  // }

  // static void addActivityEventItem({
  //   required Event event,
  //   required AccountHolder user,
  //   required String ask,
  //   required String commonId,
  // }) {
  //   if (user.id != event.authorId) {
  //     activitiesEventRef
  //         .doc(event.authorId)
  //         .collection('userActivitiesEvent')
  //         .doc(commonId)
  //         .set({
  //       'fromUserId': user.id,
  //       'toUserId': event.authorId,
  //       'eventId': event.id,
  //       'eventInviteType': '',
  //       'invited': false,
  //       'seen': '',
  //       'eventImageUrl': event.imageUrl,
  //       'eventTitle': event.title,
  //       'commonId': commonId,
  //       'ask': ask,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //       'authorProfileImageUrl': user.profileImageUrl,
  //       'authorName': user.userName,
  //       'authorProfileHanlde': user.profileHandle,
  //       'authorVerification': user.verified,
  //     });
  //   }
  // }

  // static void editActivityEvent(ActivityEvent activityEvent, String useId) {
  //   activitiesEventRef
  //       .doc(useId)
  //       .collection('userActivitiesEvent')
  //       .doc(activityEvent.id)
  //       .update({
  //     'fromUserId': activityEvent.fromUserId,
  //     'eventId': activityEvent.eventId,
  //     'seen': activityEvent.seen,
  //     'eventImageUrl': activityEvent.eventImageUrl,
  //     'eventTitle': activityEvent.eventTitle,
  //     'commonId': activityEvent.commonId,
  //     'ask': activityEvent.ask,
  //     'timestamp': activityEvent.timestamp,
  //   });
  // }

  // static void deleteActivityEvent(ActivityEvent activityEvent, String useId) {
  //   activitiesEventRef
  //       .doc(useId)
  //       .collection('userActivitiesEvent')
  //       .doc(activityEvent.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // static Stream<int> numEventActivities(String userId) {
  //   return activitiesEventRef
  //       .doc(userId)
  //       .collection('userActivitiesEvent')
  //       .where('seen', isEqualTo: '')
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numSpecificEventActivities(String userId, String eventId) {
  //   return activitiesEventRef
  //       .doc(userId)
  //       .collection('userActivitiesEvent')
  //       .where('seen', isEqualTo: '')
  //       .where('eventId', isEqualTo: eventId)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  // static Stream<int> numEventInviteActivities(String userId) {
  //   return activitiesEventRef
  //       .doc(userId)
  //       .collection('userActivitiesEvent')
  //       .where('seen', isEqualTo: '')
  //       .where('invited', isEqualTo: true)
  //       .snapshots()
  //       .map((documentSnapshot) => documentSnapshot.docs.length);
  // }

  static Future<Event> getUserEvent(String userId, String eventId) async {
    DocumentSnapshot eventDocSnapshot =
        await eventsRef.doc(userId).collection('userEvents').doc(eventId).get();
    return Event.fromDoc(eventDocSnapshot);
  }

  static Stream<int> numRepliedComment(String postId, String commentId) {
    return commentsRef
        .doc(postId)
        .collection('postComments')
        .doc(commentId)
        .collection('replies')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numRepliedAsks(String eventId, String askId) {
    return asksRef
        .doc(eventId)
        .collection('eventAsks')
        .doc(askId)
        .collection('replies')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void deleteAsks(
      {required String currentUserId,
      required Event event,
      required Ask ask}) async {
    asksRef.doc(event.id).collection('eventAsks').doc(ask.id).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void deleteAskReply({
    required String askId,
    required String replyId,
    required Event event,
  }) async {
    asksRef
        .doc(event.id)
        .collection('eventAsks')
        .doc(askId)
        .collection('replies')
        .doc(replyId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void editAsks(
    String askId,
    String askContent,
    // String commentAu,
    Event event,
  ) {
    asksRef.doc(event.id).collection('eventAsks').doc(askId).update({
      'content': askContent,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  static void editAsksReply(
    String askId,
    String replyId,
    String askContent,
    Event event,
  ) {
    asksRef
        .doc(event.id)
        .collection('eventAsks')
        .doc(askId)
        .collection('replies')
        .doc(replyId)
        .update({
      'content': askContent,
      // 'authorId': comment.authorId,
      // 'timestamp': comment.timestamp
    });
  }

  static void addAskReply({
    required String askId,
    required Event event,
    required String ask,
    // Reply reply,
    required AccountHolderAuthor user,
  }) {
    asksRef
        .doc(event.id)
        .collection('eventAsks')
        .doc(askId)
        .collection('replies')
        .add({
      // 'id': reply.id,
      'content': ask,
      'authorId': user.userId,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorProfileImageUrl': user.profileImageUrl,
      'authorVerification': user.verified,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'parentId': askId,
      'report': '',
      'reportConfirmed': '',
    });
    addActivityItem(
      user: user,
      post: null,
      comment: ask,
      type: NotificationActivityType.ask,
      event: event,
      followerUser: null,
      advicedUserId: '',
    );
  }

  // static Future<List<Event>> setupEventCity(AccountHolder user, int limit,
  //     List<DocumentSnapshot> eventCitySnapshot) async {
  //   QuerySnapshot eventFeedSnapShot = await allEventsRef
  //       .where('city', isEqualTo: user.city)
  //       .where('country', isEqualTo: user.country)
  //       .where('showOnExplorePage', isEqualTo: true)
  //       .limit(limit)
  //       .get();
  //   List<Event> events = eventFeedSnapShot.docs
  //       .map((doc) => Event.fromDoc(doc))
  //       .toList()
  //     ..shuffle();
  //   eventCitySnapshot.addAll((eventFeedSnapShot.docs));

  //   return events;
  // }

  static Future<String> myDynamicLink(
      String imageUrl, String title, String subtitle, String urilink) async {
    try {
      var linkUrl = Uri.parse(imageUrl);

      final dynamicLinkParams = DynamicLinkParameters(
        socialMetaTagParameters: SocialMetaTagParameters(
          imageUrl: linkUrl,
          title: title,
          description: title,
        ),
        link: Uri.parse(urilink),
        uriPrefix: 'https://barsopus.com/barsImpression',
        androidParameters:
            AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
        iosParameters: IOSParameters(
          bundleId: 'com.bars-Opus.barsImpression',
          appStoreId: '1610868894',
        ),
      );

      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

      return link.shortUrl.toString();
      // FirebaseDynamicLinks
    } on FirebaseDynamicLinks catch (e) {
      print('FirebaseDynamicLinksException: $e');
      return '';
    } catch (e) {
      print('Error building dynamic link: $e');
      return '';
    }
  }
}
