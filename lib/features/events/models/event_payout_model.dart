import 'package:cloud_firestore/cloud_firestore.dart';

class EventPayoutModel {
  String id;
  String eventId;
  String status;
  String subaccountId;
  String eventTitle;
  // String city;
  final String transferRecepientId;
  final String eventAuthorId;
  final String idempotencyKey;

  // String reason;
  // Timestamp approvedTimestamp;
  final Timestamp timestamp;

  EventPayoutModel({
    required this.id,
    required this.eventId,
    required this.status,
    required this.subaccountId,
    // required this.reason,
    // required this.city,
    // required this.approvedTimestamp,
    required this.timestamp,
    required this.transferRecepientId,
    required this.eventTitle,
    required this.eventAuthorId,
    required this.idempotencyKey,
  });

  factory EventPayoutModel.fromDoc(DocumentSnapshot doc) {
    return EventPayoutModel(
      eventId: doc['eventId']!,
      // city: doc['city'] ?? '',
      // reason: doc['reason'] ?? '',
      status: doc['status'] ?? '',
      idempotencyKey: doc['idempotencyKey'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      subaccountId: doc['subaccountId'] ?? '',
      eventAuthorId: doc['eventAuthorId'] ?? '',
      id: doc['id'] ?? '',
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      // approvedTimestamp: doc['approvedTimestamp'] ??
      //     Timestamp.fromDate(
      //       DateTime.now(),
      //     ),
    );
  }

  factory EventPayoutModel.fromJson(Map<String, dynamic> json) {
    return EventPayoutModel(
      id: json['id'],
      eventId: json['eventId'],
      status: json['status'],
      transferRecepientId: json['transferRecepientId'],
      eventTitle: json['eventTitle'],
      idempotencyKey: json['idempotencyKey'],
      // city: json['city'],
      subaccountId: json['subaccountId'],
      eventAuthorId: json['eventAuthorId'],
      // reason: json['reason'],
      // approvedTimestamp: json['approvedTimestamp'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'status': status,
      'transferRecepientId': transferRecepientId,
      'eventTitle': eventTitle,
      'subaccountId': subaccountId,
      'eventAuthorId': eventAuthorId,
      'idempotencyKey': idempotencyKey,
      // 'city': city,
      // 'reason': reason,
      // 'approvedTimestamp': approvedTimestamp,
      'timestamp': timestamp,
    };
  }
}
