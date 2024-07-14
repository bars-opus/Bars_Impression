import 'package:bars/utilities/exports.dart';

class EventRoomMessageModel {
  final String id;
  final String senderId;
  final String eventId;
  final String content;
  final Timestamp? timestamp;
  bool isLiked;
  bool isRead;
  bool isSent;
  final SendContentMessage? sendContent;
  final ReplyToMessage? replyToMessage;
  List<MessageAttachment> attachments;

  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final bool authorVerification;

  EventRoomMessageModel({
    required this.id,
    required this.senderId,
    required this.eventId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.isSent,
    required this.isLiked,
    required this.sendContent,
    required this.replyToMessage,
    required this.attachments,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory EventRoomMessageModel.fromDoc(DocumentSnapshot doc) {
    return EventRoomMessageModel(
      id: doc.id,
      senderId: doc['senderId'] ?? '',
      eventId: doc['eventId'] ?? '',
      content: doc['content'] ?? '',
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? false,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'eventId': eventId,
      'content': content,
      'authorName': authorName,
      'authorProfileHanlde': authorProfileHanlde,
      'authorProfileImageUrl': authorProfileImageUrl,
      'authorVerification': authorVerification,
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




