import 'package:cloud_firestore/cloud_firestore.dart';

class Forum {
  final String id;
  final String title;
  final String subTitle;
  final String report;
  final String reportConfirmed;
  final String authorId;
  final Timestamp timestamp;

  Forum(
       {required this.id,
      required this.title,
      required this.subTitle,
      required this.report,
      required this.reportConfirmed,
      required this.authorId,
      required this.timestamp});

  factory Forum.fromDoc(DocumentSnapshot doc) {
    return Forum(
      id: doc.id,
      title: doc['title'],
      subTitle: doc['subTitle'],
      authorId: doc['authorId'],
      report: doc['report']?? '',
      reportConfirmed: doc['reportConfirmed']?? '',
      timestamp: doc['timestamp'],
    );
  }
}
