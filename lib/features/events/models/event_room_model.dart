import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'event_room_model.g.dart';

@HiveType(typeId: 8) // Use unique IDs for different classes

class EventRoom {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String linkedEventId;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final Timestamp? timestamp;
  @HiveField(5)
  final String eventAuthorId;

  EventRoom({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.linkedEventId,
    required this.timestamp,
    required this.eventAuthorId,
  });

  factory EventRoom.fromDoc(DocumentSnapshot doc) {
    return EventRoom(
      id: doc.id,
      title: doc['title'],
      imageUrl: doc['imageUrl'] ?? '',
      linkedEventId: doc['linkedEventId'] ?? '',
      timestamp: doc['timestamp'],
      eventAuthorId: doc['eventAuthorId'],
    );
  }
}
