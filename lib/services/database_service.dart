import 'dart:math';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

    DocumentReference usersRatingdocRef =
        usersRatingRef.doc(signedInHandler.uid);

    DocumentReference followerRef = followersRef
        .doc(signedInHandler.uid)
        .collection('userFollowers')
        .doc(signedInHandler.uid);

    batch.set(followerRef, {'userId': signedInHandler.uid});

    double randomId = Random().nextDouble();

    batch.set(userAuthorRef, {
      'bio': '',
      'disableChat': false,
      'disabledAccount': false,
      'dynamicLink': '',
      'lastActiveDate': Timestamp.fromDate(DateTime.now()),
      'name': signedInHandler.displayName ?? name,
      'privateAccount': false,
      'profileHandle': 'Fan',
      'profileImageUrl': '',
      'reportConfirmed': false,
      'userId': signedInHandler.uid,
      'userName': '',
      'verified': false,
    });

    batch.set(userLocationSettingsRef, {
      'userId': signedInHandler.uid,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'country': '',
      'continent': '',
      'city': '',
      'currency': '',
      'subaccountId': '',
      'transferRecepientId': '',
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
      'reportConfirmedReason': '',
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
      'disableAdvice': false,
      'hideAdvice': false,
      'improvemenSuggestion': '',
      'showOnExplorePage': true,
      'transferRecepientId': '',
    });

    batch.set(usersRatingdocRef, {
      'userId': signedInHandler.uid,
      'oneStar': 0,
      'twoStar': 0,
      'threeStar': 0,
      'fourStar': 0,
      'fiveStar': 0,
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

  static Future<bool> isUsernameTaken(String newUsername) async {
    final QuerySnapshot result =
        await usersAuthorRef.where('userName', isEqualTo: newUsername).get();

    return result.docs.isNotEmpty;
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
      comment: "Started following you",
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

  static void sendFollowRequest({
    required String currentUserId,
    required AccountHolderAuthor privateUser,
    required AccountHolderAuthor currentUser,
  }) {
    // Create a follow request for the private user to accept or reject
    followRequestsRef
        .doc(privateUser.userId)
        .collection('receivedFollowRequests')
        .doc(currentUserId)
        .set({
      'userId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(), // To order requests
    });

    addActivityItem(
      user: currentUser,
      event: null,
      comment: "Requested to follow you.",
      followerUser: privateUser,
      post: null,
      type: NotificationActivityType.follow,
      advicedUserId: '',
    );
  }

  static acceptFollowRequest({
    required String currentUserId,
    required String requesterUserId,
    required String activityId,
    required AccountHolderAuthor currentUser,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference followersDocRef = followersRef
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(requesterUserId);

    DocumentReference followingDocRef = followingRef
        .doc(requesterUserId)
        .collection('userFollowing')
        .doc(currentUserId);

    DocumentReference followRequestDocRef = followRequestsRef
        .doc(currentUserId)
        .collection('receivedFollowRequests')
        .doc(requesterUserId);

    DocumentReference activityRef = activitiesRef
        .doc(currentUserId)
        .collection('userActivities')
        .doc(activityId);

    DocumentReference requesterRef = activitiesRef
        .doc(requesterUserId)
        .collection('userActivities')
        .doc(activityId);

    // Add the requester to current user's followers collection
    batch.set(followersDocRef, {
      'userId': requesterUserId,
    });

    // Add the current user to the requester's following collection
    batch.set(followingDocRef, {
      'userId': currentUserId,
    });

    // Delete the follow request
    batch.delete(followRequestDocRef);
    batch.delete(activityRef);

    batch.set(requesterRef, {
      'helperFielId': '',
      'activityId': activityId,
      'authorId': currentUser.userId,
      'postId': currentUser.userId,
      'seen': false,
      'type':
          'follow', // Assuming 'NotificationActivityType.follow' is the correct value
      'postImageUrl': currentUser.profileImageUrl,
      'comment': "Accepted your follow request.",
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'authorProfileImageUrl': currentUser.profileImageUrl,
      'authorName': currentUser.userName,
      'authorProfileHandle': currentUser.profileHandle,
      'authorVerification': currentUser.verified,
    });

    // Commit the batch
    await batch.commit();
  }

  static void cancelFollowRequest({
    required String currentUserId,
    required String requesterUserId,
  }) async {
    // Simply delete the follow request
    followRequestsRef
        .doc(currentUserId)
        .collection('receivedFollowRequests')
        .doc(requesterUserId)
        .delete();
  }

  static rejectFollowRequest({
    required String currentUserId,
    required String userId,
    required String activityId,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference followRequestDocRef = followRequestsRef
        .doc(currentUserId)
        .collection('receivedFollowRequests')
        .doc(userId);

    DocumentReference activityDocRef = activitiesRef
        .doc(currentUserId)
        .collection('userActivities')
        .doc(activityId);

    // Queue the deletion of the follow request
    batch.delete(followRequestDocRef);

    // Queue the deletion of the activity
    batch.delete(activityDocRef);

    // Commit the batch to atomically execute the delete operations
    await batch.commit();
  }

  static Future<bool> isFollowingRequested(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot followingDoc = await followRequestsRef
        .doc(userId)
        .collection('receivedFollowRequests')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
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

//Search.

  static Future<QuerySnapshot> serchTicket(String name, String currentUserId) {
    String trimedName = name.toUpperCase().trim();
    // String formattedName = trimedName.replaceAll(RegExp(r'[^\w\s#@]'), '');
    // String formattedName2 =
    //     formattedName.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    Future<QuerySnapshot> tickets = newUserTicketOrderRef
        .doc(currentUserId)
        .collection('ticketOrders')
        .orderBy(
            'eventTitle') // Replace 'name' with the field you want to order your documents by
        .startAt([trimedName])
        // .endAt([name + '\uf8ff'])
        .limit(10)
        .get();
    return tickets;
  }

  static Future<List<DocumentSnapshot>> searchEvent(String title) async {
    String trimmedTitle = title.toUpperCase().trim();

    QuerySnapshot querySnapshot = await allEventsRef
        .orderBy('title')
        .startAt([trimmedTitle])
        .limit(10)
        .get();

    return querySnapshot.docs;
  }

//Chat and event room
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
      'timestamp': Timestamp.fromDate(DateTime.now()),
      //  FieldValue.serverTimestamp(),
    };

    final receivers = {
      'lastMessage': message.content,
      'isSeen': false,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    };

    final usersDocs = await newEventTicketOrderRef
        .doc(eventId)
        .collection('ticketOrders')
        .get();

    for (var doc in usersDocs.docs) {
      String userId = doc.id;
      final conversationRef =
          userTicketIdRef.doc(userId).collection('tickedIds').doc(eventId);

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
    // required String chatId,
    required String currentUserId,
    required String contentSharing,
    required List<AccountHolderAuthor> users,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Prepare a list to hold all the futures for fetching unique chat IDs.
    List<Future<String>> chatIdFutures = [];

    for (var user in users) {
      var future = usersAuthorRef
          .doc(currentUserId)
          .collection('new_chats')
          .doc(user.userId)
          .get()
          .then((snapshot) => snapshot.data()?['messageId'] as String? ?? '');
      chatIdFutures.add(future);
    }
    // Await all the futures to complete and collect all the unique chat IDs.
    List<String> uniqueChatIds = await Future.wait(chatIdFutures);

    // Now that we have all unique chat IDs, we can proceed with batch updates.

    for (int i = 0; i < users.length; i++) {
      var user = users[i];
      var uniqueChatId = uniqueChatIds[i];

      // Ensure that the uniqueChatId is not an empty string
      if (uniqueChatId.isEmpty) {
        // Handle the case where the uniqueChatId is not found
        continue;
      }

      final conversationRef =
          messageRef.doc(uniqueChatId).collection('conversation');

      final updatedSenderChat = {
        'lastMessage':
            message.content.isEmpty ? 'sent $contentSharing' : message.content,
        'mediaType': '',
        'seen': true,
        'newMessageTimestamp': FieldValue.serverTimestamp(),
        'clientTimestamp': Timestamp.fromDate(DateTime.now()),
      };

      final updatedReceiverChat = {
        'lastMessage': message.content.isEmpty
            ? 'received $contentSharing'
            : message.content,
        'mediaType': '',
        'seen': false,
        'newMessageTimestamp': FieldValue.serverTimestamp(),
        'clientTimestamp': Timestamp.fromDate(DateTime.now()),
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
          .doc(currentUserId)
          .collection('new_chats')
          .doc(user.userId); // Use user's id from the loop

      batch.update(senderChatRef, updatedSenderChat);

      // Add or update the chat in the receiver's new_chats collection
      final receiverChatRef = usersAuthorRef
          .doc(user.userId)
          .collection('new_chats')
          .doc(currentUserId);

      batch.update(receiverChatRef, updatedReceiverChat);
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
      'mediaType': '',
      'seen': true,
      // 'seen': currentUserId == message.senderId ? true : false,
      'newMessageTimestamp': FieldValue.serverTimestamp(),
    };

    final updatedReceiverChat = {
      'lastMessage': message.content,
      'mediaType': '',
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
        'mediaType': mediaType,
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
        'mediaType': mediaType,
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

//Event

//submit draft
  static Future<void> createEventDraft(
    Event event,
    UserData provider,
  ) async {
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> eventData = event.toJson();
    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // Add the event to 'eventsRef'
    DocumentReference eventRef =
        eventsDraftRef.doc(event.authorId).collection('events').doc(event.id);
    batch.set(eventRef, eventData);
    // Commit the batch
    await batch.commit();
    provider.setEventId(event.id);

    provider.setIsLoading(false);
  }

  static Future<void> deleEventDraft(
    Event event,
  ) async {
    // Create a toJson method inside Event class to serialize the object into a map
    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // Add the event to 'eventsRef'
    DocumentReference eventRef =
        eventsDraftRef.doc(event.authorId).collection('events').doc(event.id);
    batch.delete(eventRef);
    // Commit the batch
    await batch.commit();
    // Commit the batch
  }

// Edit draft
  // static Future<void> editEventDraft({
  //   required String imageUrl,
  //   required String venue,
  //   required bool isVirtual,
  //   required bool isPrivate,
  //   required bool showToFollowers,
  //   required bool isFree,
  //   required UserData provider,
  //   required bool isCashPayment,
  //   required bool showOnExplorePage,
  //   required Event? event,
  // }) async {
  //   // Create a Map to hold the fields to update
  //   Map<String, dynamic> eventData = {};

  //   // Compare each field with the existing values in the event model
  //   if (event!.imageUrl != imageUrl) {
  //     if (provider.imageUrlDraft != imageUrl) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['imageUrl'] = imageUrl;
  //       provider.setImageUrlDraft(
  //           imageUrl); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.virtualVenue != venue) {
  //     if (provider.virtualVenueDraft != venue) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['virtualVenue'] = venue;
  //       provider.setEventVirtualVenueDraft(
  //           venue); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.isVirtual != isVirtual) {
  //     if (provider.isVirtualDraft != isVirtual) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['isVirtual'] = isVirtual;
  //       provider.setIsVirtualDraft(
  //           isVirtual); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.isPrivate != isPrivate) {
  //     if (provider.isPrivateDraft != isPrivate) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['isPrivate'] = isPrivate;
  //       provider.setIsPrivateDraft(
  //           isPrivate); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.showToFollowers != showToFollowers) {
  //     if (provider.showToFollowersDraft != showToFollowers) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['showToFollowers'] = showToFollowers;
  //       provider.setShowToFollowersDraft(
  //           showToFollowers); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.isFree != isFree) {
  //     if (provider.isFreeDraft != isFree) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['isFree'] = isFree;
  //       provider
  //           .setIsFreeDraft(isFree); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.isCashPayment != isCashPayment) {
  //     if (provider.isCashPaymentDraft != isCashPayment) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['isCashPayment'] = isCashPayment;
  //       provider.setIsCashPaymentDraft(
  //           isCashPayment); // Assuming you have a corresponding setter
  //     }
  //   }

  //   if (event.showOnExplorePage != showOnExplorePage) {
  //     if (provider.showOnExplorePageDraft != showOnExplorePage) {
  //       // Assuming you have a corresponding draft variable
  //       eventData['showOnExplorePage'] = showOnExplorePage;
  //       provider.setShowOnExplorePageDraft(
  //           showOnExplorePage); // Assuming you have a corresponding setter
  //     }
  //   }

  //   // Check if there are any fields to update
  //   if (eventData.isNotEmpty) {
  //     // Prepare the batch
  //     WriteBatch batch = FirebaseFirestore.instance.batch();

  //     // Add the event to 'eventsRef'
  //     DocumentReference eventRef =
  //         eventsDraftRef.doc(event.authorId).collection('events').doc(event.id);
  //     batch.update(eventRef, eventData);

  //     // Commit the batch
  //     await batch.commit();
  //   }
  // }

  //
  //
//
  static Future<void> editEventDraft({
    required String imageUrl,
    required String venue,
    required bool isVirtual,
    required bool isPrivate,
    required bool showToFollowers,
    required bool isFree,
    required UserData provider,
    required bool isCashPayment,
    required bool showOnExplorePage,
    required Event? event,
    required bool isDraft,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // Update imageUrl
    if (provider.imageUrlDraft != imageUrl) {
      eventData['imageUrl'] = imageUrl;
      provider.setImageUrlDraft(imageUrl);
    }

    // Update isVirtual
    if (provider.isVirtualDraft != isVirtual) {
      eventData['isVirtual'] = isVirtual;
      provider.setIsVirtualDraft(isVirtual);
    }

    // Update isPrivate
    if (provider.isPrivateDraft != isPrivate) {
      eventData['isPrivate'] = isPrivate; // Update eventData with the new value
      provider.setIsPrivateDraft(isPrivate); // Update the draft
    }

    // Update showToFollowers
    if (provider.showToFollowersDraft != showToFollowers) {
      eventData['showToFollowers'] = showToFollowers;
      provider.setShowToFollowersDraft(showToFollowers);
    }

    // Update isFree
    if (provider.isFreeDraft != isFree) {
      eventData['isFree'] = isFree;
      provider.setIsFreeDraft(isFree);
    }

    // Update isCashPayment
    if (provider.isCashPaymentDraft != isCashPayment) {
      eventData['isCashPayment'] = isCashPayment;
      provider.setIsCashPaymentDraft(isCashPayment);
    }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = isDraft
          ? await eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : await eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);
      // DocumentReference eventRef = eventsDraftRef
      //     .doc(event!.authorId)
      //     .collection('events')
      //     .doc(event.id);
      // batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// Update imageUrl method
  // static void updateImageUrl(
  //     String imageUrl, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.imageUrlDraft != imageUrl) {
  //     eventData['imageUrl'] = imageUrl;
  //     provider.setImageUrlDraft(imageUrl);
  //   }
  // }

// Update virtualVenue method
  // static void updateVirtualVenue(
  //     String venue, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.virtualVenueDraft != venue) {
  //     eventData['virtualVenue'] = venue;
  //     provider.setEventVirtualVenueDraft(venue);
  //   }
  // }

// Update isVirtual method
  // static void updateIsVirtual(
  //     bool isVirtual, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.isVirtualDraft != isVirtual) {
  //     eventData['isVirtual'] = isVirtual;
  //     provider.setIsVirtualDraft(isVirtual);
  //   }
  // }

// Update isPrivate method
  // static void updateIsPrivate(
  //     bool isPrivate, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.isPrivateDraft != isPrivate) {
  //     eventData['isPrivate'] = isPrivate;
  //     provider.setIsPrivateDraft(isPrivate);
  //   }
  // }

// Update showToFollowers method
  // static void updateShowToFollowers(
  //     bool showToFollowers, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.showToFollowersDraft != showToFollowers) {
  //     eventData['showToFollowers'] = showToFollowers;
  //     provider.setShowToFollowersDraft(showToFollowers);
  //   }
  // }

// Update isFree method
  // static void updateIsFree(
  //     bool isFree, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.isFreeDraft != isFree) {
  //     eventData['isFree'] = isFree;
  //     provider.setIsFreeDraft(isFree);
  //   }
  // }

// Update isCashPayment method
  // static void updateIsCashPayment(
  //     bool isCashPayment, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.isCashPaymentDraft != isCashPayment) {
  //     eventData['isCashPayment'] = isCashPayment;
  //     provider.setIsCashPaymentDraft(isCashPayment);
  //   }
  // }

// Update showOnExplorePage method
  // static void updateShowOnExplorePage(bool showOnExplorePage, UserData provider,
  //     Map<String, dynamic> eventData) {
  //   if (provider.showOnExplorePageDraft != showOnExplorePage) {
  //     eventData['showOnExplorePage'] = showOnExplorePage;
  //     provider.setShowOnExplorePageDraft(showOnExplorePage);
  //   }
  // }

//
//
//
  // Edit draft
  static Future<void> editEventTitleAndThemeDraft({
    required String title,
    required String theme,
    required String overView,
    required String dressCode,
    required String city,
    required String country,
    required String aiMarketingAdvice,
    required UserData provider,
    required Event? event,
    required bool isDraft,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // Update title
    if (provider.titleDraft != title) {
      eventData['title'] = title;
      provider.setTitleDraft(title);
    }
    // if (isDraft) {
    //   if (event!.title != title) {
    //     if (provider.titleDraft != title) {
    //       eventData['title'] = title;
    //       provider.setTitleDraft(title);
    //     }
    //   }
    // } else {
    //   if (provider.titleDraft != title) {
    //     eventData['title'] = title;
    //     provider.setTitleDraft(title);
    //   }
    // }

    // Update theme
    if (provider.themeDraft != theme) {
      eventData['theme'] = theme;
      provider.setThemeDraft(theme);
    }

    if (provider.aiMarketingDraft != aiMarketingAdvice) {
      eventData['aiMarketingAdvice'] = aiMarketingAdvice;
      provider.setAiMarketingDraft(aiMarketingAdvice);
    }
    // if (isDraft) {
    //   if (event!.theme != theme) {
    //     if (provider.themeDraft != theme) {
    //       eventData['theme'] = theme;
    //       provider.setThemeDraft(theme);
    //     }
    //   }
    // } else {
    //   if (provider.themeDraft != theme) {
    //     eventData['theme'] = theme;
    //     provider.setThemeDraft(theme);
    //   }
    // }

    // Update overview
    if (provider.overviewDraft != overView) {
      eventData['overview'] = overView;
      provider.setOverviewDraft(overView);
    }
    // if (isDraft) {
    //   if (event!.overview != overView) {
    //     if (provider.overviewDraft != overView) {
    //       eventData['overview'] = overView;
    //       provider.setOverviewDraft(overView);
    //     }
    //   }
    // } else {
    //   if (provider.overviewDraft != overView) {
    //     eventData['overview'] = overView;
    //     provider.setOverviewDraft(overView);
    //   }
    // }

    // Update dressCode
    if (provider.dressingCodeDraft != dressCode) {
      eventData['dressCode'] = dressCode;
      provider.setDressingCodeDraft(dressCode);
    }
    // if (isDraft) {
    //   if (event!.dressCode != dressCode) {
    //     if (provider.dressingCodeDraft != dressCode) {
    //       eventData['dressCode'] = dressCode;
    //       provider.setDressingCodeDraft(dressCode);
    //     }
    //   }
    // } else {
    //   if (provider.dressingCodeDraft != dressCode) {
    //     eventData['dressCode'] = dressCode;
    //     provider.setDressingCodeDraft(dressCode);
    //   }
    // }

    // Update city
    if (provider.cityDraft != city) {
      eventData['city'] = city;
      provider.setCityDraft(city);
    }
    // if (isDraft) {
    //   if (event!.city != city) {
    //     if (provider.cityDraft != city) {
    //       eventData['city'] = city;
    //       provider.setCityDraft(city);
    //     }
    //   }
    // } else {
    //   if (provider.cityDraft != city) {
    //     eventData['city'] = city;
    //     provider.setCityDraft(city);
    //   }
    // }

    // Update country
    if (provider.countryDraft != country) {
      eventData['country'] = country;
      provider.setCountryDraft(country);
    }
    // if (isDraft) {
    //   if (event!.country != country) {
    //     if (provider.countryDraft != country) {
    //       eventData['country'] = country;
    //       provider.setCountryDraft(country);
    //     }
    //   }
    // } else {
    //   if (provider.countryDraft != country) {
    //     eventData['country'] = country;
    //     provider.setCountryDraft(country);
    //   }
    // }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = isDraft
          ? await eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : await eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// Update title method
  // static void updateTitle(
  //     String title, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.titleDraft != title) {
  //     eventData['title'] = title;
  //     provider.setTitleDraft(title);
  //   }
  // }

// Update theme method
  // static void updateTheme(
  //     String theme, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.themeDraft != theme) {
  //     eventData['theme'] = theme;
  //     provider.setThemeDraft(theme);
  //   }
  // }

// Update overview method
  // static void updateOverview(
  //     String overView, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.overviewDraft != overView) {
  //     eventData['overview'] = overView;
  //     provider.setOverviewDraft(overView);
  //   }
  // }

// Update dressCode method
  // static void updateDressCode(
  //     String dressCode, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.dressingCodeDraft != dressCode) {
  //     eventData['dressCode'] = dressCode;
  //     provider.setDressingCodeDraft(dressCode);
  //   }
  // }

// Update city method
  // static void updateCity(
  //     String city, UserData provider, Map<String, dynamic> eventData) {
  // if (provider.cityDraft != city) {
  //   eventData['city'] = city;
  //   provider.setCityDraft(city);
  // }
  // }

// Update country method
  // static void updateCountry(
  //     String country, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.countryDraft != country) {
  //     eventData['country'] = country;
  //     provider.setCountryDraft(country);
  //   }
  // }

//
//
// Edit draft
//edit type, category, startdate, and closing date
  static Future<void> editEventDraftTypeAndDates({
    required String type,
    required String category,
    required Timestamp startDate,
    required Timestamp closingDay,
    required Event? event,
    required UserData provider,
    required bool isDraft,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // Update type
    if (provider.typeDraft != type) {
      eventData['type'] = type;
      provider.setTypeDraft(type);
    }
    // if (isDraft) {
    //   if (event!.type != type) {
    //     if (provider.typeDraft != type) {
    //       eventData['type'] = type;
    //       provider.setTypeDraft(type);
    //     }
    //   }
    // } else {
    //   if (provider.typeDraft != type) {
    //     eventData['type'] = type;
    //     provider.setTypeDraft(type);
    //   }
    // }

    // Update category
    if (provider.categoryDraft != category) {
      eventData['category'] = category;
      provider.setCategoryDraft(category);
    }
    // if (isDraft) {
    //   if (event!.category != category) {
    //     if (provider.categoryDraft != category) {
    //       eventData['category'] = category;
    //       provider.setCategoryDraft(category);
    //     }
    //   }
    // } else {
    //   if (provider.categoryDraft != category) {
    //     eventData['category'] = category;
    //     provider.setCategoryDraft(category);
    //   }
    // }

    // Update startDate
    if (provider.startDateDraft != startDate) {
      eventData['startDate'] = startDate;
      provider.setStartDateDraft(startDate);
    }
    // if (isDraft) {
    //   if (event!.startDate != startDate) {
    //     if (provider.startDateDraft != startDate) {
    //       eventData['startDate'] = startDate;
    //       provider.setStartDateDraft(startDate);
    //     }
    //   }
    // } else {
    //   if (provider.startDateDraft != startDate) {
    //     eventData['startDate'] = startDate;
    //     provider.setStartDateDraft(startDate);
    //   }
    // }

    // Update closingDay
    if (provider.closingDayDraft != closingDay) {
      eventData['clossingDay'] = closingDay;
      provider.setClosingDayDraft(closingDay);
    }
    // if (isDraft) {
    //   if (event!.clossingDay != closingDay) {
    //     if (provider.closingDayDraft != closingDay) {
    //       eventData['closingDay'] = closingDay;
    //       provider.setClosingDayDraft(closingDay);
    //     }
    //   }
    // } else {
    //   if (provider.closingDayDraft != closingDay) {
    //     eventData['closingDay'] = closingDay;
    //     provider.setClosingDayDraft(closingDay);
    //   }
    // }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = isDraft
          ? await eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : await eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// Update type method
  // static void updateEventType(
  //     String type, UserData provider, Map<String, dynamic> eventData) {
  // if (provider.typeDraft != type) {
  //   eventData['type'] = type;
  //   provider.setTypeDraft(type);
  // }
  // }

// Update category method
  // static void updateCategory(
  //     String category, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.categoryDraft != category) {
  //     eventData['category'] = category;
  //     provider.setCategoryDraft(category);
  //   }
  // }

// Update startDate method
  // static void updateStartDate(
  //     Timestamp startDate, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.startDateDraft != startDate) {
  //     eventData['startDate'] = startDate;
  //     provider.setStartDateDraft(startDate);
  //   }
  // }

// Update closingDay method
  // static void updateClosingDay(
  //     Timestamp closingDay, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.closingDayDraft != closingDay) {
  //     eventData['closingDay'] = closingDay;
  //     provider.setClosingDayDraft(closingDay);
  //   }
  // }

//
//
//
// Edit draft
//Edit contacts, previous events, marketing advive and terms and conditons
  static Future<void> editEventDraftContactAndTerms({
    required UserData provider,
    required List<String> contacts,
    required String previousEvent,
    required String termsAndConditions,
    required Event? event,
    required bool isDraft,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // Update contacts
    if (!listEquals(provider.eventOrganizerContactsDraft, contacts)) {
      eventData['contacts'] = contacts;
      provider.setEventOrganizerContactsDraft(contacts);
    }
    // if (isDraft) {
    //   if (!listEquals(event!.contacts, contacts)) {
    //     if (!listEquals(provider.eventOrganizerContactsDraft, contacts)) {
    //       eventData['contacts'] = contacts;
    //       provider.setEventOrganizerContactsDraft(contacts);
    //     }
    //   }
    // } else {
    //   if (!listEquals(provider.eventOrganizerContactsDraft, contacts)) {
    //     eventData['contacts'] = contacts;
    //     provider.setEventOrganizerContactsDraft(contacts);
    //   }
    // }

    // Update previousEvent
    if (provider.previousEventDraft != previousEvent) {
      eventData['previousEvent'] = previousEvent;
      provider.setPreviousEventDraftDraft(previousEvent);
    }
    // if (isDraft) {
    //   if (event!.previousEvent != previousEvent) {
    //     if (provider.previousEventDraft != previousEvent) {
    //       eventData['previousEvent'] = previousEvent;
    //       provider.setPreviousEventDraftDraft(previousEvent);
    //     }
    //   }
    // } else {
    //   if (provider.previousEventDraft != previousEvent) {
    //     eventData['previousEvent'] = previousEvent;
    //     provider.setPreviousEventDraftDraft(previousEvent);
    //   }
    // }

    // Update aiMarketingAdvice

    // if (isDraft) {
    //   if (event!.aiMarketingAdvice != aiMarketingAdvice) {
    //     if (provider.aiMarketingDraft != aiMarketingAdvice) {
    //       eventData['aiMarketingAdvice'] = aiMarketingAdvice;
    //       provider.setAiMarketingDraft(aiMarketingAdvice);
    //     }
    //   }
    // } else {
    //   if (provider.aiMarketingDraft != aiMarketingAdvice) {
    //     eventData['aiMarketingAdvice'] = aiMarketingAdvice;
    //     provider.setAiMarketingDraft(aiMarketingAdvice);
    //   }
    // }

    // Update termsAndConditions
    if (provider.eventTermsAndConditionsDraft != termsAndConditions) {
      eventData['termsAndConditions'] = termsAndConditions;
      provider.setEventTermsAndConditionsDraft(termsAndConditions);
    }
    // if (isDraft) {
    //   if (event!.termsAndConditions != termsAndConditions) {
    //     if (provider.eventTermsAndConditionsDraft != termsAndConditions) {
    //       eventData['termsAndConditions'] = termsAndConditions;
    //       provider.setEventTermsAndConditionsDraft(termsAndConditions);
    //     }
    //   }
    // } else {
    //   if (provider.eventTermsAndConditionsDraft != termsAndConditions) {
    //     eventData['termsAndConditions'] = termsAndConditions;
    //     provider.setEventTermsAndConditionsDraft(termsAndConditions);
    //   }
    // }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = await isDraft
          ? eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : await eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// Update contacts method
  // static void updateContacts(List<String> contacts, UserData provider,
  //     Map<String, dynamic> eventData) {
  //   if (provider.eventOrganizerContactsDraft != contacts) {
  //     eventData['contacts'] = contacts;
  //     provider.setEventOrganizerContactsDraft(contacts);
  //   }
  // }

// Update previousEvent method
  // static void updatePreviousEvent(
  //     String previousEvent, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.previousEventDraft != previousEvent) {
  //     eventData['previousEvent'] = previousEvent;
  //     provider.setPreviousEventDraftDraft(previousEvent);
  //   }
  // }

// Update aiMarketingAdvice method
  // static void updateAiMarketingAdvice(String aiMarketingAdvice,
  //     UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.aiMarketingDraft != aiMarketingAdvice) {
  //     eventData['aiMarketingAdvice'] = aiMarketingAdvice;
  //     provider.setAiMarketingDraft(aiMarketingAdvice);
  //   }
  // }

// Update termsAndConditions method
  // static void updateTermsAndConditions(String termsAndConditions,
  //     UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.eventTermsAndConditionsDraft != termsAndConditions) {
  //     eventData['termsAndConditions'] = termsAndConditions;
  //     provider.setEventTermsAndConditionsDraft(termsAndConditions);
  //   }
  // }

//
//
//
  // Edit draft
  //edit schedules, tickets, currency, city and country
  static Future<void> editEventDraftScheduleAndTicket({
    required UserData provider,
    required List<Schedule> schedule,
    required List<TicketModel> ticket,
    required String currency,
    required Event? event,
    required bool isDraft,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // print(
    //   provider.ticketListDraft
    //           .map((ticket) => ticket.toJson())
    //           .toList()
    //           .toString() +
    //       'nn',
    // );
    // print(
    //   ticket.map((ticket) => ticket.toJson()).toList().toString() + 'oo',
    // );
    // Update schedule
    if (provider.int2 == 1) {
      if (!listEquals(provider.scheduleDraft.map((s) => s.toJson()).toList(),
          schedule.map((s) => s.toJson()).toList())) {
        eventData['schedule'] = schedule.map((s) => s.toJson()).toList();
        provider.setScheduleDraft(schedule);
      }
      provider.setInt2(0);
    }

    // if (isDraft) {
    //   if (!listEquals(provider.scheduleDraft.map((s) => s.toJson()).toList(),
    //       schedule.map((s) => s.toJson()).toList())) {
    //     eventData['schedule'] = schedule.map((s) => s.toJson()).toList();
    //     provider.setScheduleDraft(schedule);
    //   }
    // } else {
    //   // Compare the JSON representations of the lists
    //   if (!listEquals(provider.scheduleDraft.map((s) => s.toJson()).toList(),
    //       schedule.map((s) => s.toJson()).toList())) {
    //     eventData['schedule'] = schedule.map((s) => s.toJson()).toList();
    //     provider.setScheduleDraft(schedule);
    //   }
    // }

    // Update ticket
    if (provider.int2 == 2) {
      if (!listEquals(provider.ticketListDraft.map((t) => t.toJson()).toList(),
          ticket.map((t) => t.toJson()).toList())) {
        eventData['ticket'] = ticket.map((t) => t.toJson()).toList();
        provider.setTicketListDraft(ticket);
      }
      provider.setInt2(0);
    }
    // // Update currency
    // if (provider.currencyDraft != currency) {
    //   eventData['currency'] = currency;
    //   provider.setCurrencyDraft(currency);
    // }

    // if (isDraft) {
    //   if (event!.rate != currency) {
    //     if (provider.currencyDraft != currency) {
    //       eventData['currency'] = currency;
    //       // provider.setCurrencyDraft(currency);
    //     }
    //   }
    // } else {
    //   if (provider.currencyDraft != currency) {
    //     eventData['currency'] = currency;
    //     // provider.setCurrencyDraft(currency);
    //   }
    // }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = isDraft
          ? eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// // Update schedule method
//   static void updateSchedule(List<Schedule> schedule, UserData provider,
//       Map<String, dynamic> eventData) {
//     if (provider.scheduleDraft != schedule) {
//       eventData['schedule'] = schedule.map((s) => s.toJson()).toList();
//       provider.setScheduleDraft(schedule);
//     }
//   }

// Update ticket method
  // static void updateTicket(List<TicketModel> ticket, UserData provider,
  //     Map<String, dynamic> eventData) {
  //   if (provider.ticketListDraft != ticket) {
  //     eventData['ticket'] = ticket.map((t) => t.toJson()).toList();
  //     provider.setTicketListDraft(ticket);
  //   }
  // }

// Update currency method
  // static void updateCurrency(
  //     String currency, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.currencyDraft != currency) {
  //     eventData['currency'] = currency;
  //     provider.setCurrencyDraft(currency);
  //   }
  // }

//
//
//
  // Edit draft
  static Future<void> editEventDraftAddressAndPeople({
    required UserData provider,
    required List<TaggedEventPeopleModel> taggedPeople,
    required String venue,
    required String address,
    required Event? event,
    required bool isDraft,
    required String city,
    required String country,
  }) async {
    // Create a Map to hold the fields to update
    Map<String, dynamic> eventData = {};

    // Update taggedPeople
    if (provider.int2 == 3) {
      if (!listEquals(
          provider.taggedEventPeopleDraft.map((p) => p.toJson()).toList(),
          taggedPeople.map((p) => p.toJson()).toList())) {
        eventData['taggedPeople'] =
            taggedPeople.map((taggedPerson) => taggedPerson.toJson()).toList();
        provider.setTaggedEventPeopleDraft(taggedPeople);
        provider.setInt2(0);
      }
    }
    // if (isDraft) {
    //   if (!listEquals(event!.taggedPeople.map((p) => p.toJson()).toList(),
    //       taggedPeople.map((p) => p.toJson()).toList())) {
    //     if (!listEquals(
    //         provider.taggedEventPeopleDraft.map((p) => p.toJson()).toList(),
    //         taggedPeople.map((p) => p.toJson()).toList())) {
    //       eventData['taggedPeople'] = taggedPeople
    //           .map((taggedPerson) => taggedPerson.toJson())
    //           .toList();
    //       provider.setTaggedEventPeopleDraft(taggedPeople);
    //     }
    //   }
    // } else {
    //   if (!listEquals(
    //       provider.taggedEventPeopleDraft.map((p) => p.toJson()).toList(),
    //       taggedPeople.map((p) => p.toJson()).toList())) {
    //     eventData['taggedPeople'] =
    //         taggedPeople.map((taggedPerson) => taggedPerson.toJson()).toList();
    //     provider.setTaggedEventPeopleDraft(taggedPeople);
    //   }
    // }

    // Update venue
    if (provider.venueDraft != venue) {
      eventData['venue'] = venue;
      provider.setVenueDraft(venue);
    }
    // if (isDraft) {
    //   if (event!.venue != venue) {
    //     if (provider.venueDraft != venue) {
    //       eventData['venue'] = venue;
    //       provider.setVenueDraft(venue);
    //     }
    //   }
    // } else {
    //   if (provider.venueDraft != venue) {
    //     eventData['venue'] = venue;
    //     provider.setVenueDraft(venue);
    //   }
    // }

    // Update address
    if (provider.addressDraft != address) {
      eventData['address'] = address;
      provider.setAddressDraft(address);
    }
    // if (isDraft) {
    //   if (event!.address != address) {
    //     if (provider.addressDraft != address) {
    //       eventData['address'] = address;
    //       provider.setAddressDraft(address);
    //     }
    //   }
    // } else {
    //   if (provider.addressDraft != address) {
    //     eventData['address'] = address;
    //     provider.setAddressDraft(address);
    //   }
    // }

    // Update city
    if (provider.cityDraft != city) {
      eventData['city'] = city;
      provider.setCityDraft(city);
    }
    // if (isDraft) {
    //   if (event!.city != city) {
    //     if (provider.cityDraft != city) {
    //       eventData['city'] = city;
    //       provider.setCityDraft(city);
    //     }
    //   }
    // } else {
    //   if (provider.cityDraft != city) {
    //     eventData['city'] = city;
    //     provider.setCityDraft(city);
    //   }
    // }

    // Update country
    if (provider.countryDraft != country) {
      eventData['country'] = country;
      provider.setCountryDraft(country);
    }
    // if (isDraft) {
    //   if (event!.country != country) {
    //     if (provider.countryDraft != country) {
    //       eventData['country'] = country;
    //       provider.setCountryDraft(country);
    //     }
    //   }
    // } else {
    //   if (provider.countryDraft != country) {
    //     eventData['country'] = country;
    //     provider.setCountryDraft(country);
    //   }
    // }

    // Check if there are any fields to update
    if (eventData.isNotEmpty) {
      // Prepare the batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the event to 'eventsRef'
      DocumentReference eventRef = isDraft
          ? await eventsDraftRef
              .doc(event!.authorId)
              .collection('events')
              .doc(event.id)
          : await eventsDraftRef
              .doc(provider.currentUserId)
              .collection('events')
              .doc(provider.eventId);
      batch.update(eventRef, eventData);

      // Commit the batch
      await batch.commit();
    }
  }

// Update taggedPeople method
  // static void updateTaggedPeople(List<TaggedEventPeopleModel> taggedPeople,
  //     UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.taggedEventPeopleDraft != taggedPeople) {
  //     eventData['taggedPeople'] =
  //         taggedPeople.map((person) => person.toJson()).toList();
  //     provider.setTaggedEventPeopleDraft(taggedPeople);
  //   }
  // }

// Update venue method
  // static void updateVenue(
  //     String venue, UserData provider, Map<String, dynamic> eventData) {
  //   if (provider.venueDraft != venue) {
  //     eventData['venue'] = venue;
  //     provider.setVenueDraft(venue);
  //   }
  // }

// Update address method
//   static void updateAddress(
//       String address, UserData provider, Map<String, dynamic> eventData) {
//     if (provider.addressDraft != address) {
//       eventData['address'] = address;
//       provider.setAddressDraft(address);
//     }
//   }

//
//
//create event
  static Future<void> createEvent(Event event, AccountHolderAuthor author,
      List<TaggedNotificationModel> taggedsers, String summary) async {
    print(taggedsers.length);
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> eventData = event.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the event to 'eventsRef'
    DocumentReference eventRef =
        eventsRef.doc(event.authorId).collection('userEvents').doc(event.id);
    batch.set(eventRef, eventData);

    if (!event.isPrivate) {
      // Add the event to 'allEventsRef'
      DocumentReference allEventRef = allEventsRef.doc(event.id);
      // FirebaseFirestore.instance.collection('new_allEvents').doc(event.id);
      batch.set(allEventRef, eventData);

      DocumentReference allEventsSummarydocRef =
          allEventsSummaryRef.doc(event.id);
      batch.set(
          allEventsSummarydocRef,
          ({
            'summary': summary,
            'eventId': event.id,
          }));
    }

    // Add the event to 'eventsChatRoomsRef'
    DocumentReference chatRoomRef = eventsChatRoomsRef.doc(event.id);
    batch.set(chatRoomRef, {
      'title': event.title,
      'linkedEventId': event.id,
      'imageUrl': event.imageUrl,
      'report': event.report,
      'reportConfirmed': event.reportConfirmed,
      'isClossed': false,
      'eventAuthorId': event.authorId,
      'timestamp': event.timestamp,
    });

    // Add addUserTicketIdRef to the transaction
    final userTicketIdDocRef = userTicketIdRef
        .doc(event.authorId)
        .collection('tickedIds')
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
      'eventAuthorId': event.authorId,
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
      'idempotencyKey': '',
      'tickets': [],
      'total': 0,
      'userOrderId': event.authorId,
      'purchaseReferenceId': event.id,
    };

    final eventInviteDocRef = newEventTicketOrderRef
        .doc(event.id)
        .collection('ticketOrders')
        .doc(event.authorId);

    final userInviteDocRef = newUserTicketOrderRef
        .doc(event.authorId)
        .collection('ticketOrders')
        .doc(event.id);

    // Add addUserTicketIdRef to the transaction
    await sendTaggedNotificaton(
      batch: batch,
      taggedUsers: taggedsers,
      authorProfileHandle: author.profileHandle,
      authorVerification: author.verified,
    );

    batch.set(eventInviteDocRef, ticketOrderData);
    batch.set(userInviteDocRef, ticketOrderData);

    final eventDraftRef = await eventsDraftRef
        .doc(event.authorId)
        .collection('events')
        .doc(event.id);
    batch.delete(eventDraftRef);
    // Commit the batch
    await batch.commit();

    // Commit the batch
  }

  static Future<void> sendTaggedNotificaton({
    required WriteBatch batch,
    required List<TaggedNotificationModel> taggedUsers,
    required authorProfileHandle,
    required authorVerification,
  }) async {
    for (var taggedUser in taggedUsers) {
      Map<String, dynamic> taggedUserData = taggedUser.toJson();

      print(taggedUserData);

      DocumentReference tagRef = await userTagRef
          .doc(taggedUser.personId)
          .collection('tags')
          .doc(taggedUser.id);
      batch.set(tagRef, taggedUserData);

      // This should also be included in the batch operation
      DocumentReference userActivityRef = await activitiesRef
          .doc(taggedUser.personId)
          .collection('userActivities')
          .doc(); // Create a new document with a generated ID
      batch.set(userActivityRef, {
        'helperFielId': taggedUser.taggedParentAuthorId,
        'authorId': taggedUser.taggedParentAuthorId,
        'postId': taggedUser.id,
        'seen': false,
        'type': 'tag',
        'postImageUrl': taggedUser.taggedParentImageUrl,
        'comment': taggedUser.role == 'Schedule'
            ? 'You have been tagged as a ${taggedUser.role} person in ${taggedUser.taggedParentTitle}'
            : 'You have been tagged as ${taggedUser.role} in ${taggedUser.taggedParentTitle}',
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'authorProfileImageUrl': '',
        'authorName': 'Tagged in Event',
        'authorProfileHandle': authorProfileHandle,
        'authorVerification': authorVerification,
      });
    }
  }

  static Future<void> createEventsNearBy({
    required Event event,
  }) async {
    if (!event.isPrivate) {
      // Fetch users in the same city
      QuerySnapshot querySnapshot = await usersLocationSettingsRef
          .where('city', isEqualTo: event.city)
          .where('country', isEqualTo: event.country)
          .get();

      // Initialize variables for batch processing
      WriteBatch activitiesBatch = FirebaseFirestore.instance.batch();
      int batchCounter = 0;

      // Loop over the users and create an activity document for each one
      for (var doc in querySnapshot.docs) {
        // Get the user's ID
        String userId = doc.id;

        // Create the activity document
        if (userId != event.authorId) {
          DocumentReference userActivityRef =
              activitiesRef.doc(userId).collection('userActivities').doc();
          activitiesBatch.set(userActivityRef, {
            'helperFielId': event.authorId,
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
            'authorProfileHandle': event.authorId,
            'authorVerification': false
          });

          batchCounter++;

          // If batch limit is reached, commit the current batch and start a new one
          if (batchCounter == 500) {
            await activitiesBatch.commit();
            activitiesBatch = FirebaseFirestore.instance.batch();
            batchCounter = 0;
          }
        }
      }

      // Commit any remaining operations in the final batch
      if (batchCounter > 0) {
        await activitiesBatch.commit();
      }
    }
  }

  static Future<void> createOrganiserToAttendeesMarketingNotification({
    required Event event,
  }) async {
    if (!event.isPrivate) {
      // Fetch users in the same city
      QuerySnapshot querySnapshot = await organiserAttendeeListRef
          .doc(event.authorId)
          .collection('OragnizerAttendees')
          .get();

      // Initialize variables for batch processing
      WriteBatch activitiesBatch = FirebaseFirestore.instance.batch();
      int batchCounter = 0;

      // Loop over the users and create an activity document for each one
      for (var doc in querySnapshot.docs) {
        // Get the user's ID
        String userId = doc.id;

        // Create the activity document
        if (userId != event.authorId) {
          DocumentReference userActivityRef =
              activitiesRef.doc(userId).collection('userActivities').doc();
          activitiesBatch.set(userActivityRef, {
            'helperFielId': event.authorId,
            'authorId': event.authorId,
            'postId': event.id,
            'seen': false,
            'type': 'OrganiserToAttendeesMrk',
            'postImageUrl': event.imageUrl,
            'comment': MyDateFormat.toDate(event.startDate.toDate()) +
                '\n${event.title}',
            'timestamp': Timestamp.fromDate(DateTime.now()),
            'authorProfileImageUrl': '',
            'authorName': 'New event by ${event.authorName}\n${event.title}',
            'authorProfileHandle': event.authorId,
            'authorVerification': false
          });

          batchCounter++;

          // If batch limit is reached, commit the current batch and start a new one
          if (batchCounter == 500) {
            await activitiesBatch.commit();
            activitiesBatch = FirebaseFirestore.instance.batch();
            batchCounter = 0;
          }
        }
      }

      // Commit any remaining operations in the final batch
      if (batchCounter > 0) {
        await activitiesBatch.commit();
      }
    }
  }

  static Future<void> editEvent(Event event, String aiAnalysis, String summary,
      String aiMarketingAdvice) async {
    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    Map<String, dynamic> eventData = {
      'title': event.title,
      'overview': event.overview,
      'aiAnalysis': aiAnalysis,
      'aiMarketingAdvice': aiMarketingAdvice,
      'theme': event.theme,
      'startDate': event.startDate,
      'address': event.address,
      'contacts': event.contacts.map((contact) => contact.toString()),
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
    if (!event.isPrivate) {
      DocumentReference allEventRef = allEventsRef.doc(event.id);
      batch.update(allEventRef, eventData);

      if (summary.isNotEmpty) {
        DocumentReference allEventsSummarydocRef =
            allEventsSummaryRef.doc(event.id);
        batch.update(
            allEventsSummarydocRef,
            ({
              'summary': summary,
            }));
      }
    }

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
        .collection('ticketOrders')
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

        // Define references
        DocumentReference userTicketOrderRef = newUserTicketOrderRef
            .doc(userId)
            .collection('ticketOrders')
            .doc(event.id);

        DocumentReference newEventsTicketOrderRef = newEventTicketOrderRef
            .doc(event.id)
            .collection('ticketOrders')
            .doc(userId);

        // Fetch user ticket data
        // DocumentSnapshot userSnapshot = await userTicketOrderRef.get();
        // if (userSnapshot.exists) {
        //   Map<String, dynamic> userData =
        //       userSnapshot.data() as Map<String, dynamic>;
        //   List<dynamic> tickets = userData['tickets'];

        //   // Update tickets
        //   for (var ticket in tickets) {
        //     for (var eventTicket in eventTickets) {
        //       if (ticket['id'] == eventTicket.id) {
        //         ticket['eventTicketDate'] = eventTicket.eventTicketDate;
        //       }
        //     }
        //   }

        // Update batch
        // batch.update(userTicketOrderRef, {'tickets': tickets});
        // batch.update(newEventsTicketOrderRef, {'tickets': tickets});
        // }

        // Update event details
        batch.update(userTicketOrderRef, {
          'eventTimestamp': event.startDate,
          'eventTitle': event.title,
        });
        batch.update(newEventsTicketOrderRef, {
          'eventTimestamp': event.startDate,
          'eventTitle': event.title,
        });

        operationCount += 4;

        // Add user activity if necessary
        if (userId != event.authorId) {
          DocumentReference userActivityRef =
              activitiesRef.doc(userId).collection('userActivities').doc();
          batch.set(userActivityRef, {
            'helperFielId': event.authorId,
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
            'authorProfileHandle': event.authorId,
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

      // for (var doc in querySnapshot.docs) {
      //   String userId = doc.id;

      //   // Update the user's invites
      //   DocumentReference userTicketOrderRef = newUserTicketOrderRef
      //       .doc(userId)
      //       .collection('ticketOrders')
      //       .doc(event.id);
      //   batch.update(userTicketOrderRef, {
      //     'eventTimestamp': event.startDate,
      //     'eventTitle': event.title,
      //   });

      //   // Update the event invites
      //   DocumentReference newEventsTicketOrderRef = newEventTicketOrderRef
      //       .doc(event.id)
      //       .collection('ticketOrders')
      //       .doc(userId);
      //   batch.update(newEventsTicketOrderRef, {
      //     'eventTimestamp': event.startDate,
      //     'eventTitle': event.title,
      //   });

      //   DocumentSnapshot userSnapshot = await userTicketOrderRef.get();
      //   if (userSnapshot.exists) {
      //     Map<String, dynamic> userData =
      //         userSnapshot.data() as Map<String, dynamic>;
      //     List<dynamic> tickets = userData['tickets'];

      //     for (var ticket in tickets) {
      //       for (var eventTicket in eventTickets) {
      //         if (ticket['price'] == eventTicket.price &&
      //             ticket['type'] == eventTicket.type &&
      //             ticket['group'] == eventTicket.group) {
      //           ticket['eventTicketDate'] = event.startDate;
      //         }
      //       }
      //     }

      //     batch.update(userTicketOrderRef, {'tickets': tickets});
      //     batch.update(newEventsTicketOrderRef, {'tickets': tickets});
      //   }
      //   operationCount += 4; // Two operations for each invite

      //   // Check if user is the author and add user activity
      // if (userId != event.authorId) {
      //   DocumentReference userActivityRef =
      //       activitiesRef.doc(userId).collection('userActivities').doc();
      //   batch.set(userActivityRef, {
      //     'helperFielId': event.authorId,
      //     'authorId': event.authorId,
      //     'postId': event.id,
      //     'seen': false,
      //     'type': 'eventUpdate',
      //     'postImageUrl': event.imageUrl,
      //     'comment':
      //         'Certain information about this event have been modified',
      //     'timestamp': Timestamp.fromDate(DateTime.now()),
      //     'authorProfileImageUrl': '',
      //     'authorName': 'Event informaiton updated',
      //     'authorProfileHandle': event.authorId,
      //     'authorVerification': false
      //   });
      //   operationCount++; // One operation for the user activity
      // }

      //   // Commit batch if limit is reached and start a new batch
      //   if (operationCount >= batchSize) {
      //     await batch.commit();
      //     batch = FirebaseFirestore.instance.batch();
      //     operationCount = 0;
      //   }
      // }

      // Remember the last document processed
      lastDoc = querySnapshot.docs.last;
    } while (lastDoc != null);

    // Commit any remaining operations in the final batch
    if (operationCount > 0) {
      await batch.commit();
    }
  }

  static Future<void> deleteEvent(
      Event event, String reason, bool isCompleted) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    int batchSize = 0;
    // try {
    // Singular operations to delete the event and related data
    DocumentReference eventRef =
        eventsRef.doc(event.authorId).collection('userEvents').doc(event.id);
    batch.delete(eventRef);
    batchSize++;

    if (!event.isPrivate) {
      DocumentReference allEventRef = allEventsRef.doc(event.id);
      batch.delete(allEventRef);
      batchSize++;

      DocumentReference allEventSummaryRef = allEventsSummaryRef.doc(event.id);
      batch.delete(allEventSummaryRef);
      batchSize++;
    }

    DocumentReference chatRoomRef = eventsChatRoomsRef.doc(event.id);
    batch.delete(chatRoomRef);
    batchSize++;

    DocumentReference userTicketIdDocRef = userTicketIdRef
        .doc(event.authorId)
        .collection('tickedIds')
        .doc(event.id);
    batch.delete(userTicketIdDocRef);
    batchSize++;

    DocumentReference deletedEventRef = deletdEventsRef.doc(event.id);
    batch.set(deletedEventRef, event.toJson());
    batchSize++;

    if (!event.isFree && event.ticket.isEmpty) {
      final CollectionReference eventRefundRequests =
          FirebaseFirestore.instance.collection('eventRefundRequests');

      // Get the documents you want to delete.
      final QuerySnapshot eventRefundRequestsSnapshot =
          await eventRefundRequests.get();

      for (var doc in eventRefundRequestsSnapshot.docs) {
        batch
            .delete(doc.reference); // Use the reference to delete the document.
        batchSize++;

        // Commit the batch if it reaches the limit of 500 operations
        if (batchSize >= 500) {
          await batch.commit(); // Commit the batch.
          batch = firestore.batch(); // Start a new batch.
          batchSize = 0; // Reset the batch size counter.
        }
      }
      // Commit any remaining operations in the batch after processing all documents.
      if (batchSize > 0) {
        await batch.commit();
        batchSize = 0; // Reset the batch size after the commit.
      }
    }

    // // Get all event invites and perform batch operations
    QuerySnapshot eventTicketOrderSnapshot = await newEventTicketOrderRef
        .doc(event.id)
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
        .get();

    for (var doc in eventTicketOrderSnapshot.docs) {
      String userId = doc.id;
      String commonId = Uuid().v4();
      Map<String, dynamic> ticketOrderData = doc.data() as Map<String, dynamic>;

      String transactionId = ticketOrderData['transactionId'] ?? '';

      String orderId = ticketOrderData['orderId'] ?? '';

      DocumentReference ticketOderRef = doc.reference;
      batch.delete(ticketOderRef);
      batchSize++;

      // // Update the event invites
      DocumentReference newEventsTicketOrderRef = newUserTicketOrderRef
          .doc(userId)
          .collection('ticketOrders')
          .doc(event.id);
      batch.update(newEventsTicketOrderRef, {
        'isDeleted': true,
        'canlcellationReason': reason,
      });
      batchSize++;

      // Check if the document exists before updating
      DocumentReference newUserInvitesRef =
          userInvitesRef.doc(userId).collection('eventInvite').doc(event.id);
      DocumentSnapshot inviteSnapshot = await newUserInvitesRef.get();

      if (inviteSnapshot.exists) {
        batch.update(newUserInvitesRef, {
          'isDeleted': true,
        });
        batchSize++;
      }

      DocumentReference userTicketIdDocRef =
          userTicketIdRef.doc(userId).collection('tickedIds').doc(event.id);
      batch.delete(
        userTicketIdDocRef,
      );
      batchSize++;

      // Additional operations based on conditions
      if (userId != event.authorId && !event.isFree && !isCompleted) {
        // Assume two operations for refund processing: one delete and one set
        RefundModel refund = RefundModel(
          id: commonId,
          eventId: event.id,
          status: 'pending',
          timestamp: Timestamp.fromDate(DateTime.now()),
          userRequestId: userId,
          approvedTimestamp: Timestamp.fromDate(DateTime.now()),
          reason: reason,
          idempotencyKey: '',
          city: '',
          amount: 0,
          expectedDate: '',
          transactionId: transactionId,
          orderId: orderId,
          eventAuthorId: event.authorId,
          eventTitle: event.title,
        );

        DocumentReference allRefundRequestRef = FirebaseFirestore.instance
            .collection('allRefundRequestsEventDeleted')
            .doc(refund.id);

        DocumentReference userRefundRequestRef = FirebaseFirestore.instance
            .collection('userRefundRequests')
            .doc(userId)
            .collection('refundRequests')
            .doc(event.id);

        Map<String, dynamic> refundData = refund.toJson();

        batch.set(allRefundRequestRef, refundData);
        batch.set(userRefundRequestRef, refundData);
        batchSize += 2;
      }

      if (userId != event.authorId && !isCompleted) {
        // Assume one operation for user activity logging
        DocumentReference userActivityRef =
            activitiesRef.doc(userId).collection('userActivities').doc();
        batch.set(userActivityRef, {
          'helperFielId': event.authorId,
          'authorId': event.authorId,
          'postId': event.id,
          'seen': false,
          'type': 'eventDeleted',
          'postImageUrl': '',
          'comment': event.title,
          'timestamp': Timestamp.fromDate(DateTime.now()),
          'authorProfileImageUrl': '',
          'authorName': 'Event deleted',
          'authorProfileHandle': '',
          'authorVerification': false
        });

        batchSize++;
      }

      // Commit the batch if it reaches the limit of 500 operations
      if (batchSize >= 500) {
        await batch.commit();
        batch = firestore.batch();
        batchSize = 0;
      }
    }
    // Commit any remaining operations
    if (batchSize > 0) {
      await batch.commit();
    }
    if (event.imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(event.imageUrl).delete();
    }
    // } catch (e) {
    //   throw (e);
    //   // Handle batch commit errors
    //   // Consider how to handle the error, e.g., retry mechanism or user notification
    // }
  }

  static Future<int> numUnAnsweredInvites(
    String currentUserId,
  ) async {
    QuerySnapshot feedEventSnapShot = await userInvitesRef
        .doc(currentUserId)
        .collection('eventInvite')
        .where('answer', isEqualTo: "")
        // .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsTypes(
      String eventType, DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('type', isEqualTo: eventType)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAll(DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        // .where('clossingDay', isGreaterThanOrEqualTo: currentDate)

        // .where('type', isEqualTo: eventType)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAllSortNumberOfDays(
      DateTime currentDate, int sortNumberOfDays) async {
    final sortDate = currentDate.add(Duration(days: sortNumberOfDays));
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        .where('clossingDay', isLessThanOrEqualTo: sortDate)
        // .where('clossingDay', isLessThanOrEqualTo: endDate)
        // .where('clossingDay', isLessThanOrEqualTo: endDate)

        // .where('type', isEqualTo: eventType)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsTypesSortNumberOfDays(
      String eventType, DateTime currentDate, int sortNumberOfDays) async {
    final sortDate = currentDate.add(Duration(days: sortNumberOfDays));
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('type', isEqualTo: eventType)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        .where('clossingDay', isLessThanOrEqualTo: sortDate)
        // .where('clossingDay', isLessThanOrEqualTo: endDate)
        // .where('clossingDay', isLessThanOrEqualTo: endDate)
        // .where('showOnExplorePage', isEqualTo: true)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsAllLiveLocation(
      String liveCity, String liveCountry, DateTime currentDate) async {
    QuerySnapshot feedEventSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
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
        .where('showOnExplorePage', isEqualTo: true)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
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
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

  static Future<int> numEventsFollowing(
      DateTime currentDate, String userId, String eventType) async {
    QuerySnapshot feedEventSnapShot = await eventFeedsRef
        .doc(userId)
        .collection('userEventFeed')
        .where('type', isEqualTo: eventType)
        .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        .get();
    return feedEventSnapShot.docs.length - 1;
  }

//tickets

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
        .doc(event.id);

    DocumentReference eventRefundRequestRef = FirebaseFirestore.instance
        .collection('eventRefundRequests')
        .doc(event.id)
        .collection('refundRequests')
        .doc(currentUser.userId);

    batch.set(allRefundRequestRef, refundData);

    batch.set(userRefundRequestRef, refundData);
    batch.set(eventRefundRequestRef, refundData);

    final eventInviteDocRef = newEventTicketOrderRef
        .doc(event.id)
        .collection('ticketOrders')
        .doc(currentUser.userId);

    final userInviteDocRef = newUserTicketOrderRef
        .doc(currentUser.userId)
        .collection('ticketOrders')
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
      'authorProfileHandle': event.authorId,
      'authorVerification': false
    });

    // Commit the batch
    await batch.commit();
  }

  static deleteRefundRequestData(RefundModel refund) {
    // Add the complaint request to the appropriate collection

    FirebaseFirestore.instance
        .collection('userRefundRequests')
        .doc(refund.userRequestId)
        .collection('refundRequests')
        .doc(refund.eventId)
        .delete();
  }

  static deleteUserTagData(
    TaggedNotificationModel tag,
  ) {
    // Add the complaint request to the appropriate collection

    userTagRef.doc(tag.personId).collection('tags').doc(tag.id).delete();
  }

  static Future<void> confirmUserTag(
    TaggedNotificationModel tag,
    authorProfileHandle,
    authorVerification,
    authorUserName,
    authorProfileImage,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update the user's tag verification status
    DocumentReference userTagDocRef =
        userTagRef.doc(tag.personId).collection('tags').doc(tag.id);

    batch.update(userTagDocRef, {'verifiedTag': true});

    // // Update the event's tag verification status
    await editEventTags(tag, batch);

    // This should also be included in the batch operation
    DocumentReference userActivityRef = await activitiesRef
        .doc(tag.taggedParentAuthorId)
        .collection('userActivities')
        .doc(); // Create a new document with a generated ID
    batch.set(userActivityRef, {
      'helperFielId': tag.taggedParentAuthorId,
      'authorId': tag.personId,
      'postId': tag.taggedParentId,
      'seen': false,
      'type': 'tagConfirmed',
      'postImageUrl': tag.taggedParentImageUrl,
      'comment': tag.role == 'Schedule'
          ? 'Tag confirmed by ${authorUserName} as a ${tag.role} person in ${tag.taggedParentTitle}'
          : 'Tag confirmed by ${authorUserName} as ${tag.role} in ${tag.taggedParentTitle}',
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'authorProfileImageUrl': authorProfileImage,
      'authorName': 'Tag confirmed',
      'authorProfileHandle': authorProfileHandle,
      'authorVerification': authorVerification,
    });

    // Commit the batch
    await batch.commit();
  }

  static Future<void> editEventTags(
      TaggedNotificationModel tag, WriteBatch batch) async {
    Event? event = await getUserEventWithId(
        tag.taggedParentId!, tag.taggedParentAuthorId!);

    if (event != null) {
      List<TaggedEventPeopleModel> taggedPeople = event.taggedPeople;
      List<Schedule> schedules = event.schedule;

      if (tag.role == 'Schedule') {
        for (var schedule in schedules) {
          for (int i = 0; i < schedule.people.length; i++) {
            var person = schedule.people[i];

            if (person.id == tag.id &&
                person.internalProfileLink == tag.personId) {
              // Update the verifiedTag status
              schedule.people[i] = SchedulePeopleModel(
                id: person.id,
                name: person.name,
                verifiedTag: true, // Update verification status
                internalProfileLink: person.internalProfileLink,
                externalProfileLink: person.externalProfileLink,
                profileImageUrl: person.profileImageUrl,
              );

              // Update the schedule in the database
              DocumentReference eventDocRef = eventsRef
                  .doc(event.authorId)
                  .collection('userEvents')
                  .doc(event.id);

              // Update in 'allEventsRef'
              if (!event.isPrivate) {
                DocumentReference allEventRef = allEventsRef.doc(event.id);
                batch.update(allEventRef, {
                  'schedule': schedules
                      .map((s) => s.toJson())
                      .toList(), // Ensure Schedule has a toJson method
                });
              }

              batch.update(eventDocRef, {
                'schedule': schedules
                    .map((s) => s.toJson())
                    .toList(), // Ensure Schedule has a toJson method
              });

              break; // Exit inner loop once the person is updated
            }
          }
        }
      } else {
        // Find the tag to update
        for (int i = 0; i < taggedPeople.length; i++) {
          var taggedPerson = taggedPeople[i];

          if (taggedPerson.id == tag.id &&
              taggedPerson.internalProfileLink == tag.personId) {
            // Update the verifiedTag status
            taggedPeople[i] = TaggedEventPeopleModel(
              id: taggedPerson.id,
              name: taggedPerson.name,
              role: taggedPerson.role,
              taggedType: taggedPerson.taggedType,
              verifiedTag: true, // Update verification status
              internalProfileLink: taggedPerson.internalProfileLink,
              externalProfileLink: taggedPerson.externalProfileLink,
              profileImageUrl: taggedPerson.profileImageUrl,
            );
            // print("\n\n\ntag    data  " + taggedPeople[i].toString());

            // Update the event in the database
            DocumentReference eventDocRef = eventsRef
                .doc(event.authorId)
                .collection('userEvents')
                .doc(event.id);

            // Update the event in 'allEventsRef'
            if (!event.isPrivate) {
              DocumentReference allEventRef = allEventsRef.doc(event.id);
              batch.update(allEventRef, {
                'taggedPeople': taggedPeople
                    .map((e) => e.toJson())
                    .toList(), // Ensure TaggedEventPeopleModel has a toJson method
              });
            }

            batch.update(eventDocRef, {
              'taggedPeople': taggedPeople
                  .map((e) => e.toJson())
                  .toList(), // Ensure TaggedEventPeopleModel has a toJson method
            });

            break; // Exit loop once the tag is updated
          }
        }
      }
    }
  }

  static deleteAffiliateUsertData(AffiliateModel affiliate) {
    // Add the complaint request to the appropriate collection

    userAffiliateRef
        .doc(affiliate.userId)
        .collection('affiliateMarketers')
        .doc(affiliate.eventId)
        .delete();
  }

  static deleteAffiliatetEventData(AffiliateModel affiliate) {
    // Add the complaint request to the appropriate collection

    eventAffiliateRef
        .doc(affiliate.eventId)
        .collection('affiliateMarketers')
        .doc(affiliate.userId)
        .delete();
  }

  // static deleteCrativeBookingData(BookingModel booking) {
  //   // Add the complaint request to the appropriate collection
  //   newBookingsReceivedRef
  //       .doc(booking.creativeId)
  //       .collection('bookings')
  //       .doc(booking.id)
  //       .delete();
  // }

  // static deleteClientBookingData(BookingModel booking) {
  //   // Add the complaint request to the appropriate collection
  //   newBookingsSentRef
  //       .doc(booking.clientId)
  //       .collection('bookings')
  //       .doc(booking.id)
  //       .delete();
  // }

  static Future<bool> isAffiliatePayoutAvailable({
    required String userId,
    required String eventId,
  }) async {
    try {
      DocumentReference payoutRequestDocRef = FirebaseFirestore.instance
          .collection('userAffiliatePayoutRequests')
          .doc(userId)
          .collection('payoutRequests')
          .doc(eventId);

      DocumentSnapshot payoutRequestDoc = await payoutRequestDocRef.get();

      return payoutRequestDoc.exists;
    } catch (e) {
      // Handle any errors that may occur during the operation
      print('Error checking payout availability: $e');
      return false;
    }
  }

  static Future<void> requestAffiliatePayout(
    AffiliatePayoutModel payout,
  ) async {
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> payoutData = payout.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the refund request to 'allRefundRequests' collection
    DocumentReference allPayoutRequestRef = FirebaseFirestore.instance
        .collection('allFundsAffiliatePayoutRequest')
        .doc(payout.id);

    DocumentReference userPayoutRequestRef = FirebaseFirestore.instance
        .collection('userAffiliatePayoutRequests')
        .doc(payout.affiliateId)
        .collection('payoutRequests')
        .doc(payout.eventId);

    batch.set(allPayoutRequestRef, payoutData);
    batch.set(userPayoutRequestRef, payoutData);

    await batch.commit();
  }

  static Future<bool> isPayoutAvailable({
    required String userId,
    required String eventId,
  }) async {
    try {
      DocumentReference payoutRequestDocRef = FirebaseFirestore.instance
          .collection('userPayoutRequests')
          .doc(userId)
          .collection('payoutRequests')
          .doc(eventId);

      DocumentSnapshot payoutRequestDoc = await payoutRequestDocRef.get();

      return payoutRequestDoc.exists;
    } catch (e) {
      // Handle any errors that may occur during the operation
      print('Error checking payout availability: $e');
      return false;
    }
  }

  static Future<void> requestPayout(Event event, EventPayoutModel payout,
      AccountHolderAuthor currentUser) async {
    // Create a toJson method inside Event class to serialize the object into a map
    Map<String, dynamic> payoutData = payout.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the refund request to 'allRefundRequests' collection
    DocumentReference allPayoutRequestRef = FirebaseFirestore.instance
        .collection('allFundsPayoutRequest')
        .doc(payout.id);

    DocumentReference userPayoutRequestRef = FirebaseFirestore.instance
        .collection('userPayoutRequests')
        .doc(currentUser.userId)
        .collection('payoutRequests')
        .doc(event.id);

    batch.set(allPayoutRequestRef, payoutData);
    batch.set(userPayoutRequestRef, payoutData);

    await batch.commit();
  }

  static deletePayoutData(EventPayoutModel payout, String currentUserId) {
    // Add the complaint request to the appropriate collection

    FirebaseFirestore.instance
        .collection('userPayoutRequests')
        .doc(currentUserId)
        .collection('payoutRequests')
        .doc(payout.eventId)
        .delete();
  }

  static deleteDonarData(String donationId, String currentUserId) {
    // Add the complaint request to the appropriate collection

    newUserDonationsRef
        .doc(currentUserId)
        .collection('donations')
        .doc(donationId)
        .delete();
  }

  static deleteDonarReceiverData(String donationId, String currentUserId) {
    // Add the complaint request to the appropriate collection

    newDonationToCreativesRef
        .doc(currentUserId)
        .collection('donations')
        .doc(donationId)
        .delete();
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

  static Future<RefundModel?> getRefundWithId(
    String userId,
    String eventId,
  ) async {
    try {
      DocumentSnapshot userDocSnapshot = await userRefundRequestsRef
          .doc(userId)
          .collection('refundRequests')
          .doc(eventId)
          .get();

      if (userDocSnapshot.exists) {
        return RefundModel.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

  static Future<EventPayoutModel?> getUserPayoutWithId(
    String userId,
    String eventId,
  ) async {
    try {
      DocumentSnapshot userDocSnapshot = await userPayoutRequestRef
          .doc(userId)
          .collection('payoutRequests')
          .doc(eventId)
          .get();

      if (userDocSnapshot.exists) {
        return EventPayoutModel.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

  //Database utility
  static createSuggestion(Suggestion suggestion) {
    suggestionsRef.add({
      'suggesttion': suggestion.suggesttion,
      'authorId': suggestion.authorId,
      'timestamp': suggestion.timestamp,
    });
  }

  static createSurvey(Survey survey) {
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

  static createReportContent(ReportContents reportContents) {
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

  static Future<ComplaintIssueModel?> getComplaintWithId(
    String userId,
    String complaintId,
  ) async {
    try {
      DocumentSnapshot userDocSnapshot = await userIssueComplaintRef
          .doc(userId)
          .collection('issueComplaint')
          .doc(complaintId)
          .get();

      if (userDocSnapshot.exists) {
        return ComplaintIssueModel.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

  static createComplainIssue(ComplaintIssueModel complaint) {
    Map<String, dynamic> complaintData = complaint.toJson();

    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DateTime now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    String monthName = DateFormat('MMMM').format(currentDate);

    // Add the complaint request to the appropriate collection
    DocumentReference allComplaintRequestRef = FirebaseFirestore.instance
        .collection('allComplaintRequests')
        .doc(currentDate.year.toString())
        .collection(monthName)
        .doc(getWeekOfMonth(currentDate).toString())
        .collection(complaint.complainType)
        .doc(complaint.complainContentId);

    DocumentReference userIssueComplaint = FirebaseFirestore.instance
        .collection('userIssueComplaint')
        .doc(complaint.authorId)
        .collection('issueComplaint')
        .doc(complaint.complainContentId);

    batch.set(allComplaintRequestRef, complaintData);
    batch.set(userIssueComplaint, complaintData);

    // Commit the batch
    batch.commit();
  }

  static deleteComplainIssue(ComplaintIssueModel complaint) {
    // Prepare the batch
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DateTime now = complaint.timestamp.toDate();
    final currentDate = DateTime(now.year, now.month, now.day);
    String monthName = DateFormat('MMMM').format(currentDate);

    // Add the complaint request to the appropriate collection
    DocumentReference allComplaintRequestRef = FirebaseFirestore.instance
        .collection('allComplaintRequests')
        .doc(currentDate.year.toString())
        .collection(monthName)
        .doc(getWeekOfMonth(currentDate).toString())
        .collection(complaint.complainType)
        .doc(complaint.complainContentId);

    DocumentReference userIssueComplaint = FirebaseFirestore.instance
        .collection('userIssueComplaint')
        .doc(complaint.authorId)
        .collection('issueComplaint')
        .doc(complaint.complainContentId);

    batch.delete(allComplaintRequestRef);
    batch.delete(userIssueComplaint);

    // Commit the batch
    batch.commit();
  }

  static int getWeekOfMonth(DateTime dateTime) {
    int daysInWeek = 7;
    int daysPassed = dateTime.day + dateTime.weekday - 1;
    return ((daysPassed - 1) / daysInWeek).ceil();
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
        print('User data: ${userDocSnapshot.data()}');
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
        print('dfdfdfdfd');
        return UserSettingsLoadingPreferenceModel.fromDoc(userDocSnapshot);
      } else {
        print('00000');
        return null;
      }
    } catch (e) {
      print(e.toString());
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
      toUserId: '',
    );
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

  static Future<BrandMatchingModel?> getUserBrandInfoWithId(
      String userId) async {
    // try {
    DocumentSnapshot userDocSnapshot =
        await newBrandMatchingRef.doc(userId).get();
    // new_userBrandIfoRef.doc(userId).get();
    if (userDocSnapshot.exists) {
      return BrandMatchingModel.fromDoc(userDocSnapshot);
    } else {
      return null;
    }
    // } catch (e) {
    //   return null;
    // }
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
          .collection('ticketOrders')
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

  static Future<TicketOrderModel?> getUserTicketOrderWithId(
      String eventId, String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await newUserTicketOrderRef
          .doc(userId)
          .collection('ticketOrders')
          .doc(eventId)
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

  static Future<Event?> getUserEventWithId(
      String eventId, String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await eventsRef
          .doc(userId)
          .collection('userEvents')
          .doc(eventId)
          .get();

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
    DocumentSnapshot userDocSnapshot = await newUserTicketOrderRef
        .doc(currentUserId)
        .collection('ticketOrders')
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
          .collection('tickedIds')
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
      DocumentSnapshot userDocSnapshot = await userInvitesRef
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
        .collection('ticketOrders')
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

  static Stream<int> numAffiliates(String eventId, String marketingType) {
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }
    return eventAffiliateRef
        .doc(eventId)
        .collection('affiliateMarketers')
        .where('marketingType', isEqualTo: marketingType)
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

  static Stream<int> numUerAffiliates(
    String userId,
  ) {
    final now = DateTime.now();

    final currentDate = DateTime(now.year, now.month, now.day);
    final endDate = currentDate.add(Duration(days: 2));

    if (userId.isEmpty || userId.trim() == '') {
      print("Error: userIdId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }
    return userAffiliateRef
        .doc(userId)
        .collection('affiliateMarketers')
        .where('answer', isEqualTo: '')
        .where('eventClossingDay', isGreaterThanOrEqualTo: endDate)
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

  static Stream<int> numAllAnsweredEventInvites(String eventId, String answer) {
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
        .where('refundRequestStatus', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
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
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numExpectedAttendees(String eventId, bool validated) {
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }

    // Create a stream of snapshots for the entire eventInvite collection
    Stream<QuerySnapshot> stream = newEventTicketOrderRef
        .doc(eventId)
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) {
      int count = 0;

      // Iterate over each document in the eventInvite collection
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> tickets = data['tickets'] ?? [];

        // Count the number of tickets that match the validated status
        for (var ticket in tickets) {
          if ((ticket['validated'] ?? false) == validated) {
            count++;
          }
        }
      }

      return count;
    });
  }

  static Stream<int> numExpectedPeople(
    String eventId,
  ) {
    if (eventId.isEmpty || eventId.trim() == '') {
      print("Error: eventId is null or empty.");
      // Return an empty stream or handle the error as appropriate for your app
      return Stream.empty();
    }
    return newEventTicketOrderRef
        .doc(eventId)
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
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
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
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
    QuerySnapshot feedSnapShot = await newUserTicketOrderRef
        .doc(userId)
        .collection('ticketOrders')
        .get();
    return feedSnapShot.docs.length;
  }

  static Future<bool> isTicketOrderAvailable({
    required Transaction transaction,
    required String userOrderId,
    required String eventId,
  }) async {
    DocumentReference ticketOrderDocRef = newUserTicketOrderRef
        .doc(userOrderId)
        .collection('ticketOrders')
        .doc(eventId);

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
        .collection('ticketOrders')
        .doc(userOrderId)
        .update({
      'tickets': FieldValue.arrayUnion(
          tickets.map((ticket) => ticket.toJson()).toList())
    });

    newUserTicketOrderRef
        .doc(userOrderId)
        .collection('ticketOrders')
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
        .collection('ticketOrders')
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

    DocumentReference userInviteRef = userInvitesRef
        .doc(currentUser.userId)
        .collection('eventInvite')
        .doc(event.id);
    batch.update(userInviteRef, {
      'answer': answer,
    });
  }

  static Future<void> createReview({
    required ReviewModel rating,
    required AccountHolderAuthor currentUser,
  }) async {
    // Initialize a WriteBatch
    Map<String, dynamic> bookingData = rating.toJson();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // References to the affiliate documents
    final bookingReceivedDocRef = newReviewReceivedRef
        .doc(rating.reviewingId)
        .collection('reviews')
        .doc(rating.bookingId);
// f2427095-a9ec-40b2-8fc3-82bcec946740
    final bookingsSentDocRef = newReviewMadeRef
        .doc(rating.revierwerId)
        .collection('reviews')
        .doc(rating.bookingId);

    // Set the affiliate data in the batch
    batch.set(bookingReceivedDocRef, bookingData);
    batch.set(bookingsSentDocRef, bookingData);

    DocumentReference activityDocRef = activitiesRef
        .doc(rating.reviewingId)
        .collection('userActivities')
        .doc();

    // Create a new document reference for the activity within the userActivities collection
    // batch.update(usersRatingDocRef, ratingData);
    await updateUserRating(
      rating: rating.rating,
      reviewingId: rating.revierwerId,
      batch: batch,
    );

    // Add the activity creation to the batch
    batch.set(activityDocRef, {
      'helperFielId': rating.revierwerId,
      'authorId': currentUser.userId,
      'postId': rating.bookingId,
      'seen': false,
      'type': 'review',
      'postImageUrl': '',
      'comment': 'New review ',
      'timestamp':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'authorProfileImageUrl': currentUser
          .profileImageUrl, // Assuming there's a profileImageUrl field
      'authorName': currentUser.userName,
      'authorProfileHandle': '',
      'authorVerification': currentUser.verified,
    });

    // Commit the batch write
    await batch.commit();
  }

  static Future<void> updateUserRating(
      {required String reviewingId,
      required int rating,
      required WriteBatch batch}) async {
    DocumentReference usersRatingDocRef = usersRatingRef.doc(reviewingId);

    Map<String, dynamic> updateData;

    // Determine which star field to increment based on the rating
    switch (rating) {
      case 1:
        updateData = {'oneStar': FieldValue.increment(1)};
        break;
      case 2:
        updateData = {'twoStar': FieldValue.increment(1)};
        break;
      case 3:
        updateData = {'threeStar': FieldValue.increment(1)};
        break;
      case 4:
        updateData = {'fourStar': FieldValue.increment(1)};
        break;
      case 5:
        updateData = {'fiveStar': FieldValue.increment(1)};
        break;
      default:
        throw ArgumentError('Invalid rating value: $rating');
    }

    batch.update(usersRatingDocRef, updateData);
  }

  // static Future<BookingModel?> getBookingMade(
  //     String userId, String bookId) async {
  //   try {
  //     DocumentSnapshot userDocSnapshot = await newBookingsSentRef
  //         .doc(userId)
  //         .collection('bookings')
  //         .doc(bookId)
  //         .get();

  //     if (userDocSnapshot.exists) {
  //       return BookingModel.fromDoc(userDocSnapshot);
  //     } else {
  //       return null; // return null if document does not exist
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null; // return null if an error occurs
  //   }
  // }

  // static Future<BookingModel?> getUserBooking(
  //     String userId, String bookId) async {
  //   try {
  //     DocumentSnapshot userDocSnapshot = await newBookingsReceivedRef
  //         .doc(userId)
  //         .collection('bookings')
  //         .doc(bookId)
  //         .get();

  //     if (userDocSnapshot.exists) {
  //       return BookingModel.fromDoc(userDocSnapshot);
  //     } else {
  //       return null; // return null if document does not exist
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null; // return null if an error occurs
  //   }
  // }

  static createBrandInfo(
    BrandMatchingModel brandMatching,
  ) async {
    Map<String, dynamic> brandData = brandMatching.toJson();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    // References to the affiliate documents
    // final new_userBrandIfoDocRef = new_userBrandIfoRef.doc(brand.userId);
    final newBrandMatchingDocRef =
        newBrandMatchingRef.doc(brandMatching.userId);

    final brandMatchingDocRef = newBrandMatchingDocRef;

    // final brandDocRef = new_userBrandIfoDocRef;

    // batch.set(brandDocRef, brandData);
    batch.set(brandMatchingDocRef, brandData);
    await batch.commit();
  }

//   static Future<void> createBookingRequest({
//     required BookingModel booking,
//     required AccountHolderAuthor currentUser,
//   }) async {
//     // Initialize a WriteBatch
//     Map<String, dynamic> bookingData = booking.toJson();

//     WriteBatch batch = FirebaseFirestore.instance.batch();

//     // References to the affiliate documents
//     final bookingReceivedDocRef = newBookingsReceivedRef
//         .doc(booking.creativeId)
//         .collection('bookings')
//         .doc(booking.id);
// // f2427095-a9ec-40b2-8fc3-82bcec946740
//     final bookingsSentDocRef = newBookingsSentRef
//         .doc(booking.clientId)
//         .collection('bookings')
//         .doc(booking.id);

//     // Set the affiliate data in the batch
//     batch.set(bookingReceivedDocRef, bookingData);
//     batch.set(bookingsSentDocRef, bookingData);

//     // Create a new document reference for the activity within the userActivities collection
//     DocumentReference activityDocRef = activitiesRef
//         .doc(booking.creativeId)
//         .collection('userActivities')
//         .doc(); // Create a new document reference with a generated ID

//     // Add the activity creation to the batch
//     batch.set(activityDocRef, {
//       'helperFielId': booking.clientId,
//       'authorId': currentUser.userId,
//       'postId': booking.id,
//       'seen': false,
//       'type': 'bookingReceived',
//       'postImageUrl': '',
//       'comment': 'Congratulation\nNew booking deal',
//       'timestamp':
//           FieldValue.serverTimestamp(), // Use server timestamp for consistency
//       'authorProfileImageUrl': currentUser
//           .profileImageUrl, // Assuming there's a profileImageUrl field
//       'authorName': currentUser.userName,
//       'authorProfileHandle': '',
//       'authorVerification': currentUser.verified,
//     });

//     // Commit the batch write
//     await batch.commit();
//   }

//   static answerBookingInviteBatch({
//     // required WriteBatch batch,
//     required String answer,
//     required bool isAnswer,
//     required AccountHolderAuthor currentUser,
//     required BookingModel booking,
//   }) async {
//     WriteBatch batch = FirebaseFirestore.instance.batch();
//     DocumentReference newBookingsReceivedDocRef = newBookingsReceivedRef
//         .doc(booking.creativeId)
//         .collection('bookings')
//         .doc(booking.id);
//     isAnswer
//         ? batch.update(newBookingsReceivedDocRef, {
//             'answer': answer,
//           })
//         : batch.update(newBookingsReceivedDocRef, {
//             'isdownPaymentMade': true,
//           });

//     DocumentReference newBookingsSentDocRef = newBookingsSentRef
//         .doc(booking.clientId)
//         .collection('bookings')
//         .doc(booking.id);
//     isAnswer
//         ? batch.update(newBookingsSentDocRef, {
//             'answer': answer,
//           })
//         : batch.update(newBookingsSentDocRef, {
//             'isdownPaymentMade': true,
//           });
//     if (answer == 'Rejected') return;
// // Create a new document reference for the activity within the userActivities collection
//     DocumentReference activityDocRef = isAnswer
//         ? activitiesRef.doc(booking.clientId).collection('userActivities').doc()
//         : activitiesRef
//             .doc(booking.creativeId)
//             .collection('userActivities')
//             .doc(); // Create a new document reference with a generated ID

//     // Add the activity creation to the batch
//     batch.set(activityDocRef, {
//       'helperFielId': currentUser.userId,
//       'authorId': currentUser.userId,
//       'postId': booking.id,
//       'seen': false,
//       'type': isAnswer ? 'bookingMade' : 'bookingReceived',
//       'postImageUrl': '',
//       'comment': isAnswer
//           ? 'Congratulation\nBooking deal accepted'
//           : '30% downpayment made',
//       'timestamp':
//           FieldValue.serverTimestamp(), // Use server timestamp for consistency
//       'authorProfileImageUrl': currentUser
//           .profileImageUrl, // Assuming there's a profileImageUrl field
//       'authorName': currentUser.userName,
//       'authorProfileHandle': '',
//       'authorVerification': currentUser.verified,
//     });

//     await batch.commit();
//   }

  static Future<void> createAffiliate({
    required Event event,
    required List<AccountHolderAuthor> users,
    required String inviteMessage,
    required String termsAndCondition,
    required double commission,
    required String authorProfileImageUrl,
  }) async {
    // Initialize a WriteBatch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Iterate through each user to create their affiliate entries
    for (var user in users) {
      String commonId = Uuid().v4();
      // Create an AffiliateModel for the user
      AffiliateModel affiliate = AffiliateModel(
        id: commonId,
        eventId: event.id,
        userId: user.userId!,
        affiliateLink: '', // This should be generated and set separately
        userName: user.userName!,
        commissionRate: commission,
        affiliatePayoutDate: Timestamp.fromDate(DateTime.now()),
        payoutToAffiliates: false,
        timestamp: Timestamp.fromDate(DateTime.now()),
        affiliateAmount: 0,
        userProfileUrl: user.profileImageUrl!,
        salesNumber: 0,
        payoutToOrganizer: false,
        marketingType: 'Invited',
        eventImageUrl: event.imageUrl,
        eventAuthorId: event.authorId,
        eventClossingDay: event.clossingDay,
        eventTitle: event.title,
        answer: '',
        message: inviteMessage,
        termsAndCondition: termsAndCondition,
      );

      // Convert the affiliate model to a map
      Map<String, dynamic> affiliateData = affiliate.toJson();
      // References to the affiliate documents
      final affiliateDocRef = eventAffiliateRef
          .doc(event.id)
          .collection('affiliateMarketers')
          .doc(user.userId);
      final userAffiliateDocRef = userAffiliateRef
          .doc(user.userId)
          .collection('affiliateMarketers')
          .doc(event.id);

      // Set the affiliate data in the batch
      batch.set(affiliateDocRef, affiliateData);
      batch.set(userAffiliateDocRef, affiliateData);

      // Create a new document reference for the activity within the userActivities collection
      DocumentReference activityDocRef = activitiesRef
          .doc(user.userId)
          .collection('userActivities')
          .doc(); // Create a new document reference with a generated ID

      // Add the activity creation to the batch
      batch.set(activityDocRef, {
        'helperFielId': event.authorId,
        'authorId': event.authorId,
        'postId': event.id,
        'seen': false,
        'type': 'affiliate',
        'postImageUrl': event.imageUrl,
        'comment': 'Congratulation\nNew affiliate deal',
        'timestamp': FieldValue
            .serverTimestamp(), // Use server timestamp for consistency
        'authorProfileImageUrl':
            authorProfileImageUrl, // Assuming there's a profileImageUrl field
        'authorName': event.authorName,
        'authorProfileHandle': '',
        'authorVerification': false,
      });
    }
    // Commit the batch write
    await batch.commit();
  }

  static addAffiliatetPurchasedUserBatch({
    required Transaction transaction,
    required String eventId,
    required String affiliateId,
    required String userId,
  }) async {
    DocumentReference userInviteRef = userAffiliateBuyersRef
        .doc(affiliateId)
        .collection('buyers')
        .doc(eventId);
    transaction.set(userInviteRef, {
      'userId': userId,
    });
  }

  static updateAffiliatetPurchaseeBatch({
    required Transaction transaction,
    required String eventId,
    required String affiliateId,
    required String eventAuthorId,
    required String eventImageUrl,
    required String eventTitle,
    required double commissionAmount,
    required AccountHolderAuthor user,
  }) async {
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference newEventTicketOrderRef = eventAffiliateRef
        .doc(eventId)
        .collection('affiliateMarketers')
        .doc(affiliateId);
    transaction.update(newEventTicketOrderRef, {
      'salesNumber': FieldValue.increment(1),
      'affiliateAmount': FieldValue.increment(commissionAmount),
      // FieldValue.increment(commissionAmount),
    });

    DocumentReference userInviteRef = userAffiliateRef
        .doc(affiliateId)
        .collection('affiliateMarketers')
        .doc(eventId);
    transaction.update(userInviteRef, {
      'salesNumber': FieldValue.increment(1),
      'affiliateAmount': FieldValue.increment(commissionAmount),
      //  FieldValue.increment(commissionAmount),
    });

    // Now add the activity within the transaction
    DocumentReference activityDocRef =
        activitiesRef.doc(affiliateId).collection('userActivities').doc();

    transaction.set(activityDocRef, {
      'helperFielId': eventAuthorId,
      'authorId': user.userId,
      'postId': eventId,
      'seen': false,
      'type': 'ticketPurchased',
      'postImageUrl': eventImageUrl,
      'comment':
          'Used your affiliate link to purchase a ticket for: \n${eventTitle}',
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
      'authorProfileImageUrl': user.profileImageUrl,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
    });
  }

  static updateAffiliatetEventOrganiserPayoutStatus({
    required String eventId,
    required String affiliateId,
    required String eventAuthorId,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference newEventAffiliateRef = eventAffiliateRef
        .doc(eventId)
        .collection('affiliateMarketers')
        .doc(eventAuthorId);
    batch.update(newEventAffiliateRef, {
      'payoutToOrganizer': true,
    });

    DocumentReference usersAffiliateRef = userAffiliateRef
        .doc(affiliateId)
        .collection('affiliateMarketers')
        .doc(eventId);
    batch.update(usersAffiliateRef, {
      'payoutToOrganizer': true,
    });
    await batch.commit();
  }

  static answeAffiliatetInviteBatch({
    required WriteBatch batch,
    required String eventId,
    required String affiliateInviteeId,
    required String answer,
    required AccountHolderAuthor currentUser,
    required String affiliateLink,
  }) async {
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference newEventTicketOrderRef = eventAffiliateRef
        .doc(eventId)
        .collection('affiliateMarketers')
        .doc(currentUser.userId);
    batch.update(newEventTicketOrderRef, {
      'answer': answer,
      'affiliateLink': affiliateLink,
    });

    DocumentReference userInviteRef = userAffiliateRef
        .doc(currentUser.userId)
        .collection('affiliateMarketers')
        .doc(eventId);
    batch.update(userInviteRef, {
      'answer': answer,
      'affiliateLink': affiliateLink,
    });

    // Create a new document reference for the activity within the userActivities collection
    DocumentReference activityDocRef = activitiesRef
        .doc(affiliateInviteeId)
        .collection('userActivities')
        .doc(); // Create a new document reference with a generated ID

    // Add the activity creation to the batch
    batch.set(activityDocRef, {
      'helperFielId': affiliateInviteeId,
      'authorId': currentUser.userId,
      'postId': eventId,
      'seen': false,
      'type': 'booking',
      'postImageUrl': '',
      'comment': 'Congratulation\nBooking deal accepted',
      'timestamp':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'authorProfileImageUrl': currentUser
          .profileImageUrl, // Assuming there's a profileImageUrl field
      'authorName': currentUser.userName,
      'authorProfileHandle': '',
      'authorVerification': currentUser.verified,
    });
  }

  static Future<AffiliateModel?> getUserAffiliate(
      String userId, String eventId) async {
    try {
      DocumentSnapshot userDocSnapshot = await userAffiliateRef
          .doc(userId)
          .collection('affiliateMarketers')
          .doc(eventId)
          .get();

      if (userDocSnapshot.exists) {
        return AffiliateModel.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

  static Future<TaggedNotificationModel?> getUserTag(
      String userId, String tagId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await userTagRef.doc(userId).collection('tags').doc(tagId).get();

      if (userDocSnapshot.exists) {
        return TaggedNotificationModel.fromDoc(userDocSnapshot);
      } else {
        return null; // return null if document does not exist
      }
    } catch (e) {
      print(e);
      return null; // return null if an error occurs
    }
  }

// The DatabaseService.purchaseTicket method is responsible for storing the details
// of the purchased ticket in the Firestore database. This method creates two new documents,
//  one under the 'eventInvite' collection of the specific eventId and another under
//  the 'eventInvite' collection of the specific userOrderId. Both documents contain
//  the same data, which includes details about the ticket order.

  static updateFrienshipGoal({
    // required WriteBatch batch,
    // required Event event,
    required String goal,
    required String eventId,
    required String userId,
    // required AccountHolderAuthor currentUser,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference eventTicketOrder = await newEventTicketOrderRef
        .doc(eventId)
        .collection('ticketOrders')
        .doc(userId);
    batch.update(eventTicketOrder, {
      'networkingGoal': goal,
    });

    DocumentReference userTicketOrderRef = await newUserTicketOrderRef
        .doc(userId)
        .collection('ticketOrders')
        .doc(eventId);
    batch.update(userTicketOrderRef, {
      'networkingGoal': goal,
    });
    return batch.commit();
  }

  static void purchaseTicketBatch({
    required WriteBatch batch,
    required TicketOrderModel ticketOrder,
    required AccountHolderAuthor user,
    required String eventAuthorId,
    required String purchaseReferenceId,
  }) async {
    final eventInviteDocRef = newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('ticketOrders')
        .doc(ticketOrder.userOrderId);

    final userInviteDocRef = newUserTicketOrderRef
        .doc(ticketOrder.userOrderId)
        .collection('ticketOrders')
        .doc(ticketOrder.eventId);

    Map<String, dynamic> ticketOrderData = ticketOrder.toJson();

    batch.set(eventInviteDocRef, ticketOrderData);
    batch.set(userInviteDocRef, ticketOrderData);

    // Add addUserTicketIdRef to the batch
    final userTicketIdDocRef = userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('tickedIds')
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
      'helperFielId': eventAuthorId,
      'authorId': user.userId,
      'postId': ticketOrder.eventId,
      'seen': false,
      'type': 'ticketPurchased',
      'postImageUrl': ticketOrder.eventImageUrl,
      'comment': 'Generated a ticket for: \n${ticketOrder.eventTitle}',
      'timestamp':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'authorProfileImageUrl':
          user.profileImageUrl, // Assuming there's a profileImageUrl field
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
    });
  }

  static Future<void> saveProcessingFee({
    required String ticketOrderId,
    required double processingFee,
  }) async {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    DocumentReference ticketDocRef =
        processingFeesRef.doc(year).collection(month).doc(ticketOrderId);
    DocumentSnapshot ticketDocSnapshot = await ticketDocRef.get();
    if (!ticketDocSnapshot.exists) {
      await ticketDocRef.set({
        'processingFee': processingFee,
        'timestamp': now,
      });
    } else {
      // print('TicketOrderId $ticketOrderId already exists.');
    }
  }

  // Future<double> calculateMonthlyProcessingFees(
  //     String year, String month) async {
  //   CollectionReference monthRef =
  //       processingFeesRef.doc(year).collection(month);

  //   QuerySnapshot snapshot = await monthRef.get();

  //   double totalProcessingFees = snapshot.docs.fold(0.0, (sum, doc) {
  //     double fee = doc['processingFee'] ?? 0.0;
  //     return sum + fee;
  //   });

  //   return totalProcessingFees;
  // }

  static Future<void> addOrganizerToAttendeeMarketing({
    required String userId,
    required String eventAuthorId,
  }) async {
    // Check if the document already exists
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await organiserAttendeeListRef
            .doc(eventAuthorId)
            .collection('OragnizerAttendees')
            .doc(userId)
            .get();

    if (!snapshot.exists) {
      // Add user to current user's following collection
      await organiserAttendeeListRef
          .doc(eventAuthorId)
          .collection('OragnizerAttendees')
          .doc(userId)
          .set({
        'userId': userId,
      });
    } else {
      // The document already exists, handle the case as needed
      // For example, you can log a message or throw an exception
    }
  }

  static Future<void> addEventAttendeeBrandMatching({
    required String userId,
    required String eventId,
    required BrandMatchingModel? brand,
  }) async {
    // Check if the document already exists
    if (brand == null) return;
    Map<String, dynamic> brandData = brand.toJson();
    await newEventBrandMatchingRef
        .doc(eventId)
        .collection('brandMatching')
        .doc(userId)
        .set(brandData);
  }

// The purchaseTicketTransaction function is responsible for handling the entire ticket purchase process,
//including updating the affiliate sales and total affiliate amount.
  static Future<void> purchaseTicketTransaction({
    required Transaction transaction,
    required TicketOrderModel ticketOrder,
    required AccountHolderAuthor user,
    required String purchaseReferenceId,
    required String eventAuthorId,
    required bool isEventFree,
    required bool isEventPrivate,
    required List<String> purchasedTicketIds,
    required bool dontUpdateTicketSales,
    required String inviteReply,
    required String marketAffiliateId,
    required bool isEventAffiliated,
  }) async {
    // Event Ticket Order Reference: Points to where the
    //ticket order will be stored for the event.
    final eventTicketDocRef = newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('ticketOrders')
        .doc(ticketOrder.userOrderId);
    // User Ticket Order Reference: Points to where
    //the ticket order will be stored for the user.
    final userTicketDocRef = newUserTicketOrderRef
        .doc(ticketOrder.userOrderId)
        .collection('ticketOrders')
        .doc(ticketOrder.eventId);
    // Retrieves the event details from
    //the organizer's collection.
    DocumentReference eventRef = eventsRef
        .doc(eventAuthorId)
        .collection('userEvents')
        .doc(ticketOrder.eventId);
    // All Event Reference: Retrieves event details
    //from the public collection if the event is not private.
    DocumentReference? allEventRef =
        isEventPrivate ? null : allEventsRef.doc(ticketOrder.eventId);
    // Retrieves current data for the event to ensure
    //any updates are based on the latest information.
    DocumentSnapshot eventSnapshot = await transaction.get(eventRef);
    DocumentSnapshot? allEventSnapshot =
        allEventRef != null ? await transaction.get(allEventRef) : null;
    // Sets up references for event invites if the user has replied to an invitation.
    DocumentReference? eventInviteRef = inviteReply.isEmpty
        ? null
        : sentEventIviteRef
            .doc(ticketOrder.eventId)
            .collection('eventInvite')
            .doc(ticketOrder.userOrderId);

    DocumentReference? userInviteRef = inviteReply.isEmpty
        ? null
        : userInvitesRef
            .doc(ticketOrder.userOrderId)
            .collection('eventInvite')
            .doc(ticketOrder.eventId);
    // Converts the TicketOrderModel to JSON and stores it in both
    //the event and user collections to reflect the purchase.
    Map<String, dynamic> ticketOrderData = ticketOrder.toJson();
    transaction.set(eventTicketDocRef, ticketOrderData);
    transaction.set(userTicketDocRef, ticketOrderData);

    // Add userTicketIdRef to the transaction
    final userTicketIdDocRef = userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('tickedIds')
        .doc(ticketOrder.eventId);

    // Stores metadata about the ticket purchase for user notifications and updates.
    transaction.set(userTicketIdDocRef, {
      'eventId': ticketOrder.eventId,
      'isNew': false,
      'isSeen': false,
      'muteNotification': false,
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // If applicable, updates the ticket sales count and other related statistics.
    // This is skipped if dontUpdateTicketSales is true.
    if (!dontUpdateTicketSales) {
      await updateTicketSales(
        transaction,
        isEventPrivate,
        ticketOrder.eventId,
        eventAuthorId,
        purchasedTicketIds,
        eventSnapshot,
        allEventSnapshot,
        eventRef,
        allEventRef,
      );
    }

    // If the user responded to an invite, updates the invite status in the database.
    if (inviteReply.isNotEmpty)
      await answerEventInviteTransaction(
        transaction: transaction,
        answer: inviteReply,
        eventInviteRef: eventInviteRef,
        userInviteRef: userInviteRef,
      );

    // If the event is affiliated, updates the total sales for the affiliate program associated with the event.
    if (marketAffiliateId.isNotEmpty && isEventAffiliated)
      await updateEventAffiliateTotalSales(
        transaction: transaction,
        eventRef: eventRef,
        allEventRef: allEventRef,
        ticketTotal: ticketOrder.total,
        marketAffiliateId: marketAffiliateId,
        eventId: ticketOrder.eventId,
        buyerUserId: ticketOrder.userOrderId,
        user: user,
        eventAuthorId: ticketOrder.eventAuthorId,
        eventTitle: ticketOrder.eventTitle,
        eventImageUrl: ticketOrder.eventImageUrl,
      );

    // Now add the activity within the transaction
    // Records the ticket purchase activity in the organizer's activity log for tracking and notifications.
    DocumentReference activityDocRef =
        activitiesRef.doc(eventAuthorId).collection('userActivities').doc();

    transaction.set(activityDocRef, {
      'helperFielId': eventAuthorId,
      'authorId': user.userId,
      'postId': ticketOrder.eventId,
      'seen': false,
      'type': 'ticketPurchased',
      'postImageUrl': ticketOrder.eventImageUrl,
      'comment': isEventFree
          ? 'Generated a ticket for: ${ticketOrder.eventTitle}'
          : 'Purchased a ticket for: ${ticketOrder.eventTitle}',
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
      'authorProfileImageUrl': user.profileImageUrl,
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
    });
  }

// The updateEventAffiliateTotalSales function calculates
//the commission and updates the totalAffiliateAmount field in the event document.
  static updateEventAffiliateTotalSales({
    required Transaction transaction,
    required DocumentReference eventRef,
    required DocumentReference? allEventRef,
    required String marketAffiliateId,
    required String eventId,
    required double ticketTotal,
    required String buyerUserId,
    required AccountHolderAuthor user,
    required String eventAuthorId,
    required String eventTitle,
    required String eventImageUrl,
  }) async {
    AffiliateModel? affiliate =
        await getUserAffiliate(marketAffiliateId, eventId);

    if (affiliate == null) return;
    // print('vvvv ' + affiliate.eventTitle);
    double commissionAmount = affiliate.commissionRate / 100;
    final double commission = ticketTotal * commissionAmount;

    // WriteBatch batch = FirebaseFirestore.instance.batch();
    transaction.update(eventRef, {
      'totalAffiliateAmount': commission,
    });

    if (allEventRef != null)
      transaction.update(allEventRef, {
        'totalAffiliateAmount': commission,
      });

    await updateAffiliatetPurchaseeBatch(
      transaction: transaction,
      eventId: eventId,
      affiliateId: marketAffiliateId,
      commissionAmount: commission,
      user: user,
      eventAuthorId: eventAuthorId,
      eventImageUrl: eventImageUrl,
      eventTitle: eventTitle,
    );

    await addAffiliatetPurchasedUserBatch(
      transaction: transaction,
      eventId: eventId,
      affiliateId: marketAffiliateId,
      userId: buyerUserId,
    );
  }

  static Future<void> updateTicketSales(
    Transaction transaction,
    bool isEventPrivate,
    String eventId,
    String authorId,
    List<String> purchasedTicketIds,
    DocumentSnapshot eventSnapshot,
    DocumentSnapshot? allEventSnapshot,
    DocumentReference eventRef,
    DocumentReference? allEventRef,
  ) async {
    if (!eventSnapshot.exists) {
      throw Exception("Event snapshot does not exist.");
    }

    Map<String, dynamic>? eventData =
        eventSnapshot.data() as Map<String, dynamic>?;
    List<TicketModel> ticketsFromUserEvents = eventData == null ||
            eventData['ticket'] == null
        ? []
        : List<TicketModel>.from(eventData['ticket'].map(
            (item) => TicketModel.fromJson(Map<String, dynamic>.from(item))));

    List<TicketModel> ticketsFromAllEvents = [];
    if (allEventSnapshot != null && allEventSnapshot.exists) {
      Map<String, dynamic>? allEventData =
          allEventSnapshot.data() as Map<String, dynamic>?;
      ticketsFromAllEvents = allEventData == null ||
              allEventData['ticket'] == null
          ? []
          : List<TicketModel>.from(allEventData['ticket'].map(
              (item) => TicketModel.fromJson(Map<String, dynamic>.from(item))));
    }
    purchasedTicketIds.forEach((purchasedTicketId) {
      ticketsFromUserEvents.forEach((ticket) {
        if (ticket.id == purchasedTicketId && ticket.maxOder > 0) {
          ticket.salesCount += 1;
          ticket.isSoldOut = ticket.salesCount >= ticket.maxOder;
        }
      });

      if (allEventSnapshot != null) {
        ticketsFromAllEvents.forEach((ticket) {
          if (ticket.id == purchasedTicketId && ticket.maxOder > 0) {
            ticket.salesCount += 1;
            ticket.isSoldOut = ticket.salesCount >= ticket.maxOder;
          }
        });
      }
    });

    if (ticketsFromUserEvents.isNotEmpty) {
      transaction.update(eventRef, {
        'ticket':
            ticketsFromUserEvents.map((ticket) => ticket.toJson()).toList()
      });
    }

    if (allEventSnapshot != null && ticketsFromAllEvents.isNotEmpty) {
      transaction.update(allEventRef!, {
        'ticket': ticketsFromAllEvents.map((ticket) => ticket.toJson()).toList()
      });
    }
  }

  Future<bool> checkTicketAvailability(
      String authorId, String eventId, String ticketId) async {
    // Retrieve the event document from Firestore
    DocumentSnapshot eventSnapshot = await eventsRef
        .doc(authorId)
        .collection('userEvents')
        .doc(eventId)
        .get();

    if (!eventSnapshot.exists) {
      return false; // Event does not exist
    }

    // Deserialize the data into an Event object
    Event event = Event.fromJson(eventSnapshot.data() as Map<String, dynamic>);

    // Iterate through the tickets to find the specific ticket
    for (TicketModel ticket in event.ticket) {
      if (ticket.id == ticketId) {
        return !ticket.isSoldOut; // Return true if the ticket is not sold out
      }
    }

    return false; // Ticket not found or sold out
  }

  static Future<void> deleteTicket({
    required TicketOrderModel ticketOrder,
  }) async {
    newEventTicketOrderRef
        .doc(ticketOrder.eventId)
        .collection('ticketOrders')
        .doc(ticketOrder.userOrderId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    newUserTicketOrderRef
        .doc(ticketOrder.userOrderId)
        .collection('ticketOrders')
        .doc(ticketOrder.eventId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    userTicketIdRef
        .doc(ticketOrder.userOrderId)
        .collection('tickedIds')
        .doc(ticketOrder.eventId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> answerEventInviteTransaction({
    required Transaction transaction,
    // required String eventId,
    required String answer,
    required DocumentReference? eventInviteRef,
    required DocumentReference? userInviteRef,
    // required String  currentUserId,
  }) async {
    transaction.update(eventInviteRef!, {
      'answer': answer,
    });

    transaction.update(userInviteRef!, {
      'answer': answer,
    });
  }

  static Future<void> sendEventInvite({
    required Event event,
    required List<AccountHolderAuthor> users,
    required String message,
    required String generatedMessage,
    required AccountHolderAuthor currentUser,
    required bool isTicketPass,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var user in users) {
      InviteModel invite = InviteModel(
        eventId: event.id,
        timestamp: Timestamp.fromDate(DateTime.now()),
        eventTitle: event.title.toUpperCase(),
        answer: '',
        eventTimestamp: event.startDate,
        generatedMessage: generatedMessage,
        inviteeId: user.userId!,
        inviterId: currentUser.userId!,
        inviterMessage: message,
        isTicketPass: isTicketPass,
        refundRequestStatus: '',
        isDeleted: false,
      );
      Map<String, dynamic> inviteData = invite.toJson();

      DocumentReference newEventTicketOrderRef = sentEventIviteRef
          .doc(event.id)
          .collection('eventInvite')
          .doc(user.userId);
      batch.set(newEventTicketOrderRef, inviteData);

      DocumentReference userInviteRef = userInvitesRef
          .doc(user.userId)
          .collection('eventInvite')
          .doc(event.id);
      batch.set(userInviteRef, inviteData);

      // This should also be included in the batch operation
      DocumentReference userActivityRef = activitiesRef
          .doc(user.userId)
          .collection('userActivities')
          .doc(); // Create a new document with a generated ID
      batch.set(userActivityRef, {
        'helperFielId': event.authorId,
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
        'authorProfileHandle': event.authorId,
        'authorVerification': user.verified,
      });
    }

    // Commit the batch outside of the for loop
    return batch.commit().catchError((error) {
      throw error; // Re-throw the error
    });
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

  static void createDonationBatch({
    required DonationModel donation,
    // required TicketOrderModel ticketOrder,
    required AccountHolderAuthor user,
    required WriteBatch batch,

    // required String eventAuthorId,
    // required String purchaseReferenceId,
  }) async {
    final newDonationToCreativesDocRef = newDonationToCreativesRef
        .doc(donation.receiverId)
        // .collection('donars')
        // .doc(donation.donerId)
        .collection('donations')
        .doc(donation.id);

    final newUserDonationsDocRef = newUserDonationsRef
        .doc(donation.donerId)
        // .collection('receivers')
        // .doc(donation.receiverId)
        .collection('donations')
        .doc(donation.id);
    ;

    Map<String, dynamic> donationData = donation.toJson();

    batch.set(newDonationToCreativesDocRef, donationData);
    batch.set(newUserDonationsDocRef, donationData);

    // Create a new document reference for the activity within the userActivities collection
    DocumentReference activityDocRef = activitiesRef
        .doc(donation.receiverId)
        .collection('userActivities')
        .doc(); // Auto-generate a new document ID for the activity

    // Add activity creation to the batch
    batch.set(activityDocRef, {
      'helperFielId': donation.receiverId,
      'authorId': user.userId,
      'postId': donation.receiverId,
      'seen': false,
      'type': 'donation',
      'postImageUrl': '',
      'comment':
          'Donation of GHC ${donation.amount} received from ${user.userName}',
      'timestamp':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'authorProfileImageUrl':
          user.profileImageUrl, // Assuming there's a profileImageUrl field
      'authorName': user.userName,
      'authorProfileHandle': user.profileHandle,
      'authorVerification': user.verified,
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
            'helperFielId': '',
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
                'helperFielId': '',
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
                    'helperFielId': '',
                    'authorId': user.userId,
                    'postId': user.userId,
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
                        'helperFielId': '',
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
          description: subtitle,
        ),
        link: Uri.parse(urilink),
        uriPrefix: 'https://links.barsopus.com/barsImpression',
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
