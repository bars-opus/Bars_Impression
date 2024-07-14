import 'package:cloud_firestore/cloud_firestore.dart';

class ReportContents {
  final String id;
  final String contentId;
  final String parentContentId;
  final String authorId;
  final String repotedAuthorId;
  final String contentType;
  final String reportType;
  final String comment;
  final String reportConfirmation;
  final Timestamp timestamp;

  ReportContents({
    required this.contentId,
    required this.contentType,
    required this.reportType,
    required this.repotedAuthorId,
    required this.parentContentId,
    required this.reportConfirmation,
    required this.id,
    required this.authorId,
    required this.timestamp,
    required this.comment,
  });

  factory ReportContents.fromDoc(DocumentSnapshot doc) {
    return ReportContents(
      id: doc.id,
      contentId: doc['contentId'],
      contentType: doc['contentType'],
      repotedAuthorId: doc['repotedAuthorId'],
      parentContentId: doc['parentContentId'],
      reportType: doc['reportType'],
      reportConfirmation: doc['reportConfirmation'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      comment: doc['comment'],
    );
  }
}
