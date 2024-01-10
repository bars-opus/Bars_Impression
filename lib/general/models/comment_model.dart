import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String authorProfileHandle;
  final String authorProfileImageUrl;
  final String authorVerification;
  final String report;
  final String reportConfirmed;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHandle,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorProfileHandle: doc['authorProfileHandle'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'authorId': authorId,
      'report': report,
      'reportConfirmed': reportConfirmed,
      'timestamp': timestamp,
      'authorName': authorName,
      'authorProfileHandle': authorProfileHandle,
      'authorProfileImageUrl': authorProfileImageUrl,
      'authorVerification': authorVerification,
    };
  }
}
