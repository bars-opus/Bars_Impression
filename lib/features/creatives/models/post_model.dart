import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String imageUrl;
  final String caption;
  final String hashTag;
  final String authorId;
  final String authorName;
  final String storeType;
  final String authorIdProfileImageUrl;
  final bool authorVerification;
  final String reportConfirmed;
  final String report;
  final String blurHash;
  // final int likeCount;
  final Timestamp? timestamp;

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.hashTag,
    required this.authorId,
    required this.authorName,
    required this.storeType,
    required this.authorIdProfileImageUrl,
    required this.authorVerification,
    required this.report,
    required this.timestamp,
    required this.blurHash,
    required this.reportConfirmed,
    // required this.likeCount,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      imageUrl: doc['imageUrl'] ?? '',
      caption: doc['caption'] ?? '',
      hashTag: doc['hashTag'] ?? '',
      authorId: doc['authorId'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      report: doc['report'] ?? '',
      blurHash: doc['blurHash'] ?? '',
      // // likeCount: doc['likeCount'] ?? 0,
      timestamp: doc['timestamp'],
      storeType: doc['storeType'],
      authorIdProfileImageUrl: doc['authorIdProfileImageUrl'],
      authorName: doc['authorName'],
      authorVerification: doc['authorVerification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'caption': caption,
      'hashTag': hashTag,
      'authorId': authorId,
      'authorName': authorName,
      'storeType': storeType,
      // // 'likeCount': likeCount,
      'authorIdProfileImageUrl': authorIdProfileImageUrl,
      'authorVerification': authorVerification,
      'reportConfirmed': reportConfirmed,
      'report': report,
      'blurHash': blurHash,
      'timestamp': timestamp,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      hashTag: json['hashTag'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      storeType: json['storeType'] ?? '',
      // // likeCount: json['likeCount'] ?? '',
      authorIdProfileImageUrl: json['authorIdProfileImageUrl'] ?? '',
      authorVerification: json['authorVerification'] ?? false,
      reportConfirmed: json['reportConfirmed'] ?? '',
      report: json['report'] ?? '',
      blurHash: json['blurHash'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}
