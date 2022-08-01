import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteDeactivate {
  final String id;
  final String author;
  final String reason;

  final Timestamp timestamp;

  DeleteDeactivate({
    required this.id,
    required this.author,
    required this.reason,
    required this.timestamp,
  });

  factory DeleteDeactivate.fromDoc(DocumentSnapshot doc) {
    return DeleteDeactivate(
      id: doc.id,
      author: doc['author'],
      reason: doc['reason'],
      timestamp: doc['timestamp'],
    );
  }
}
