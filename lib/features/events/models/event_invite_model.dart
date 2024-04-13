import 'package:bars/utilities/exports.dart';

class InviteModel {
  final String inviteeId;
  final String inviterId;
  final String eventId;
  final String generatedMessage;
  final String inviterMessage;
  final String answer;
  final bool isTicketPass;
  final Timestamp? timestamp;
  final Timestamp? eventTimestamp;
  final String? eventTitle;
  final String refundRequestStatus;
  final bool isDeleted;

  InviteModel({
    required this.answer,
    required this.eventId,
    required this.eventTimestamp,
    required this.generatedMessage,
    required this.inviteeId,
    required this.inviterId,
    required this.timestamp,
    required this.inviterMessage,
    required this.isTicketPass,
    required this.eventTitle,
    required this.refundRequestStatus,
    required this.isDeleted,
  });

  factory InviteModel.fromDoc(DocumentSnapshot doc) {
    return InviteModel(
      eventId: doc['eventId']!,
      answer: doc['answer'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      generatedMessage: doc['generatedMessage'] ?? '',
      inviterMessage: doc['inviterMessage'] ?? '',
      inviteeId: doc['inviteeId'] ?? '',
      inviterId: doc['inviterId'] ?? '',
      refundRequestStatus: doc['refundRequestStatus'] ?? '',
      isTicketPass: doc['isTicketPass'] ?? false,
      isDeleted: doc['isDeleted'] ?? false,
      eventTimestamp: doc['eventTimestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
    );
  }

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      eventId: json['eventId']!,
      answer: json['answer']!,
      eventTitle: json['eventTitle']!,
      generatedMessage: json['generatedMessage']!,
      inviterMessage: json['inviterMessage']!,
      refundRequestStatus: json['refundRequestStatus']!,
      isTicketPass: json['isTicketPass']!,
      inviteeId: json['inviteeId']!,
      inviterId: json['inviterId']!,
      isDeleted: json['isDeleted'] ?? false,
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      eventTimestamp: json['eventTimestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['eventTimestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'answer': answer,
      'eventTitle': eventTitle,
      'refundRequestStatus': refundRequestStatus,
      'generatedMessage': generatedMessage,
      'inviterMessage': inviterMessage,
      'isTicketPass': isTicketPass,
      'inviteeId': inviteeId,
      'inviterId': inviterId,
      'timestamp': timestamp,
      'isDeleted': isDeleted,
      'eventTimestamp': eventTimestamp,
    };
  }
}
