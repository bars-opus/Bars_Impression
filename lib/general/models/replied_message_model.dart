import 'package:hive_flutter/hive_flutter.dart';

part 'replied_message_model.g.dart';

@HiveType(typeId: 4) // Use unique IDs for different classes

class ReplyToMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String athorId;

  ReplyToMessage({
    required this.id,
    required this.message,
    required this.imageUrl,
    required this.athorId,
  });

  factory ReplyToMessage.fromMap(Map<String, dynamic> map) {
    return ReplyToMessage(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      athorId: map['athorId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'imageUrl': imageUrl,
      'athorId': athorId,
    };
  }
}
