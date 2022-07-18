import 'package:cloud_firestore/cloud_firestore.dart';

class Ask {
  final String id;
  final String content;
  final String authorId;
   final String report;
  final String reportConfirmed;
  final Timestamp timestamp;

  Ask({
    required this.id,
    required this.content,
    required this.authorId,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
  });

  factory Ask.fromDoc(DocumentSnapshot doc) {
    return Ask(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
       report: doc['report']?? '',
      reportConfirmed: doc['reportConfirmed']?? '',
      timestamp: doc['timestamp'],
    );
  }
}
