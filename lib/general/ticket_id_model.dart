import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'ticket_id_model.g.dart';

@HiveType(typeId: 9) // Use unique IDs for different classes

class TicketIdModel {
  @HiveField(0)
  final String eventId;
  @HiveField(1)
  final bool isNew;
  @HiveField(2)
  final Timestamp? timestamp;
  @HiveField(3)
  final String lastMessage;
  @HiveField(4)
  final bool muteNotification;
  @HiveField(5)
  final bool isSeen;

  TicketIdModel({
    required this.eventId,
    required this.isNew,
    required this.timestamp,
    required this.lastMessage,
    required this.muteNotification,
    required this.isSeen,
  });

  factory TicketIdModel.fromDoc(DocumentSnapshot doc) {
    return TicketIdModel(
      eventId: doc['eventId'],
      lastMessage: doc['lastMessage'],
      muteNotification: doc['muteNotification'],
      isNew: doc['isNew'],
      isSeen: doc['isSeen'],
      timestamp: doc['timestamp'] as Timestamp?,
    );
  }
}
