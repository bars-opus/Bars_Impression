import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final usersAuthorRef = _firestore.collection('usersAuthors');
final updateAppRef = _firestore.collection('_updateApp');
final postsRef = _firestore.collection('posts');
final allPostsRef = _firestore.collection('allPosts');
final eventsRef = _firestore.collection('events');
final allEventsRef = _firestore.collection('allEvents');
final forumsRef = _firestore.collection('forums');
final blogsRef = _firestore.collection('blogs');
final allBlogsRef = _firestore.collection('allBlogs');
final forumFeedsRef = _firestore.collection('forumFeeds');
final blogFeedsRef = _firestore.collection('blogFeeds');
final allForumsRef = _firestore.collection('allForums');
final eventFeedsRef = _firestore.collection('eventFeeds');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final possitveRatedRef = _firestore.collection('possitiveRated');
final possitiveRatingRef = _firestore.collection('possitiveRating');
final negativeRatedRef = _firestore.collection('negativeRated');
final negativeRatingRef = _firestore.collection('negativeRating');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final thoughtsLikeRef = _firestore.collection('thoughtsLike');
final disLikesRef = _firestore.collection('disLikes');
final commentsRef = _firestore.collection('comments');
final userAdviceRef = _firestore.collection('userAdvice');
final blogCommentsRef = _firestore.collection('blogComments');
final thoughtsRef = _firestore.collection('thoughts');
final replyThoughtsRef = _firestore.collection('thoughtsReplies');
final asksRef = _firestore.collection('asks');
final activitiesRef = _firestore.collection('activities');
final activitiesThoughtLikesRef =
    _firestore.collection('activitiesThoughtLikes');
final chatActivitiesRef = _firestore.collection('activitiesChat');
final activitiesForumRef = _firestore.collection('activitiesForum');
final activitiesAdviceRef = _firestore.collection('activitiesAdvice');
final activitiesEventRef = _firestore.collection('activitiesEvent');
final activitiesBlogRef = _firestore.collection('activitiesBlog');
final activitiesFollowerRef = _firestore.collection('activitiesFollower');
final savedPostsRef = _firestore.collection('savedPosts');
final chatsRef = _firestore.collection('chats');
final chatMessagesRef = _firestore.collection('chatMessages');
final tokenRef = _firestore.collection('token');
final eventInviteRef = _firestore.collection('eventInvites');
final userInviteRef = _firestore.collection('userInvites');
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
