import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityEvent {
  final String id;
  final String fromUserId;
  final String eventId;
  final String seen;
  final String eventImageUrl;
  final String eventTitle;
  final String commonId;
  final String toUserId;
  final String? ask;
  final bool? invited;
  final String? eventInviteType;
  final Timestamp? timestamp;
  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final String authorVerification;

  ActivityEvent({
    required this.id,
    required this.fromUserId,
    required this.seen,
    required this.eventId,
    required this.eventImageUrl,
    required this.eventTitle,
    required this.ask,
    required this.eventInviteType,
    required this.timestamp,
    required this.commonId,
    required this.invited,
    required this.toUserId,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory ActivityEvent.fromDoc(DocumentSnapshot doc) {
    return ActivityEvent(
      id: doc.id,
      fromUserId: doc['fromUserId'] ?? '',
      eventId: doc['eventId'] ?? '',
      eventImageUrl: doc['eventImageUrl'] ?? '',
      seen: doc['seen'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      eventInviteType: doc['eventInviteType'] ?? '',
      commonId: doc['commonId'] ?? '',
      toUserId: doc['toUserId'] ?? '',
      ask: doc['ask'],
      timestamp: doc['timestamp'] ?? '',
      invited: doc['invited'] ?? false,
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }
}
