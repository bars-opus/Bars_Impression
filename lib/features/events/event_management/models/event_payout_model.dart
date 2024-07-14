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
  final double total;

  // String reason;
  Timestamp clossingDay;
  final Timestamp timestamp;
  final double totalAffiliateAmount;

  EventPayoutModel({
    required this.id,
    required this.eventId,
    required this.status,
    required this.subaccountId,
    required this.total,

    // required this.reason,
    // required this.city,
    required this.clossingDay,
    required this.timestamp,
    required this.transferRecepientId,
    required this.eventTitle,
    required this.eventAuthorId,
    required this.idempotencyKey,
    required this.totalAffiliateAmount,
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
      total: (doc['total'] as num?)?.toDouble() ?? 0.0,
      id: doc['id'] ?? '',
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      clossingDay: doc['clossingDay'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      totalAffiliateAmount: doc['totalAffiliateAmount'].toDouble(),
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
      clossingDay: json['clossingDay'],
      timestamp: json['timestamp'],
      total: json['total'] ?? 0.0,
      totalAffiliateAmount: (json['totalAffiliateAmount'] as num).toDouble(),
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
      'total': total,
      // 'city': city,
      // 'reason': reason,
      'clossingDay': clossingDay,
      'timestamp': timestamp,
      'totalAffiliateAmount': totalAffiliateAmount,
    };
  }
}
