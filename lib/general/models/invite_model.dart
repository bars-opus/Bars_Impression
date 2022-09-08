import 'package:cloud_firestore/cloud_firestore.dart';

class EventInvite {
  final String id;
  final String eventId;
  final String authorId;
  final String anttendeeId;
  final String anttendeeName;
  final String inviteeName;
  final String anttendeeprofileHandle;
  final String anttendeeprofileImageUrl;
  final String requestNumber;
  final String attendNumber;
  final String eventImageUrl;
  final String inviteStatus;
  final String attendeeStatus;
  final String message;
  final bool invited;
  final Timestamp? timestamp;

  EventInvite({
    required this.id,
    required this.eventId,
    required this.authorId,
    required this.anttendeeName,
    required this.anttendeeprofileHandle,
    required this.anttendeeprofileImageUrl,
    required this.anttendeeId,
    required this.requestNumber,
    required this.attendNumber,
    required this.eventImageUrl,
    required this.inviteStatus,
    required this.invited,
    required this.message,
    required this.inviteeName,
    required this.attendeeStatus,
    required this.timestamp,
  });

  factory EventInvite.fromDoc(DocumentSnapshot doc) {
    return EventInvite(
      id: doc.id,
      eventId: doc['eventId'],
      authorId: doc['authorId'],
      anttendeeName: doc['anttendeeName'],
      anttendeeprofileHandle: doc['anttendeeprofileHandle'],
      anttendeeprofileImageUrl: doc['anttendeeprofileImageUrl'],
      anttendeeId: doc['anttendeeId'],
      inviteStatus: doc['inviteStatus'] ?? '',
      attendeeStatus: doc['attendeeStatus'] ?? '',
      attendNumber: doc['attendNumber'] ?? '',
      inviteeName: doc['inviteeName'] ?? '',
      requestNumber: doc['requestNumber'] ?? '',
      message: doc['message'] ?? '',
      eventImageUrl: doc['eventImageUrl'] ?? '',
      invited: doc['invited'] ?? false,
      timestamp: doc['timestamp'],
    );
  }
}
