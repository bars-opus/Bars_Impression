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
  });

  factory InviteModel.fromDoc(DocumentSnapshot doc) {
    return InviteModel(
      eventId: doc['eventId']!,
      answer: doc['answer'] ?? '',
      generatedMessage: doc['generatedMessage'] ?? '',
      inviterMessage: doc['inviterMessage'] ?? '',
      inviteeId: doc['inviteeId'] ?? '',
      inviterId: doc['inviterId'] ?? '',
      isTicketPass: doc['isTicketPass'] ?? false,
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
      generatedMessage: json['generatedMessage']!,
      inviterMessage: json['inviterMessage']!,
      isTicketPass: json['isTicketPass']!,
      inviteeId: json['inviteeId']!,
      inviterId: json['inviterId']!,
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
      'generatedMessage': generatedMessage,
      'inviterMessage': inviterMessage,
      'isTicketPass': isTicketPass,
      'inviteeId': inviteeId,
      'inviterId': inviterId,
      'timestamp': timestamp,
      'eventTimestamp': eventTimestamp,
    };
  }
}
