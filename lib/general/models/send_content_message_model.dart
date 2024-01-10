import 'package:hive_flutter/hive_flutter.dart';

import 'package:json_annotation/json_annotation.dart';

part 'send_content_message_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2) // Use unique IDs for different classes

class SendContentMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String type;

  SendContentMessage({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.type,
  });

  factory SendContentMessage.fromMap(Map<String, dynamic> map) {
    return SendContentMessage(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'type': type,
    };
  }
}
