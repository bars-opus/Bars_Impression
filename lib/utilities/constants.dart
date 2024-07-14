import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

//work on it for chats
// final usersRef = _firestore.collection('users');

final usersLocationSettingsRef =
    _firestore.collection('user_location_settings');

final usersGeneralSettingsRef = _firestore.collection('user_general_settings');

final userProfessionalRef = _firestore.collection('user_professsional');

final userWorkRequestRef = _firestore.collection('user_workRequest');
final allWorkRequestRef = _firestore.collection('all_workRequest');

final usersAuthorRef = _firestore.collection('user_author');
final usernamesRef = _firestore.collection('usernames');

// final usersAuthorRef = _firestore.collection('usersAuthors');
final updateAppRef = _firestore.collection('_updateApp');
final postsRef = _firestore.collection('posts');
final allPostsRef = _firestore.collection('allPosts');

final testingRef = _firestore.collection('testing');

//
final eventsRef = _firestore.collection('new_events');
final userIssueComplaintRef = _firestore.collection('userIssueComplaint');

final deletdEventsRef = _firestore.collection('all_deleted_events');

final allRefundRequestsRef = _firestore.collection('allRefundRequests');
final eventRefundRequestsRef = _firestore.collection('eventRefundRequests');

final eventsChatRoomsRef = _firestore.collection('new_eventChatRooms');

final eventsChatRoomsConverstionRef =
    _firestore.collection('new_eventChatRoomsConversation');

final allEventsRef = _firestore.collection('new_allEvents');

// final forumsRef = _firestore.collection('forums');
// final blogsRef = _firestore.collection('blogs');
// final allBlogsRef = _firestore.collection('allBlogs');
// final forumFeedsRef = _firestore.collection('forumFeeds');
// final blogFeedsRef = _firestore.collection('blogFeeds');
// final allForumsRef = _firestore.collection('allForums');

//
final eventFeedsRef = _firestore.collection('new_eventFeeds');

// final followersRef = _firestore.collection('followers');
// final followingRef = _firestore.collection('following');

final followersRef = _firestore.collection('new_followers');
final followingRef = _firestore.collection('new_following');
final followRequestsRef = _firestore.collection('new_followRequests');

// final possitveRatedRef = _firestore.collection('possitiveRated');
// final possitiveRatingRef = _firestore.collection('possitiveRating');
// final negativeRatedRef = _firestore.collection('negativeRated');
// final negativeRatingRef = _firestore.collection('negativeRating');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final thoughtsLikeRef = _firestore.collection('thoughtsLike');
final disLikesRef = _firestore.collection('disLikes');
final commentsRef = _firestore.collection('new_comments');
final userAdviceRef = _firestore.collection('new_userAdvice');
final blogCommentsRef = _firestore.collection('blogComments');
final thoughtsRef = _firestore.collection('thoughts');
final replyThoughtsRef = _firestore.collection('thoughtsReplies');
final asksRef = _firestore.collection('new_asks');
final activitiesRef = _firestore.collection('new_activities');
final chatActivitiesRef = _firestore.collection('new_activities_chat');

// final activitiesThoughtLikesRef =
//     _firestore.collection('activitiesThoughtLikes');
// final chatActivitiesRef = _firestore.collection('activitiesChat');
// final activitiesForumRef = _firestore.collection('activitiesForum');
// final activitiesAdviceRef = _firestore.collection('activitiesAdvice');
// final activitiesEventRef = _firestore.collection('activitiesEvent');
// final activitiesBlogRef = _firestore.collection('activitiesBlog');
// final activitiesFollowerRef = _firestore.collection('activitiesFollower');
final savedPostsRef = _firestore.collection('savedPosts');
final chatsRef = _firestore.collection('chats');
final chatMessagesRef = _firestore.collection('chatMessages');
final tokenRef = _firestore.collection('token');
// final newEventTicketOrderRef = _firestore.collection('eventInvites');

final newEventTicketOrderRef = _firestore.collection('new_eventTicketOrder');
final sentEventIviteRef = _firestore.collection('new_sentEventInvite');
// final userIviteRef = _firestore.collection('new_usersInvite');
final userRefundRequestsRef = _firestore.collection('userRefundRequests');
final userPayoutRequestRef = _firestore.collection('userPayoutRequests');

final eventAffiliateRef = _firestore.collection('eventAffiliate');
final userAffiliateRef = _firestore.collection('userAffiliate');
final userAffiliateBuyersRef = _firestore.collection('userAffiliateBuyers');

final userInvitesRef = _firestore.collection('userInvites');

final newUserTicketOrderRef = _firestore.collection('new_userTicketOrder');
final userTicketIdRef = _firestore.collection('new_ticketId');

final messageRef = _firestore.collection('messages');

final usersBlockedRef = _firestore.collection('usersBlocked');
final userBlockingRef = _firestore.collection('usersBlocking');

final verificationRef = _firestore.collection('_VerificationRequest');
final accountTypesRef = _firestore.collection('userAccountTypes');
final eventTypesRef = _firestore.collection('eventTypes');
final surveysRef = _firestore.collection('_surveys');
final suggestionsRef = _firestore.collection('_suggestions');
final reportContentsRef = _firestore.collection('_reportedContents');
final kpiStatisticsRef = _firestore.collection('_kPI_statistics');
final deletedDeactivatedAccountRef =
    _firestore.collection('_DeletedDeactivatedAccounts');
