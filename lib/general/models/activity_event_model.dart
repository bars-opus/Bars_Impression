import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityEvent {
  final String id;
  final String fromUserId;
  final String eventId;
  final String seen;
  final String eventImageUrl;
  final String eventTitle;
  final String ask;
  final Timestamp timestamp;

  ActivityEvent({
    required this.id,
    required this.fromUserId,
    required this.seen,
    required this.eventId,
    required this.eventImageUrl,
    required this.eventTitle,
    required this.ask,
    required this.timestamp,
  });

  factory ActivityEvent.fromDoc(DocumentSnapshot doc) {
    return ActivityEvent(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      eventId: doc['eventId'],
      eventImageUrl: doc['eventImageUrl'],
      seen: doc['seen'],
      eventTitle: doc['eventTitle'],
      ask: doc['ask'],
      timestamp: doc['timestamp'],
    );
  }
}
