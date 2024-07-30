import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  String id;
  String donerId;
  String receiverId;
  final double amount;
  final Timestamp timestamp;
  final String reason;
  final String userName;

  DonationModel({
    required this.id,
    required this.donerId,
    required this.receiverId,
    required this.userName,
    required this.timestamp,
    required this.reason,
    required this.amount,
  });

  factory DonationModel.fromDoc(DocumentSnapshot doc) {
    return DonationModel(
      userName: doc['userName'] ?? '',
      donerId: doc['donerId'] ?? '',
      reason: doc['reason'] ?? '',
      receiverId: doc['receiverId'] ?? '',
      amount: (doc['amount'] as num?)?.toDouble() ?? 0.0,
      id: doc['id'] ?? '',
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
    );
  }

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'],
      donerId: json['donerId'],
      reason: json['reason'],
      receiverId: json['receiverId'],
      userName: json['userName'],
      timestamp: json['timestamp'],
      amount: json['amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donerId': donerId,
      'reason': reason,
      'receiverId': receiverId,
      'amount': amount,
      'userName': userName,
      'timestamp': timestamp,
    };
  }
}
