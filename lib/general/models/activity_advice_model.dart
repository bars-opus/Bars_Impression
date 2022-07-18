import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityAdvice {
  final String id;
  final String fromUserId;
  final String userId;
  final String advice;
  final String seen;
  final Timestamp timestamp;

  ActivityAdvice({
   required this.id,
   required this.fromUserId,
   required this.userId,
   required this.seen,
   required this.advice,
   required this.timestamp,
  });

  factory ActivityAdvice.fromDoc(DocumentSnapshot doc) {
    return ActivityAdvice(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      userId: doc['userId'],
      seen: doc['seen'],
      advice: doc['advice'],
      timestamp: doc['timestamp'],
    );
  }
}
