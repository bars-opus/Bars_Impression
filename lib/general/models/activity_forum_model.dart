import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityForum {
  final String id;
  final String fromUserId;
  final String seen;
  final String forumId;
  final String forumTitle;
  final String thought;
  final Timestamp timestamp;

  ActivityForum({
    required this.id,
    required this.fromUserId,
    required this.forumId,
    required this.seen,
    required this.forumTitle,
    required this.thought,
    required this.timestamp,
  });

  factory ActivityForum.fromDoc(DocumentSnapshot doc) {
    return ActivityForum(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      forumId: doc['forumId'],
      seen: doc['seen'],
      forumTitle: doc['forumTitle'],
      thought: doc['thought'],
      timestamp: doc['timestamp'],
    );
  }
}
