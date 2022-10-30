import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String fromUserId;
  final String lastMessage;
  final String messageInitiator;
  final String firstMessage;
  final String toUserId;
  final String seen;
  final String mediaType;
  final bool restrictChat;
  final bool disableChat;
  final Timestamp newMessageTimestamp;
  final Timestamp timestamp;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.messageInitiator,
    required this.firstMessage,
    required this.seen,
    required this.fromUserId,
    required this.mediaType,
    required this.restrictChat,
    required this.newMessageTimestamp,
    required this.toUserId,
    required this.timestamp,
    required this.disableChat,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      lastMessage: doc['lastMessage'] ?? '',
      seen: doc['seen'] ?? '',
      fromUserId: doc['fromUserId'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      messageInitiator: doc['messageInitiator'] ?? '',
      firstMessage: doc['firstMessage'] ?? '',
      restrictChat: doc['restrictChat'] ?? false,
      disableChat: doc['disableChat'] ?? false,
      newMessageTimestamp: doc['newMessageTimestamp'],
      toUserId: doc['toUserId'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
