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

  // final String id;
  // final String senderId;
  // final String receiverId;
  // final String content;
  // final Timestamp? timestamp;
  // bool isLiked;
  // bool isRead;
  // bool isSent;
  // final SendContentMessage? sendContent;
  // final ReplyToMessage? replyToMessage;
  // List<MessageAttachment> attachments;
  //   @HiveField(0)

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






// class ChatMessage {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final String gifUrl;
//   final String emoji;
//   // int likes;
//   // List<String> readBy;
//   final Timestamp timestamp;
//   final String conversationId;
//   bool isLiked;
//   bool isRead;
//   bool isSent;
//   String replyTo;
//   String replyToId;
//   String isReplyToUserId;

//   List<String> attachments;
//   // final String replyingMessage;
//   // final String replyingAuthor;
//   final String sendContentId;
//   final String sendContentTitle;
//   final String sendPostType;

//   ChatMessage({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     // required this.replyingMessage,
//     // required this.replyingAuthor,
//     required this.sendContentId,
//     required this.sendContentTitle,
//     required this.sendPostType,
//     this.gifUrl = '',
//     this.emoji = '',
//     // this.likes = 0,
//     // this.readBy = const [],
//     required this.timestamp,
//     required this.conversationId,
//     this.isRead = false,
//     this.isSent = false,
//     this.isLiked = false,
//     this.replyTo = '',
//     this.replyToId = '',
//     this.isReplyToUserId = '',
//     this.attachments = const [],
//   });

//   factory ChatMessage.fromDoc(DocumentSnapshot doc) {
//     return ChatMessage(
//       id: doc.id,
//       senderId: doc['senderId'] ?? '',
//       receiverId: doc['receiverId'] ?? '',
//       content: doc['content'] ?? '',
//       gifUrl: doc['gifUrl'] ?? '',
//       emoji: doc['emoji'] ?? '',
//       // likes: doc['likes'] ?? 0,
//       // readBy: List<String>.from(doc['readBy']),
//       timestamp: doc['timestamp'],
//       conversationId: doc['conversationId'],
//       isRead: doc['isRead'] ?? false,
//       isSent: doc['isSent'] ?? false,
//       isLiked: doc['isLiked'] ?? false,
//       isReplyToUserId: doc['isReplyToUserId'] ?? '',
//       replyTo: doc['replyTo'] ?? '',
//       replyToId: doc['replyToId'] ?? '',
//       attachments: List<String>.from(doc['attachments']),
//       // replyingAuthor: doc['replyingAuthor'] ?? '',
//       // replyingMessage: doc['replyingMessage'] ?? '',
//       sendContentId: doc['sendContentId'] ?? '',
//       sendContentTitle: doc['sendContentTitle'] ?? '',
//       sendPostType: doc['sendPostType'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'content': content,
//       'gifUrl': gifUrl,
//       'emoji': emoji,
//       // 'likes': likes,
//       // 'readBy': readBy,
//       'timestamp': timestamp,
//       'conversationId': conversationId,
//       'isRead': isRead,
//       'isSent': isSent,
//       'replyTo': replyTo,
//       'isReplyToUserId': isReplyToUserId,
//       'replyToId': replyToId,
//       'attachments': attachments,
//       'isLiked': isLiked,
//       // 'replyingAuthor': replyingAuthor,
//       // 'replyingMessage': replyingMessage,
//       'sendContentId': sendContentId,
//       'sendContentTitle': sendContentTitle,
//       'sendPostType': sendPostType,
//     };
//   }
// }








  // final String imageUrl;
  // bool liked;
  // final String reportConfirmed;
  // final Timestamp timestamp;
  // final String id;
  // String content;
  // final String authorId;
  // final String toUserId;
  // final String fromUserId;
  // final String report;
  // final String mediaType;
  // final String mediaUrl;


   // this.imageUrl = '',
    // required this.mediaType,
    // required this.content,
    // required this.fromUserId,
    // required this.toUserId,
    // required this.authorId,
    // required this.replyingAuthor,
    // required this.replyingMessage,
    // required this.mediaUrl,
    // required this.report,
    // required this.liked,
    // required this.reportConfirmed,
    // required this.sendContentId,
    // required this.sendContentTitle,
    // required this.sendPostType,
    // required this.timestamp,


      // content: doc['content'] ?? '',
      // authorId: doc['authorId'] ?? '',
      // fromUserId: doc['fromUserId'] ?? '',
      // toUserId: doc['toUserId'] ?? '',
      // mediaUrl: doc['mediaUrl'] ?? '',
      // report: doc['report'] ?? '',
      // mediaType: doc['mediaType'] ?? '',
      // sendContentId: doc['sendContentId'] ?? '',
      // sendPostType: doc['sendPostType'] ?? '',
      // replyingAuthor: doc['replyingAuthor'] ?? '',
      // replyingMessage: doc['replyingMessage'] ?? '',
      // liked: doc['liked'] ?? false,
      // reportConfirmed: doc['reportConfirmed'] ?? '',
      // timestamp: doc['timestamp'],
      // sendContentTitle: doc['sendContentTitle'] ?? '',
