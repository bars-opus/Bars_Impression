import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyThought {
  final String id;
  final String content;
  final String authorId;
  final String report;
  final String mediaType;
  final String mediaUrl;
  final String reportConfirmed;
  final Timestamp timestamp;

  ReplyThought({
    required this.id,
    required this.content,
    required this.authorId,
    required this.mediaType,
    required this.mediaUrl,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
  });

  factory ReplyThought.fromDoc(DocumentSnapshot doc) {
    return ReplyThought(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
