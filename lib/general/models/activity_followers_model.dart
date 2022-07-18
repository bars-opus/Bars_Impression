import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityFollower {
  final String id;
  final String fromUserId;
  final String userId;
  final String seen;
  final Timestamp timestamp;

  ActivityFollower({
required     this.id,
    required this.fromUserId,
    required this.userId,
    required this.seen,
    required this.timestamp,
  });

  factory ActivityFollower.fromDoc(DocumentSnapshot doc) {
    return ActivityFollower(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      userId: doc['userId'],
      seen: doc['seen'],
      timestamp: doc['timestamp'],
    );
  }
}
