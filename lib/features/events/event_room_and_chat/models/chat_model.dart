import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 6) // Use unique IDs for different classes

class Chat {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fromUserId;
  @HiveField(2)
  String lastMessage;
  @HiveField(3)
  final String messageInitiator;
  @HiveField(4)
  final String firstMessage;
  @HiveField(5)
  final String toUserId;
  @HiveField(6)
  final bool seen;
  @HiveField(7)
  final String mediaType;
  @HiveField(8)
  final bool restrictChat;
  @HiveField(9)
  final String messageId;
  @HiveField(10)
  Timestamp? newMessageTimestamp;
  @HiveField(11)
  final Timestamp? timestamp;
  @HiveField(12)
  final bool muteMessage;
  //  @HiveField(13)
  // Timestamp? clientTimestamp;


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
    required this.messageId,
    required this.muteMessage,
    //  required this.clientTimestamp,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      lastMessage: doc['lastMessage'] ?? '',
      seen: doc['seen'] ?? false,
      fromUserId: doc['fromUserId'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      messageInitiator: doc['messageInitiator'] ?? '',
      firstMessage: doc['firstMessage'] ?? '',
      restrictChat: doc['restrictChat'] ?? false,
      muteMessage: doc['muteMessage'] ?? false,
      // 'timestamp':timestamp ?? FieldValue.serverTimestamp(),
      newMessageTimestamp: doc['newMessageTimestamp'] as Timestamp?,
      //  clientTimestamp: doc['clientTimestamp'] as Timestamp?,

      
      toUserId: doc['toUserId'] ?? '',
      timestamp: doc['timestamp'] as Timestamp?,
      messageId: doc['messageId'] ?? '',
    );
  }
}
