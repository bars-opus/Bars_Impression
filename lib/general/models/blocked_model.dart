import 'package:cloud_firestore/cloud_firestore.dart';

class Blocked {
  final String id;
  final String fromUserId;
  final String blockedUserId;
  final Timestamp timestamp;

  Blocked( {
    required this.id,
    required this.fromUserId,
   required this.blockedUserId,
    required this.timestamp,
  });

  factory Blocked.fromDoc(DocumentSnapshot doc) {
    return Blocked(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      blockedUserId: doc['blockedUserId'],
      timestamp: doc['timestamp'],
    );
  }
}
