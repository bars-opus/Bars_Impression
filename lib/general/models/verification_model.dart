import 'package:bars/utilities/exports.dart';

class Verification {
  final String userId;
  final String verificationType;
  final String govIdType;
  final String profileHandle;
  final String email;
  final String phoneNumber;
  final String gvIdImageUrl;
  final String website;
  final String socialMedia;
  final String wikipedia;
  final String newsCoverage;
  final String otherLink;
  final String validationImage;
  final String status;
  final String rejectedReason;
  final Timestamp? timestamp;

  Verification({
    required this.userId,
    required this.verificationType,
    required this.profileHandle,
    required this.newsCoverage,
    required this.govIdType,
    required this.email,
    required this.phoneNumber,
    required this.gvIdImageUrl,
    required this.website,
    required this.otherLink,
    required this.socialMedia,
    required this.validationImage,
    required this.wikipedia,
    required this.status,
    required this.rejectedReason,
    required this.timestamp,
  });

  factory Verification.fromDoc(DocumentSnapshot doc) {
    return Verification(
      userId: doc['userId'] ?? '',
      verificationType: doc['verificationType'],
      wikipedia: doc['wikipedia'],
      govIdType: doc['govIdType'],
      email: doc['email'],
      profileHandle: doc['profileHandle'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? '',
      gvIdImageUrl: doc['gvIdImageUrl'] ?? '',
      website: doc['website'] ?? '',
      validationImage: doc['validationImage'] ?? '',
      socialMedia: doc['socialMedia'] ?? '',
      newsCoverage: doc['newsCoverage'] ?? '',
      otherLink: doc['otherLink'] ?? '',
      status: doc['status'] ?? '',
      rejectedReason: doc['rejectedReason'] ?? '',
      timestamp: doc['timestamp'] ?? '',
    );
  }
}
