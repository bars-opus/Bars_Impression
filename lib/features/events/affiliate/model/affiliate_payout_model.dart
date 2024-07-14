import 'package:cloud_firestore/cloud_firestore.dart';

class AffiliatePayoutModel {
  String id;
  String eventId;
  String status;
  String subaccountId;
  String eventTitle;
  final String transferRecepientId;
  final String eventAuthorId;
  final String idempotencyKey;
  final double total;
  Timestamp clossingDay;
  final Timestamp timestamp;
  final String affiliateId;

  AffiliatePayoutModel({
    required this.id,
    required this.eventId,
    required this.status,
    required this.subaccountId,
    required this.total,
    required this.clossingDay,
    required this.timestamp,
    required this.transferRecepientId,
    required this.eventTitle,
    required this.eventAuthorId,
    required this.idempotencyKey,
    required this.affiliateId,
  });

  factory AffiliatePayoutModel.fromDoc(DocumentSnapshot doc) {
    return AffiliatePayoutModel(
      eventId: doc['eventId']!,
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
      affiliateId: doc['affiliateId'] ?? '',
    );
  }

  factory AffiliatePayoutModel.fromJson(Map<String, dynamic> json) {
    return AffiliatePayoutModel(
      id: json['id'],
      eventId: json['eventId'],
      status: json['status'],
      transferRecepientId: json['transferRecepientId'],
      eventTitle: json['eventTitle'],
      idempotencyKey: json['idempotencyKey'],
      subaccountId: json['subaccountId'],
      eventAuthorId: json['eventAuthorId'],
      clossingDay: json['clossingDay'],
      timestamp: json['timestamp'],
      total: json['total'] ?? 0.0,
      affiliateId: json['affiliateId'],
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
      'clossingDay': clossingDay,
      'timestamp': timestamp,
      'affiliateId': affiliateId,
    };
  }
}
