import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  String content;
  final String authorId;
  final String toUserId;
  final String fromUserId;
  final String replyingMessage;
  final String replyingAuthor;
  final String report;

  final String imageUrl;
  bool liked;
  final String reportConfirmed;
  final Timestamp timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.fromUserId,
    required this.toUserId,
    required this.authorId,
    required this.replyingAuthor,
    required this.replyingMessage,
    required this.imageUrl,
    required this.report,
    required this.liked,
    required this.reportConfirmed,
    required this.timestamp,
  });

  factory ChatMessage.fromDoc(DocumentSnapshot doc) {
    return ChatMessage(
      id: doc.id,
      content: doc['content'] ?? '',
      authorId: doc['authorId'] ?? '',
      fromUserId: doc['fromUserId'] ?? '',
      toUserId: doc['toUserId'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      report: doc['report'] ?? '',
      replyingAuthor: doc['replyingAuthor'] ?? '',
      replyingMessage: doc['replyingMessage'] ?? '',
      liked: doc['liked'] ?? false,
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
