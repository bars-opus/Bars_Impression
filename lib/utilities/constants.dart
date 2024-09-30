import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersLocationSettingsRef =
    _firestore.collection('user_location_settings');
final usersGeneralSettingsRef = _firestore.collection('user_general_settings');
final userProfessionalRef = _firestore.collection('user_professsional');
final usersRatingRef = _firestore.collection('new_userRating');
final userWorkRequestRef = _firestore.collection('user_workRequest');
final allWorkRequestRef = _firestore.collection('all_workRequest');
final usersAuthorRef = _firestore.collection('user_author');
final usernamesRef = _firestore.collection('usernames');
final updateAppRef = _firestore.collection('_updateApp');
final postsRef = _firestore.collection('posts');
final allPostsRef = _firestore.collection('allPosts');
final testingRef = _firestore.collection('testing');
final eventsRef = _firestore.collection('new_events');
final eventsDraftRef = _firestore.collection('new_events_draft');

final userIssueComplaintRef = _firestore.collection('userIssueComplaint');
final deletdEventsRef = _firestore.collection('all_deleted_events');
final allRefundRequestsRef = _firestore.collection('allRefundRequests');
final eventRefundRequestsRef = _firestore.collection('eventRefundRequests');
final eventsChatRoomsRef = _firestore.collection('new_eventChatRooms');
final eventsChatRoomsConverstionRef =
    _firestore.collection('new_eventChatRoomsConversation');
final allEventsRef = _firestore.collection('new_allEvents');
final allEventsSummaryRef = _firestore.collection('new_allEventsSummary');
final eventFeedsRef = _firestore.collection('new_eventFeeds');
final followersRef = _firestore.collection('new_followers');
final followingRef = _firestore.collection('new_following');
final organiserAttendeeListRef =
    _firestore.collection('new_organizer_attendees');
final followRequestsRef = _firestore.collection('new_followRequests');
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
final savedPostsRef = _firestore.collection('savedPosts');
final chatsRef = _firestore.collection('chats');
final chatMessagesRef = _firestore.collection('chatMessages');
final tokenRef = _firestore.collection('token');
final newDonationToCreativesRef =
    _firestore.collection('new_donationToCreative');

    
final newBrandMatchingRef = _firestore.collection('new_brand_matching');

final processingFeesRef = _firestore.collection('processingFees');



final new_userBrandIfoRef = _firestore.collection('new_userBrandIfo');
final newEventBrandMatchingRef =
    _firestore.collection('new_event_brand_matching');
final newUserDonationsRef = _firestore.collection('new_userDonations');
final newBookingsReceivedRef = _firestore.collection('new_userBookingReceived');
final newBookingsSentRef = _firestore.collection('new_userBookingMade');
final newReviewReceivedRef = _firestore.collection('new_userReviewReceived');
final newReviewMadeRef = _firestore.collection('new_userReviewMade');
final newEventTicketOrderRef = _firestore.collection('new_eventTicketOrder');
final sentEventIviteRef = _firestore.collection('new_sentEventInvite');
final userTagRef = _firestore.collection('new_userTags');

final userRefundRequestsRef = _firestore.collection('userRefundRequests');
final userPayoutRequestRef = _firestore.collection('userPayoutRequests');
final eventAffiliateRef = _firestore.collection('new_eventAffiliate');
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
