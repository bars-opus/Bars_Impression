import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationActivityType {
  comment,
  ask,
  advice,
  newEventInNearYou,
  like,
  inviteRecieved,
  ticketPurchased,
  follow,
  eventUpdate,
  eventReminder,
  refundRequested,
}

class Activity {
  final String? id;
  final NotificationActivityType type;
  final String? postId;
  final String? postImageUrl;
  final String? comment;
  bool? seen;
  final String? authorId;
  final String authorName;
  final String authorProfileHandle;
  final String authorProfileImageUrl;
  final bool authorVerification;
  final Timestamp? timestamp;

  Activity({
    required this.id,
    required this.type,
    required this.authorId,
    required this.postId,
    required this.seen,
    required this.postImageUrl,
    required this.comment,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHandle,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.id,
      authorId: doc['authorId'] ?? '',
      type: _parseActivityType(doc['type']),
      postId: doc['postId'] ?? '',
      seen: doc['seen'] ?? false,
      postImageUrl: doc['postImageUrl'] ?? '',
      comment: doc['comment'],
      timestamp: doc['timestamp'] ?? DateTime.now(),
      authorName: doc['authorName'] ?? '',
      authorProfileHandle: doc['authorProfileHandle'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? false,
    );
  }
  static NotificationActivityType _parseActivityType(String value) {
    switch (value) {
      case 'comment':
        return NotificationActivityType.comment;
      case 'like':
        return NotificationActivityType.like;
      case 'follow':
        return NotificationActivityType.follow;
      case 'ask':
        return NotificationActivityType.ask;
      case 'advice':
        return NotificationActivityType.advice;
      case 'inviteRecieved':
        return NotificationActivityType.inviteRecieved;
      case 'newEventInNearYou':
        return NotificationActivityType.newEventInNearYou;
      case 'ticketPurchased':
        return NotificationActivityType.ticketPurchased;
      case 'eventUpdate':
        return NotificationActivityType.eventUpdate;
      case 'eventReminder':
        return NotificationActivityType.eventReminder;
      case 'refundRequested':
        return NotificationActivityType.refundRequested;
      default:
        return NotificationActivityType.eventUpdate;
    }
  }
}
