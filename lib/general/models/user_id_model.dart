import 'package:cloud_firestore/cloud_firestore.dart';

class DocId {
  final String id;
  final String userId;

  DocId({
    required this.id,
    required this.userId,
  });

  factory DocId.fromDoc(DocumentSnapshot doc) {
    return DocId(
      id: doc.id,
      userId: doc['userId'],
    );
  }
}
