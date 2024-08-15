import 'package:cloud_firestore/cloud_firestore.dart';

class BrandMatchingModel {
  final String skills;
  final String userId;
  final String shortTermGoals;
  final String longTermGoals;
  final String creativeStyle;
  final String userName;
  final String profileImageUrl;
  final String profileHandle;
  final bool verified;
  final String inspiration;
  String matchReason;

  BrandMatchingModel({
    required this.skills,
    required this.userId,
    required this.creativeStyle,
    required this.shortTermGoals,
    required this.inspiration,
    required this.matchReason,
    required this.longTermGoals,
    required this.userName,
    required this.profileImageUrl,
    required this.profileHandle,
    required this.verified,
  });

  factory BrandMatchingModel.fromDoc(DocumentSnapshot doc) {
    return BrandMatchingModel(
      skills: doc['skills'] ?? '',
      userId: doc['userId'] ?? '',
      creativeStyle: doc['creativeStyle'] ?? '',
      shortTermGoals: doc['shortTermGoals'] ?? '',
      inspiration: doc['inspiration'] ?? '',
      matchReason: doc['matchReason'] ?? '',
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      profileHandle: doc['profileHandle'] ?? 'Fan',
      verified: doc['verified'] ?? false,
      longTermGoals: doc['longTermGoals'] ?? '',
    );
  }

  factory BrandMatchingModel.fromJson(Map<String, dynamic> json) {
    return BrandMatchingModel(
      skills: json['skills'],
      userName: json['userName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      creativeStyle: json['creativeStyle'],
      userId: json['userId'],
      profileHandle: json['profileHandle'] ?? 'Fan',
      verified: json['verified'] ?? false,
      shortTermGoals: json['shortTermGoals'],
      inspiration: json['inspiration'],
      matchReason: json['matchReason'],
      longTermGoals: json['longTermGoals'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skills': skills,
      'userId': userId,
      'creativeStyle': creativeStyle,
      'shortTermGoals': shortTermGoals,
      'inspiration': inspiration,
      'matchReason': matchReason,
      'longTermGoals': longTermGoals,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'profileHandle': profileHandle,
      'verified': verified,
    };
  }
}
