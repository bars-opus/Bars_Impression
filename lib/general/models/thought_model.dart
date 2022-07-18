import 'package:cloud_firestore/cloud_firestore.dart';

class Thought {
  final String id;
  final String content;
  final String authorId;
  final String report;
  final int? count;
  final String reportConfirmed;
  final Timestamp timestamp;

  Thought({
    required this.id,
    required this.content,
    required this.authorId,
    required this.report,
    required this.count,
    required this.reportConfirmed,
    required this.timestamp,
  });

  factory Thought.fromDoc(DocumentSnapshot doc) {
    return Thought(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      count: doc['count'] ?? 0,
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
