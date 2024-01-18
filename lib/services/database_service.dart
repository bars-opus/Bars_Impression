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
      'profileHandle': user.profileHandle!,
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

  static void addChatActivityItem({
    required String currentUserId,
    required String toUserId,
    required AccountHolderAuthor author,
    required String content,
  }) {}

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

  // Future<bool> validateTicket(String userOrderId, String entranceId) async {
  //   print('userOrderId  ' + userOrderId);
  //   print('entranceId ' + entranceId);
  //   try {
  //     // Start a Firestore transaction
  //     return await FirebaseFirestore.instance
  //         .runTransaction<bool>((transaction) async {
  //       // Get the order document reference
  //       DocumentReference orderDocRef = newEventTicketOrderRef
  //           .doc(widget.event.id)
  //           .collection('eventInvite')
  //           .doc(userOrderId);

  //       // Read the order document
  //       DocumentSnapshot orderSnapshot = await transaction.get(orderDocRef);

  //       if (!orderSnapshot.exists) {
  //         // Order does not exist
  //         return false;
  //       }

  //       // Deserialize the order document into TicketOrderModel using the fromDoc method
  //       TicketOrderModel order = TicketOrderModel.fromDoc(orderSnapshot);

  //       // Find the specific ticket to validate
  //       for (var i = 0; i < order.tickets.length; i++) {
  //         if (order.tickets[i].entranceId == entranceId) {
  //           // Check the event date and validation status
  //           DateTime eventDate = order.tickets[i].eventTicketDate.toDate();
  //           DateTime today = DateTime.now();
  //           bool isEventToday = eventDate.year == today.year &&
  //               eventDate.month == today.month &&
  //               eventDate.day == today.day;

  //           if (!isEventToday || order.tickets[i].validated) {
  //             // If the event date does not match or the ticket is already validated
  //             return false;
  //           }

  //           // // Update the validated status of the ticket
  //           // order.tickets[i] = order.tickets[i].copyWith(validated: true);

  //           // Update the order document with the updated tickets list
  //           transaction.update(orderDocRef, {
  //             'tickets': order.tickets.map((ticket) => ticket.toJson()).toList()
  //           });

  //           // Ticket successfully validated
  //           return true;
  //         }
  //       }

  //       // Ticket not found
  //       return false;
  //     });
  //   } catch (error) {
  //     // Handle errors here
  //     print(error); // Replace with proper error handling
  //     return false;
  //   }
  // }



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
      event: null,
      comment: "${user.userName} Started following you",
      followerUser: user,
      post: null,
      type: NotificationActivityType.follow,
      advicedUserId: '',
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
  }

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

    userBlockingRef
        .doc(userId)
        .collection('userBlocking')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

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

  static Future<int> numUsersAll(String profileHandle) async {
    QuerySnapshot feedSnapShot = await userProfessionalRef
        .where('profileHandle', isEqualTo: profileHandle)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedSnapShot.docs.length - 1;
  }

  static Future<int> numusersLiveLocation(
      String profileHandle, String liveCity, String liveCountry) async {
    QuerySnapshot feedSnapShot = await userProfessionalRef
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
  }

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

  static Future<bool> isHavingTicket(
      {required String eventId, required String userId}) async {
    DocumentSnapshot ticketDoc = await newEventTicketOrderRef
        .doc(eventId)
        .collection('eventInvite')
        .doc(userId)
        .get();
    return ticketDoc.exists;
  }

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
  }

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
    });
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
  }

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

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot =
        await postsRef.doc(userId).collection('userPosts').doc(postId).get();
    return Post.fromDoc(postDocSnapshot);
  }

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
