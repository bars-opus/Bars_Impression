import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdvice {
  final String id;
  final String content;
  final String authorId;
  final String report;
  final String reportConfirmed;
  final Timestamp timestamp;
  final String authorName;
  final String authorshopType;
  final String authorProfileImageUrl;
  final bool authorVerification;

  UserAdvice({
    required this.id,
    required this.content,
    required this.authorId,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
    required this.authorName,
    required this.authorshopType,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory UserAdvice.fromDoc(DocumentSnapshot doc) {
    return UserAdvice(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorshopType: doc['authorshopType'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? false,
    );
  }
}
