import 'package:cloud_firestore/cloud_firestore.dart';

class Ask {
  final String id;
  final String content;
  final String authorId;
  final String report;
  final String mediaType;
  final String mediaUrl;
  final String reportConfirmed;
  final Timestamp timestamp;
  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final String authorVerification;

  Ask({
    required this.id,
    required this.content,
    required this.authorId,
    required this.mediaType,
    required this.mediaUrl,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory Ask.fromDoc(DocumentSnapshot doc) {
    return Ask(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }
}
