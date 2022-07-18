import 'package:bars/utilities/exports.dart';

class Verification {
  final String id;
  final String userId;
  final String verificationType;
  final String legalName;
  final String govIdType;
  final String brandType;
  final String profileHandle;
  final String email;
  final String phoneNumber;
  final String gvIdImageUrl;
  final String brandAudienceCustomers;
  final String website;
  final String socialMedia;
  final String notableAricle1;
  final String notableAricle2;
  final Timestamp timestamp;

  Verification({
    required this.id,
    required this.userId,
    required this.verificationType,
    required this.legalName,
    required this.profileHandle,
    required this.brandType,
    required this.govIdType,
    required this.email,
    required this.phoneNumber,
    required this.gvIdImageUrl,
    required this.website,
    required this.brandAudienceCustomers,
    required this.socialMedia,
    required this.notableAricle1,
    required this.notableAricle2,
    required this.timestamp,
  });

  factory Verification.fromDoc(DocumentSnapshot doc) {
    return Verification(
      id: doc.id,
      userId: doc['userId'] ?? '',
      legalName: doc['legalName'] ?? '',
      verificationType: doc['verificationType'],
      brandType: doc['brandType'],
      govIdType: doc['govIdType'],
      email: doc['email'],
      profileHandle: doc['profileHandle'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? '',
      gvIdImageUrl: doc['gvIdImageUrl'] ?? '',
      website: doc['website'] ?? '',
      brandAudienceCustomers: doc['brandAudienceCustomers'] ?? '',
      socialMedia: doc['socialMedia'] ?? '',
      notableAricle1: doc['notableAricle1'] ?? '',
      notableAricle2: doc['notableAricle2'] ?? '',
      timestamp: doc['timestamp'] ?? '',
    );
  }
}
