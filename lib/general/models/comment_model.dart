import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final String authorId;
  final String report;
  final String mediaType;
  final String mediaUrl;
  final String reportConfirmed;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.mediaType,
    required this.mediaUrl,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
