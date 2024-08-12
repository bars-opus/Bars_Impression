import 'package:bars/utilities/exports.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 1) // Use unique IDs for different classes

class ChatMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String receiverId;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final Timestamp? timestamp;
  @HiveField(5)
  bool isLiked;
  @HiveField(6)
  bool isRead;
  @HiveField(7)
  bool isSent;
  @HiveField(8)
  final SendContentMessage? sendContent;
  @HiveField(9)
  final ReplyToMessage? replyToMessage;
  @HiveField(10)
  List<MessageAttachment> attachments;


  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.isSent,
    required this.isLiked,
    required this.sendContent,
    required this.replyToMessage,
    required this.attachments,
  });

  factory ChatMessage.fromDoc(DocumentSnapshot doc) {
    return ChatMessage(
      id: doc.id,
      senderId: doc['senderId'] ?? '',
      receiverId: doc['receiverId'] ?? '',
      content: doc['content'] ?? '',
      timestamp: doc['timestamp'] as Timestamp?,
      isRead: doc['isRead'] ?? false,
      isSent: doc['isSent'] ?? false,
      isLiked: doc['isLiked'] ?? false,
      sendContent: doc['sendContent'] != null
          ? SendContentMessage.fromMap(doc['sendContent'])
          : null,
      replyToMessage: doc['replyToMessage'] != null
          ? ReplyToMessage.fromMap(doc['replyToMessage'])
          : null,
      attachments: List<MessageAttachment>.from(doc['attachments']
              ?.map((attachments) => MessageAttachment.fromJson(attachments)) ??
          []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.receiverId == receiverId &&
        other.senderId == senderId &&
        other.content == content;

    // compare other fields...
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'isRead': isRead,
      'isSent': isSent,
      'attachments':
          attachments.map((attachment) => attachment.toJson()).toList(),
      'isLiked': isLiked,
      'sendContent': sendContent?.toMap(),
      'replyToMessage': replyToMessage?.toMap(),
    };
  }
}


