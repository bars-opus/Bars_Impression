import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static void updateUser(AccountHolder user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'userName': user.userName,
      'profileImageUrl!': user.profileImageUrl!,
      'bio': user.bio,
      'favouritePunchline': user.favouritePunchline,
      'favouriteArtist': user.favouriteArtist,
      'favouriteSong': user.favouriteSong,
      'favouriteAlbum': user.favouriteAlbum,
      'company': user.company,
      'country': user.country,
      'city': user.city,
      'continent': user.continent,
      'skills': user.skills,
      'performances': user.performances,
      'collaborations': user.collaborations,
      'awards': user.awards,
      'management': user.management,
      'contacts': user.contacts,
      'profileHandle!': user.profileHandle!,
      'report': user.report,
      'reportConfirmed': user.reportConfirmed,
      'website': user.website,
      'otherSites1': user.otherSites1,
      'otherSites2': user.otherSites2,
      'mail': user.mail,
      'score': user.score,
      'privateAccount': user.privateAccount,
      'androidNotificationToken': user.androidNotificationToken,
      'hideUploads': user.hideUploads,
      'verified': user.verified,
      'disableAdvice': user.disableAdvice,
      'disableChat': user.disableChat,
      'enableBookingOnChat': user.enableBookingOnChat,
      'hideAdvice': user.hideAdvice,
      'noBooking': user.noBooking,
      'disabledAccount': user.disabledAccount,
      'professionalPicture1': user.professionalPicture1,
      'professionalPicture2': user.professionalPicture2,
      'professionalPicture3': user.professionalPicture3,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users = usersRef
        .where('userName', isGreaterThanOrEqualTo: name)
        .limit(30)
        .get();
    return users;
  }

  static Future<QuerySnapshot> searchArtist(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('userName', isEqualTo: name).get();
    return users;
  }

  static Stream<int> numFavoriteArtist(String name) {
    return usersRef
        .where('favouriteArtist', isEqualTo: name)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numSongs(String song) {
    return usersRef
        .where('favouriteSong', isEqualTo: song)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numAlbums(String albums) {
    return usersRef
        .where('favouriteAlbum', isEqualTo: albums)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  // static Future<List<AccountHolder>> getAllUsers(
  //   String userId,
  // ) async {
  //   final userSnapShot = await usersRef
  //       .where('profileHandle!', isNotEqualTo: 'Fan')
  //       .limit(50)
  //       .get();
  //   List<AccountHolder> accountHolder =
  //       userSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();

  //   return accountHolder;
  // }

  static void addChatActivityItem({
    required String currentUserId,
    required String toUserId,
    required String content,
  }) {
    if (currentUserId != toUserId) {
      chatActivitiesRef.doc(toUserId).collection('chatActivities').add({
        'fromUserId': currentUserId,
        'toUserId': currentUserId,
        'seen': '',
        'comment': content,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static void deleteMessage({
    required String currentUserId,
    required String userId,
    required ChatMessage message,
  }) async {
    usersRef
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
      usersRef.doc(currentUserId).collection('chats').doc(userId).update({
        'lastMessage': 'deleted message',
        'seen': 'seen',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
    usersRef
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
      usersRef.doc(userId).collection('chats').doc(currentUserId).update({
        'lastMessage': 'deleted message',
        'seen': ' ',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
  }

  static void likeMessage({
    required String currentUserId,
    required String userId,
    required bool liked,
    required ChatMessage message,
  }) {
    usersRef
        .doc(currentUserId)
        .collection('chats')
        .doc(userId)
        .collection('chatMessage')
        .doc(message.id)
        .update({
      'liked': liked,
      'timestamp': message.timestamp,
    }).then((value) {
      usersRef.doc(currentUserId).collection('chats').doc(userId).update({
        'lastMessage': liked ? 'like' : 'unLike',
        'seen': 'seen',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });

    usersRef
        .doc(userId)
        .collection('chats')
        .doc(currentUserId)
        .collection('chatMessage')
        .doc(message.id)
        .update({
      'liked': liked,
      'timestamp': message.timestamp,
    }).then((value) {
      usersRef.doc(userId).collection('chats').doc(currentUserId).update({
        'lastMessage': liked ? 'like' : 'unLike',
        'seen': ' ',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
  }

  static Stream<int> numChats(
    String currentUserId,
  ) {
    return usersRef
        .doc(currentUserId)
        .collection('chats')
        .where('seen', isEqualTo: " ")
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void firstChatMessage(
      {required String currentUserId,
      required String userId,
      // required Chat chat,
      required String MediaType,
      required String replyingMessage,
      required String replyingAuthor,
      required String imageUrl,
      required String messageInitiator,
      required bool restrictChat,
      required String message,
      required String liked,
      required String reportConfirmed}) {
    String messageId = Uuid().v4();
    usersRef
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
      'imageUrl': imageUrl,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersRef.doc(currentUserId).collection('chats').doc(userId).set({
        'lastMessage': message,
        'messageInitiator': messageInitiator,
        'restrictChat': restrictChat,
        'firstMessage': message,
        'MediaType': MediaType,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'seen': 'seen',
        'fromUserId': currentUserId,
        'toUserId': userId,
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });

    usersRef
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
      'imageUrl': imageUrl,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersRef.doc(userId).collection('chats').doc(currentUserId).set({
        'lastMessage': message,
        'messageInitiator': messageInitiator,
        'restrictChat': restrictChat,
        'firstMessage': message,
        'MediaType': MediaType,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'seen': ' ',
        'fromUserId': currentUserId,
        'toUserId': userId,
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
    addChatActivityItem(
        currentUserId: currentUserId, content: message, toUserId: userId);
  }

  static void chatMessage(
      {required String currentUserId,
      required String userId,
      // required Chat chat,
      required String replyingMessage,
      required String replyingAuthor,
      required String imageUrl,
      required String message,
      required String MediaType,
      required String liked,
      required String reportConfirmed}) {
    String messageId = Uuid().v4();
    usersRef
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
      'imageUrl': imageUrl,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersRef.doc(currentUserId).collection('chats').doc(userId).update({
        'lastMessage': message,
        'seen': 'seen',
        'MediaType': MediaType,
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });

    usersRef
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
      'imageUrl': imageUrl,
      'report': '',
      'liked': false,
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      usersRef.doc(userId).collection('chats').doc(currentUserId).update({
        'lastMessage': message,
        'MediaType': MediaType,
        'seen': ' ',
        'newMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    });
    addChatActivityItem(
        currentUserId: currentUserId, content: message, toUserId: userId);
  }

  static void likePost({required String currentUserId, required Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postRef.get().then((doc) {
      int likeCount = doc['likeCount'];
      postRef.update({'likeCount': likeCount + 1});
      likesRef.doc(post.id).collection('postLikes').doc(currentUserId).set({});
      addActivityItem(currentUserId: currentUserId, post: post, comment: null);
    });
  }

  static void createPost(Post post) {
    postsRef.doc(post.authorId).collection('userPosts').add({
      'postId': post.id,
      'blurHash': post.blurHash,
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'artist': post.artist,
      'punch': post.punch,
      'hashTag': post.hashTag,
      'musicLink': post.musicLink,
      'likeCount': post.likeCount,
      'report': post.report,
      'reportConfirmed': post.reportConfirmed,
      'disLikeCount': post.disLikeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void editPunch(Post post) {
    postsRef.doc(post.authorId).collection('userPosts').doc(post.id).update({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'blurHash': post.blurHash,
      'artist': post.artist,
      'punch': post.punch,
      'hashTag': post.hashTag,
      'musicLink': post.musicLink,
      'likeCount': post.likeCount,
      'disLikeCount': post.disLikeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void createEvent(Event event) {
    eventsRef.doc(event.authorId).collection('userEvents').add({
      'imageUrl': event.imageUrl,
      'title': event.title,
      'type': event.type,
      'rate': event.rate,
      'venue': event.venue,
      'theme': event.theme,
      'date': event.date,
      'dressCode': event.dressCode,
      'time': event.time,
      'dj': event.dj,
      'guess': event.guess,
      'host': event.host,
      'report': event.report,
      'reportConfirmed': event.reportConfirmed,
      'artist': event.artist,
      'authorId': event.authorId,
      'timestamp': event.timestamp,
      'previousEvent': event.previousEvent,
      'triller': event.triller,
      'city': event.city,
      'country': event.country,
      'virtualVenue': event.virtualVenue,
      'ticketSite': event.ticketSite,
      'isVirtual': event.isVirtual,
      'blurHash': event.blurHash,
    });
  }

  static void editEvent(Event event) {
    eventsRef
        .doc(event.authorId)
        .collection('userEvents')
        .doc(event.id)
        .update({
      'imageUrl': event.imageUrl,
      'title': event.title,
      'type': event.type,
      'rate': event.rate,
      'venue': event.venue,
      'theme': event.theme,
      'date': event.date,
      'dressCode': event.dressCode,
      'time': event.time,
      'dj': event.dj,
      'guess': event.guess,
      'host': event.host,
      'artist': event.artist,
      'authorId': event.authorId,
      'timestamp': event.timestamp,
      'previousEvent': event.previousEvent,
      'triller': event.triller,
      'isVirtual': event.isVirtual,
      'city': event.city,
      'country': event.country,
      'virtualVenue': event.virtualVenue,
      'ticketSite': event.ticketSite,
      'blurHash': event.blurHash,
    });
  }

  static void createForum(Forum forum) {
    forumsRef.doc(forum.authorId).collection('userForums').add({
      'title': forum.title,
      'subTitle': forum.subTitle,
      'authorId': forum.authorId,
      'report': forum.report,
      'reportConfirmed': forum.reportConfirmed,
      'timestamp': forum.timestamp,
    });
  }

  static void editForum(Forum forum) {
    forumsRef
        .doc(forum.authorId)
        .collection('userForums')
        .doc(forum.id)
        .update({
      'title': forum.title,
      'subTitle': forum.subTitle,
      'authorId': forum.authorId,
      'timestamp': forum.timestamp,
    });
  }

  static void requestVerification(Verification verification) {
    surveysRef.add({
      'id': verification.id,
      'userId': verification.userId,
      'legalName': verification.legalName,
      'verificationType': verification.verificationType,
      'brandType': verification.brandType,
      'govIdType': verification.govIdType,
      'email': verification.email,
      'phoneNumber': verification.phoneNumber,
      'gvIdImageUrl': verification.gvIdImageUrl,
      'website': verification.website,
      'socialMedia': verification.socialMedia,
      'notableAricle1': verification.notableAricle1,
      'brandAudienceCustomers': verification.brandAudienceCustomers,
      'notableAricle2': verification.notableAricle2,
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
    });
  }

  static void deletePunch({
    required String currentUserId,
    required Post post,
  }) async {
    print(post.id);
    postsRef
        .doc(currentUserId)
        .collection('userPosts')
        .doc(post.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot activitySnapShot = await activitiesRef
        .doc(currentUserId)
        .collection('userActivities')
        .where('postId', isEqualTo: post.id)
        .get();

    activitySnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot commentsSnapShot =
        await commentsRef.doc(post.id).collection('postComments').get();
    commentsSnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delet punch likes
    QuerySnapshot likeSnapshot =
        await likesRef.doc(post.id).collection('postLikes').get();
    likeSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot disLikeSnapshot =
        await disLikesRef.doc(post.id).collection('postDisLikes').get();
    disLikeSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void deleteForum({
    required String currentUserId,
    required Forum forum,
    required String photoId,
  }) async {
    // Remove user from current user's following collection
    forumsRef
        .doc(currentUserId)
        .collection('userForums')
        .doc(forum.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete activity image
    QuerySnapshot activitySnapShot = await activitiesForumRef
        .doc(currentUserId)
        .collection('userActivitiesForum')
        .where('forumId', isEqualTo: forum.id)
        .get();

    activitySnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delet forum thoughts
    QuerySnapshot thoughtsSnapShot =
        await thoughtsRef.doc(forum.id).collection('forumThoughts').get();
    thoughtsSnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void deleteEvent({
    required String currentUserId,
    required Event event,
    required String photoId,
  }) async {
    // Remove user from current user's following collection
    eventsRef
        .doc(currentUserId)
        .collection('userEvents')
        .doc(event.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity image
    QuerySnapshot activitySnapShot = await activitiesEventRef
        .doc(currentUserId)
        .collection('userActivitiesEvent')
        .where('eventId', isEqualTo: event.id)
        .get();

    activitySnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delet event asks
    QuerySnapshot asksSnapShot =
        await asksRef.doc(event.id).collection('eventAsks').get();
    asksSnapShot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void followUser(
      {required String currentUserId, required String userId}) {
    // Add use to current user's following collection
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(userId)
        .set({
      'uid': userId,
    });

    addActivityFollowerItem(
      currentUserId: currentUserId,
      userId: userId,
    );
    //Add current user to user's followers collection
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({
      'uid': currentUserId,
    });
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
    deletedFollowerActivity(
      currentUserId: currentUserId,
      userId: userId,
    );
  }

  static void deletedFollowerActivity(
      {required String currentUserId, required String userId}) async {
    QuerySnapshot activitySnapShot = await activitiesFollowerRef
        .doc(userId)
        .collection('activitiesFollower')
        .where('fromUserId', isEqualTo: currentUserId)
        .get();
    activitySnapShot.docs.forEach((doc) {
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
      required AccountHolder user,
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

    // addUserBlockedItem(
    //   currentUserId: currentUserId,
    //   userId: userId,
    // );
    // //Add current user to user's followers collection
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

  // static void addUserBlockedItem({
  //   required String currentUserId,
  //   required String userId,
  // }) {
  //   if (currentUserId != userId) {
  //     userBlockedRef.doc(userId).collection('userBlocked').add({
  //       'fromUserId': currentUserId,
  //       'blockedUserId': userId,
  //       'timestamp': Timestamp.fromDate(DateTime.now()),
  //     });
  //   }
  // }

  static void possitivelyRateUser(
      {required String currentUserId, required String userId}) {
    possitiveRatingRef
        .doc(currentUserId)
        .collection('userPossitiveRating')
        .doc(userId)
        .set({
      'uid': userId,
    });

    possitveRatedRef
        .doc(userId)
        .collection('userPossitiveRated')
        .doc(currentUserId)
        .set({
      'uid': currentUserId,
    });
  }

  static void unPossitivelyRateUser(
      {required String currentUserId, required String userId}) {
    possitiveRatingRef
        .doc(currentUserId)
        .collection('userPossitiveRating')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    possitveRatedRef
        .doc(userId)
        .collection('userPossitiveRated')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void negativelyRateUser(
      {required String currentUserId, required String userId}) {
    negativeRatingRef
        .doc(currentUserId)
        .collection('userNegativeRating')
        .doc(userId)
        .set({
      'uid': userId,
    });
    negativeRatedRef
        .doc(userId)
        .collection('userNegativeRated')
        .doc(currentUserId)
        .set({
      'uid': currentUserId,
    });
  }

  static void unNegativelyRateUser(
      {required String currentUserId, required String userId}) {
    negativeRatingRef
        .doc(currentUserId)
        .collection('userNegativeRating')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    negativeRatedRef
        .doc(userId)
        .collection('userNegativeRated')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isPossitivelyRatingUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot followingDoc = await possitveRatedRef
        .doc(userId)
        .collection('userPossitiveRated')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numPossitiveRating(String userId) async {
    QuerySnapshot ratingSnapshot = await possitiveRatingRef
        .doc(userId)
        .collection('userPossitiveRating')
        .get();
    return ratingSnapshot.docs.length;
  }

  static Future<int> numPosstiveRated(String userId) async {
    QuerySnapshot ratedSnapshot = await possitveRatedRef
        .doc(userId)
        .collection('userPossitiveRated')
        .get();
    return ratedSnapshot.docs.length;
  }

  static Future<bool> isNegativelyRatingUser(
      {required String currentUserId, required String userId}) async {
    DocumentSnapshot ratingDoc = await negativeRatedRef
        .doc(userId)
        .collection('userNegativeRated')
        .doc(currentUserId)
        .get();
    return ratingDoc.exists;
  }

  static Future<int> numNegativeRating(String userId) async {
    QuerySnapshot ratingSnapshot = await negativeRatingRef
        .doc(userId)
        .collection('userNegativeRating')
        .get();
    return ratingSnapshot.docs.length;
  }

  static Future<int> numNegativeRated(String userId) async {
    QuerySnapshot ratedSnapshot = await negativeRatedRef
        .doc(userId)
        .collection('userNegativeRated')
        .get();
    return ratedSnapshot.docs.length;
  }

  static Future<AccountHolder> getUseractivityFollowers(
      String userId, replyingMessage) async {
    DocumentSnapshot userDocSnapshot = await usersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(userId)
        .get();
    return AccountHolder.fromDoc(userDocSnapshot);
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

  static Future<int> numFeedBlogs(String userId) async {
    QuerySnapshot feedBlogSnapShot =
        await blogFeedsRef.doc(userId).collection('userBlogFeed').get();
    return feedBlogSnapShot.docs.length - 1;
  }

  static Future<int> numFeedForums(String userId) async {
    QuerySnapshot feedForumSnapShot =
        await forumFeedsRef.doc(userId).collection('userForumFeed').get();
    return feedForumSnapShot.docs.length - 1;
  }

  static Future<List<Post>> getAllPosts(
    String userId,
  ) async {
    QuerySnapshot allPostsSnapShot =
        await allPostsRef.orderBy('timestamp', descending: true).get();
    List<Post> posts =
        allPostsSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> getAllArtistPosts(
      String userId, String artist) async {
    QuerySnapshot allPostsSnapShot =
        await allPostsRef.where('artist', isEqualTo: artist).get();
    List<Post> posts =
        allPostsSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Stream<int> numArtistPunch(String userId, String artist) {
    return allPostsRef
        .where('artist', isEqualTo: artist)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<List<Post>> getAllhasTagPosts(
      String userId, String hashTag) async {
    QuerySnapshot allPostsSnapShot =
        await allPostsRef.where('hashTag', isEqualTo: hashTag).get();
    List<Post> posts =
        allPostsSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Stream<int> numPunchlinePunch(String userId, String punchline) {
    return allPostsRef
        .where('punch', isEqualTo: punchline)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Stream<int> numHashTagPunch(String userId, String hashTag) {
    return allPostsRef
        .where('hashTag', isEqualTo: hashTag)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        userPostsSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Forum>> getUserForums(String userId) async {
    QuerySnapshot userForumsSnapshot = await forumsRef
        .doc(userId)
        .collection('userForums')
        .orderBy('timestamp', descending: true)
        .get();
    List<Forum> forums =
        userForumsSnapshot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    return forums;
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
        updateVersionIos: null);
  }

  static Future<AccountHolder> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.doc(userId).get();
    if (userDocSnapshot.exists) {
      return AccountHolder.fromDoc(userDocSnapshot);
    }
    return AccountHolder(
        disabledAccount: null,
        androidNotificationToken: '',
        continent: '',
        hideUploads: null,
        favouriteSong: '',
        name: '',
        mail: '',
        noBooking: null,
        hideAdvice: null,
        enableBookingOnChat: null,
        email: '',
        disableChat: null,
        disableAdvice: null,
        favouritePunchline: '',
        otherSites1: '',
        management: '',
        otherSites2: '',
        performances: '',
        collaborations: '',
        favouriteAlbum: '',
        country: '',
        favouriteArtist: '',
        company: '',
        bio: '',
        awards: '',
        city: '',
        id: '',
        contacts: '',
        professionalPicture1: '',
        professionalPicture2: '',
        professionalPicture3: '',
        profileImageUrl: '',
        userName: '',
        score: null,
        privateAccount: null,
        skills: '',
        verified: '',
        report: '',
        reportConfirmed: '',
        website: '',
        profileHandle: '',
        timestamp: null);
  }

  static Future<int> numLikes(String? postId) async {
    QuerySnapshot likeSnapshot =
        await likesRef.doc(postId).collection('postLikes').get();
    return likeSnapshot.docs.length;
  }

  static void unlikePost({required String currentUserId, required Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postRef.get().then((doc) {
      int likeCount = doc['likeCount'];
      postRef.update({'likeCount': likeCount - 1});
      likesRef
          .doc(post.id)
          .collection('postLikes')
          .doc(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<int> numDisLikes(String? postId) async {
    QuerySnapshot disLikeSnapshot =
        await disLikesRef.doc(postId).collection('postDisLikes').get();
    return disLikeSnapshot.docs.length;
  }

  static Future<bool> didLikePost(
      {required String currentUserId, required Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(post.id)
        .collection('postLikes')
        .doc(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void disLikePost({required String currentUserId, required Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postRef.get().then((doc) {
      int disLikeCount = doc['disLikeCount'];
      postRef.update({'disLikeCount': disLikeCount + 1});
      disLikesRef
          .doc(post.id)
          .collection('postDisLikes')
          .doc(currentUserId)
          .set({});
    });
  }

  static void unDisLikePost(
      {required String currentUserId, required Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection('userPosts').doc(post.id);
    postRef.get().then((doc) {
      int disLikeCount = doc['disLikeCount'];
      postRef.update({'disLikeCount': disLikeCount - 1});
      disLikesRef
          .doc(post.id)
          .collection('postDisLikes')
          .doc(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didDisLikePost(
      {required String currentUserId, required Post post}) async {
    DocumentSnapshot userDoc = await disLikesRef
        .doc(post.id)
        .collection('postDisLikes')
        .doc(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void commentOnPost(
      {required String currentUserId,
      required Post post,
      required String comment,
      required String reportConfirmed}) {
    commentsRef.doc(post.id).collection('postComments').add({
      'content': comment,
      'authorId': currentUserId,
      'report': '',
      'reportConfirmed': reportConfirmed,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityItem(currentUserId: currentUserId, post: post, comment: comment);
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
  }

  static void editComments(
    Comment comment,
    Post post,
  ) {
    commentsRef.doc(post.id).collection('postComments').doc(comment.id).update({
      'content': comment.content,
      'authorId': comment.authorId,
      'timestamp': comment.timestamp
    });
  }

  static void userAdvice(
      {required String currentUserId,
      required AccountHolder user,
      required String advice,
      required String reportConfirmed}) {
    userAdviceRef.doc(user.id).collection('userAdvice').add({
      'content': advice,
      'report': '',
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityAdviceItem(
        currentUserId: currentUserId, user: user, advice: advice);
  }

  static Stream<int> numAdvices(String userId) {
    return userAdviceRef
        .doc(userId)
        .collection('userAdvice')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void deleteAdvice(
      {required String currentUserId,
      required AccountHolder user,
      required UserAdvice advice}) async {
    userAdviceRef
        .doc(user.id)
        .collection('userAdvice')
        .doc(advice.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void editAdvice(
    UserAdvice advice,
    AccountHolder user,
  ) {
    userAdviceRef.doc(user.id).collection('userAdvice').doc(advice.id).update({
      'content': advice.content,
      'authorId': advice.authorId,
      'timestamp': advice.timestamp
    });
  }

  static void replyThought(
      {required String currentUserId,
      required String thoughtId,
      required Forum forum,
      required int count,
      required String replyThought,
      required String reportConfirmed}) {
    replyThoughtsRef.doc(thoughtId).collection('replyThoughts').add({
      'content': replyThought,
      'reportConfirmed': reportConfirmed,
      'report': '',
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }).then((value) => thoughtsRef
            .doc(forum.id)
            .collection('forumThoughts')
            .doc(thoughtId)
            .update({
          'count': count,
        }));

    addActivityForumItem(
        currentUserId: currentUserId, forum: forum, thought: replyThought);
  }

  static void thoughtOnForum(
      {required String currentUserId,
      required Forum forum,
      required String thought,
      required String reportConfirmed}) {
    thoughtsRef.doc(forum.id).collection('forumThoughts').add({
      'content': thought,
      'count': 0,
      'reportConfirmed': reportConfirmed,
      'report': '',
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityForumItem(
        currentUserId: currentUserId, forum: forum, thought: thought);
  }

  static void deleteThought(
      {required String currentUserId,
      required Forum forum,
      required Thought thought}) async {
    thoughtsRef
        .doc(forum.id)
        .collection('forumThoughts')
        .doc(thought.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void editThought(
    Thought thought,
    Forum forum,
  ) {
    thoughtsRef
        .doc(forum.id)
        .collection('forumThoughts')
        .doc(thought.id)
        .update({
      'content': thought.content,
      'authorId': thought.authorId,
      'timestamp': thought.timestamp,
    });
  }

  static Stream<int> numThoughts(String forumId) {
    return thoughtsRef
        .doc(forumId)
        .collection('forumThoughts')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void askAboutEvent(
      {required String currentUserId,
      required Event event,
      required String ask,
      required String reportConfirmed}) {
    asksRef.doc(event.id).collection('eventAsks').add({
      'content': ask,
      'report': '',
      'reportConfirmed': reportConfirmed,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityEventItem(currentUserId: currentUserId, event: event, ask: ask);
  }

  static Stream<int> numAsks(String eventId) {
    return asksRef
        .doc(eventId)
        .collection('eventAsks')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
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

  static void addActivityFollowerItem(
      {required String currentUserId, required String userId}) {
    if (currentUserId != userId) {
      activitiesFollowerRef.doc(userId).collection('activitiesFollower').add({
        'fromUserId': currentUserId,
        'userId': userId,
        'seen': '',
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static void editActivityFollower(ActivityFollower activity, String useId) {
    activitiesFollowerRef
        .doc(useId)
        .collection('activitiesFollower')
        .doc(activity.id)
        .update({
      'fromUserId': activity.fromUserId,
      'userId': activity.userId,
      'seen': activity.seen,
      'timestamp': activity.timestamp,
    });
  }

  static Stream<int> numActivitiesFollower(String userId) {
    return activitiesFollowerRef
        .doc(userId)
        .collection('activitiesFollower')
        .where('seen', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void addActivityItem(
      {required String currentUserId,
      required Post post,
      required String? comment}) {
    if (currentUserId != post.authorId) {
      activitiesRef.doc(post.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'postId': post.id,
        'seen': '',
        'postImageUrl': post.imageUrl,
        'comment': comment,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
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
      'fromUserId': activity.fromUserId,
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
        .where('seen', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static void addActivityAdviceItem(
      {required String currentUserId,
      required AccountHolder user,
      required String advice}) {
    if (currentUserId != user.id) {
      activitiesAdviceRef.doc(user.id).collection('userActivitiesAdvice').add({
        'fromUserId': currentUserId,
        'userId': user.id,
        'seen': '',
        'advice': advice,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static void editActivityAdvice(ActivityAdvice activityAdvice, String useId) {
    activitiesAdviceRef
        .doc(useId)
        .collection('userActivitiesAdvice')
        .doc(activityAdvice.id)
        .update({
      'fromUserId': activityAdvice.fromUserId,
      'userId': activityAdvice.userId,
      'seen': activityAdvice.seen,
      'advice': activityAdvice.advice,
      'timestamp': activityAdvice.timestamp,
    });
  }

  static Stream<int> numActivitiesAdvice(String userId) {
    return activitiesAdviceRef
        .doc(userId)
        .collection('userActivitiesAdvice')
        .where('seen', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot =
        await postsRef.doc(userId).collection('userPosts').doc(postId).get();
    return Post.fromDoc(postDocSnapshot);
  }

  static void addActivityForumItem(
      {required String currentUserId,
      required Forum forum,
      required String thought}) {
    if (currentUserId != forum.authorId) {
      activitiesForumRef
          .doc(forum.authorId)
          .collection('userActivitiesForum')
          .add({
        'fromUserId': currentUserId,
        'forumId': forum.id,
        'seen': '',
        'forumTitle': forum.title,
        'thought': thought,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static void editActivityForum(ActivityForum activityForum, String userId) {
    activitiesForumRef
        .doc(userId)
        .collection('userActivitiesForum')
        .doc(activityForum.id)
        .update({
      'fromUserId': activityForum.fromUserId,
      'forumId': activityForum.forumId,
      'seen': activityForum.seen,
      'forumTitle': activityForum.forumTitle,
      'thought': activityForum.thought,
      'timestamp': activityForum.timestamp,
    });
  }

  static Stream<int> numForumActivities(String userId) {
    return activitiesForumRef
        .doc(userId)
        .collection('userActivitiesForum')
        .where('seen', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<Forum> getUserForum(String userId, String forumId) async {
    DocumentSnapshot forumDocSnapshot =
        await forumsRef.doc(userId).collection('userForums').doc(forumId).get();
    return Forum.fromDoc(forumDocSnapshot);
  }

  static void addActivityEventItem(
      {required String currentUserId,
      required Event event,
      required String ask}) {
    if (currentUserId != event.authorId) {
      activitiesEventRef
          .doc(event.authorId)
          .collection('userActivitiesEvent')
          .add({
        'fromUserId': currentUserId,
        'eventId': event.id,
        'seen': '',
        'eventImageUrl': event.imageUrl,
        'eventTitle': event.title,
        'ask': ask,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static void editActivityEvent(ActivityEvent activityEvent, String useId) {
    activitiesEventRef
        .doc(useId)
        .collection('userActivitiesEvent')
        .doc(activityEvent.id)
        .update({
      'fromUserId': activityEvent.fromUserId,
      'eventId': activityEvent.eventId,
      'seen': activityEvent.seen,
      'eventImageUrl': activityEvent.eventImageUrl,
      'eventTitle': activityEvent.eventTitle,
      'ask': activityEvent.ask,
      'timestamp': activityEvent.timestamp,
    });
  }

  static Stream<int> numEventActivities(String userId) {
    return activitiesEventRef
        .doc(userId)
        .collection('userActivitiesEvent')
        .where('seen', isEqualTo: '')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs.length);
  }

  static Future<Event> getUserEvent(String userId, String eventId) async {
    DocumentSnapshot eventDocSnapshot =
        await eventsRef.doc(userId).collection('userEvents').doc(eventId).get();
    return Event.fromDoc(eventDocSnapshot);
  }
}
