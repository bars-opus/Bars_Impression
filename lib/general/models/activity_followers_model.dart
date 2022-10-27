import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityFollower {
  final String id;
  final String fromUserId;
  final String userId;
  final String seen;
  final Timestamp timestamp;
  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final String authorVerification;

  ActivityFollower({
    required this.id,
    required this.fromUserId,
    required this.userId,
    required this.seen,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory ActivityFollower.fromDoc(DocumentSnapshot doc) {
    return ActivityFollower(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      userId: doc['userId'],
      seen: doc['seen'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }
}


