import 'package:cloud_firestore/cloud_firestore.dart';

class AffiliateModel {
  String id;
  String eventId;
  String userId;
  String affiliateLink;
  final double affiliateAmount;
  final Timestamp timestamp;
  Timestamp affiliatePayoutDate;
  final Timestamp eventClossingDay;
  final String marketingType;
  final bool payoutToOrganizer;
  final String answer;

  final bool payoutToAffiliates;
  
  final double commissionRate;
  final int salesNumber;
  final String eventAuthorId;
  final String userProfileUrl;
  final String userName;
  final String message;
  final String termsAndCondition;

  final String eventImageUrl;
  final String eventTitle;

  AffiliateModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.affiliateLink,
    required this.userName,
    required this.commissionRate,
    required this.affiliatePayoutDate,
    required this.timestamp,
    required this.marketingType,
    required this.payoutToAffiliates,
    required this.payoutToOrganizer,
    required this.eventAuthorId,
    required this.salesNumber,
    required this.affiliateAmount,
    required this.userProfileUrl,
    required this.eventClossingDay,
    required this.eventImageUrl,
    required this.eventTitle,
    required this.answer,
    required this.message,
    required this.termsAndCondition,
  });

  factory AffiliateModel.fromDoc(DocumentSnapshot doc) {
    return AffiliateModel(
      eventId: doc['eventId']!,
      commissionRate: (doc['commissionRate'] as num?)?.toDouble() ?? 0.0,
      userName: doc['userName'] ?? '',
      userId: doc['userId'] ?? '',
      userProfileUrl: doc['userProfileUrl'] ?? '',
      salesNumber: doc['salesNumber'],
      marketingType: doc['marketingType'] ?? '',
      payoutToOrganizer: doc['payoutToOrganizer'] ?? false,
      payoutToAffiliates: doc['payoutToAffiliates'] ?? false,
      answer: doc['answer'] ?? '',
      affiliateLink: doc['affiliateLink'] ?? '',
      eventAuthorId: doc['eventAuthorId'] ?? '',
      affiliateAmount: (doc['affiliateAmount'] as num?)?.toDouble() ?? 0.0,
      id: doc['id'] ?? '',
      eventImageUrl: doc['eventImageUrl'] ?? '',
      message: doc['message'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      termsAndCondition: doc['termsAndCondition'] ?? '',
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      affiliatePayoutDate: doc['affiliatePayoutDate'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      eventClossingDay: doc['eventClossingDay'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
    );
  }

  factory AffiliateModel.fromJson(Map<String, dynamic> json) {
    return AffiliateModel(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      marketingType: json['marketingType'],
      payoutToOrganizer: json['payoutToOrganizer'],
      payoutToAffiliates: json['payoutToAffiliates'],
      answer: json['answer'],
      salesNumber: json['salesNumber'] ?? 0,
      commissionRate: json['commissionRate'] ?? 0.0,
      userProfileUrl: json['userProfileUrl'],
      affiliateLink: json['affiliateLink'],
      eventAuthorId: json['eventAuthorId'],
      eventImageUrl: json['eventImageUrl'],
      eventTitle: json['eventTitle'] ?? '',
      message: json['message'] ?? '',
      termsAndCondition: json['termsAndCondition'] ?? '',
      userName: json['userName'],
      affiliatePayoutDate: json['affiliatePayoutDate'],
      timestamp: json['timestamp'],
      affiliateAmount: json['affiliateAmount'] ?? 0.0,
      eventClossingDay:
          json['eventClossingDay'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'marketingType': marketingType,
      'payoutToOrganizer': payoutToOrganizer,
      'payoutToAffiliates': payoutToAffiliates,
      'answer': answer,
      'affiliateLink': affiliateLink,
      'eventAuthorId': eventAuthorId,
      'salesNumber': salesNumber,
      'commissionRate': commissionRate,
      'userProfileUrl': userProfileUrl,
      'affiliateAmount': affiliateAmount,
      'userName': userName,
      'affiliatePayoutDate': affiliatePayoutDate,
      'timestamp': timestamp,
      'eventClossingDay': eventClossingDay,
      'eventImageUrl': eventImageUrl,
      'eventTitle': eventTitle,
      'message': message,
      'termsAndCondition': termsAndCondition,
    };
  }
}
