import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityForum {
  final String id;
  final String fromUserId;
  final String seen;
  final String forumId;

  final String forumAuthorId;
  final String forumTitle;
  final String thoughtId;
  final bool isThoughtLike;
  final bool isThoughtReplied;
  final String thought;
  final Timestamp timestamp;
  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final String authorVerification;

  ActivityForum({
    required this.id,
    required this.fromUserId,
    required this.forumAuthorId,
    required this.forumId,
    required this.thoughtId,
    required this.isThoughtLike,
    required this.isThoughtReplied,
    required this.seen,
    required this.forumTitle,
    required this.thought,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory ActivityForum.fromDoc(DocumentSnapshot doc) {
    return ActivityForum(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      forumAuthorId: doc['forumAuthorId'],
      isThoughtLike: doc['isThoughtLike'],
      isThoughtReplied: doc['isThoughtReplied'],
      forumId: doc['forumId'],
      thoughtId: doc['thoughtId'],
      seen: doc['seen'],
      forumTitle: doc['forumTitle'],
      thought: doc['thought'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }
}
