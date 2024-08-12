import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  final String id;
  final String suggesttion;
  final String authorId;
  final Timestamp timestamp;

  Suggestion({
    required this.suggesttion,
    required this.id,
    required this.authorId,
    required this.timestamp,
  });

  factory Suggestion.fromDoc(DocumentSnapshot doc) {
    return Suggestion(
      id: doc.id,
      suggesttion: doc['suggesttion'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
