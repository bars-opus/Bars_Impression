import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModel {
  String id;
  String eventId;
  String status;
  String userRequestId;
  String eventTitle;

  String orderId;
  String city;
  final String transactionId;
  final String eventAuthorId;
  final String idempotencyKey;

  String reason;
  Timestamp approvedTimestamp;
  final Timestamp timestamp;

  RefundModel({
    required this.id,
    required this.eventId,
    required this.status,
    required this.userRequestId,
    required this.reason,
    required this.city,
    required this.approvedTimestamp,
    required this.timestamp,
    required this.transactionId,
    required this.orderId,
    required this.eventTitle,
    required this.eventAuthorId,
    required this.idempotencyKey,
  });

  factory RefundModel.fromDoc(DocumentSnapshot doc) {
    return RefundModel(
      eventId: doc['eventId']!,
      city: doc['city'] ?? '',
      reason: doc['reason'] ?? '',
      status: doc['status'] ?? '',
      idempotencyKey: doc['idempotencyKey'] ?? '',
      transactionId: doc['transactionId'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      orderId: doc['orderId'] ?? '',
      userRequestId: doc['userRequestId'] ?? '',
      eventAuthorId: doc['eventAuthorId'] ?? '',
      id: doc['id'] ?? '',
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      approvedTimestamp: doc['approvedTimestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
    );
  }

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      id: json['id'],
      eventId: json['eventId'],
      status: json['status'],
      transactionId: json['transactionId'],
      eventTitle: json['eventTitle'],
      orderId: json['orderId'],
      idempotencyKey: json['idempotencyKey'],
      city: json['city'],
      userRequestId: json['userRequestId'],
      eventAuthorId: json['eventAuthorId'],
      reason: json['reason'],
      approvedTimestamp: json['approvedTimestamp'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'status': status,
      'transactionId': transactionId,
      'eventTitle': eventTitle,
      'orderId': orderId,
      'userRequestId': userRequestId,
      'eventAuthorId': eventAuthorId,
      'idempotencyKey': idempotencyKey,
      'city': city,
      'reason': reason,
      'approvedTimestamp': approvedTimestamp,
      'timestamp': timestamp,
    };
  }
}
