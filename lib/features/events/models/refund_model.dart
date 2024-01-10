import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModel {
  String id;
  String eventId;
  String status;
  String userRequestId;
  String city;

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
  });


  factory RefundModel.fromDoc(DocumentSnapshot doc) {
    return RefundModel(
      eventId: doc['eventId']!,
      city: doc['city'] ?? '',
      reason: doc['reason'] ?? '',
      status: doc['status'] ?? '',
      userRequestId: doc['userRequestId'] ?? '',
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
      city: json['city'],
      userRequestId: json['userRequestId'],
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
      'userRequestId': userRequestId,
      'city': city,
      'reason': reason,
      'approvedTimestamp': approvedTimestamp,
      'timestamp': timestamp,
    };
  }
}
