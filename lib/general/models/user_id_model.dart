import 'package:cloud_firestore/cloud_firestore.dart';

class DocId {
  final String id;
  final String uid;

  DocId({
   required this.id,
   required this.uid,
  });

  factory DocId.fromDoc(DocumentSnapshot doc) {
    return DocId(
      id: doc.id,
      uid: doc['uid'],
    );
  }
}
