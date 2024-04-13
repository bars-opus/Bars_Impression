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
  final String expectedDate;

  final double amount;

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
    required this.amount,
    required this.expectedDate,
  });

  factory RefundModel.fromDoc(DocumentSnapshot doc) {
    return RefundModel(
      eventId: doc['eventId']!,
      city: doc['city'] ?? '',
      reason: doc['reason'] ?? '',
      status: doc['status'] ?? '',
      expectedDate: doc['expectedDate'] ?? '',
      idempotencyKey: doc['idempotencyKey'] ?? '',
      transactionId: doc['transactionId'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      orderId: doc['orderId'] ?? '',
      userRequestId: doc['userRequestId'] ?? '',
      eventAuthorId: doc['eventAuthorId'] ?? '',
      amount: (doc['amount'] as num?)?.toDouble() ?? 0.0,
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
      expectedDate: json['expectedDate'],
      userRequestId: json['userRequestId'],
      eventAuthorId: json['eventAuthorId'],
      reason: json['reason'],
      approvedTimestamp: json['approvedTimestamp'],
      timestamp: json['timestamp'],
      amount: json['amount'] ?? 0.0,
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
      'expectedDate': expectedDate,
      'amount': amount,
      'reason': reason,
      'approvedTimestamp': approvedTimestamp,
      'timestamp': timestamp,
    };
  }
}
