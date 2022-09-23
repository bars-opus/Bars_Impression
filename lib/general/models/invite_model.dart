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
  final String commonId;
  final String personnelStatus;
  final bool? invited;
  final bool? validated;
  final Timestamp? timestamp;
  final Timestamp? eventTimestamp;

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
    required this.validated,
    required this.attendeeStatus,
    required this.timestamp,
    required this.personnelStatus,
    required this.eventTimestamp,
    required this.commonId,
  });

  factory EventInvite.fromDoc(DocumentSnapshot doc) {
    return EventInvite(
      id: doc.id,
      eventId: doc['eventId'],
      authorId: doc['authorId'],
      commonId: doc['commonId'],
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
      personnelStatus: doc['personnelStatus'] ?? '',
      eventImageUrl: doc['eventImageUrl'] ?? '',
      invited: doc['invited'] ?? false,
      validated: doc['validated'] ?? false,
      timestamp: doc['timestamp'],
      eventTimestamp: doc['eventTimestamp'],
    );
  }
}
