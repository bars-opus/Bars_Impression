import 'package:bars/utilities/exports.dart';

class RatingModel {
  final String userId;
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;
  // final Timestamp timestamp;

  RatingModel({
    required this.userId,
    required this.oneStar,
    required this.twoStar,
    required this.fourStar,
    // required this.timestamp,
    required this.threeStar,
    required this.fiveStar,
  });

  factory RatingModel.fromDoc(DocumentSnapshot doc) {
    return RatingModel(
      userId: doc.id,
      oneStar: doc['oneStar'] ?? 0,
      twoStar: doc['twoStar'] ?? 0,
      fourStar: doc['fourStar'] ?? 0,
      threeStar: doc['threeStar'] ?? 0,
      fiveStar: doc['fiveStar'] ?? 0,
    );
  }

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: json['userId'],
      oneStar: json['oneStar'],
      twoStar: json['twoStar'],
      fourStar: json['fourStar'],
      // timestamp: json['timestamp'],
      threeStar: json['threeStar'],
      fiveStar: json['fiveStar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'oneStar': oneStar,
      'twoStar': twoStar,
      'fourStar': fourStar,
      // 'timestamp': timestamp,
      'threeStar': threeStar,
      'fiveStar': fiveStar,
    };
  }
}
