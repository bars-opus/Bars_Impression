import 'package:bars/utilities/exports.dart';

class ReviewModel {
  final String bookingId;
  final String reviewingId;
  final String revierwerId;
  final String comment;

  final int rating;
  final Timestamp timestamp;

  ReviewModel({
    required this.bookingId,
    required this.comment,
    required this.reviewingId,
    required this.rating,
    required this.timestamp,
    required this.revierwerId,
  });

  factory ReviewModel.fromDoc(DocumentSnapshot doc) {
    return ReviewModel(
      bookingId: doc['bookingId'] ?? '',
      comment: doc['comment'] ?? '',
      reviewingId: doc['reviewingId'] ?? '',
      rating: doc['rating'] ?? 0,
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      revierwerId: doc['revierwerId'] ?? '',
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      bookingId: json['bookingId'],
      comment: json['comment'],
      reviewingId: json['reviewingId'],
      rating: json['rating'],
      timestamp: json['timestamp'],
      revierwerId: json['revierwerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'comment': comment,
      'reviewingId': reviewingId,
      'rating': rating,
      'timestamp': timestamp,
      'revierwerId': revierwerId,
    };
  }
}
