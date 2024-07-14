import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_attachement_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3) // Use unique IDs for different classes

class MessageAttachment {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String mediaUrl;
  @HiveField(2)
  final String type;

  MessageAttachment({
    required this.id,
    required this.mediaUrl,
    required this.type,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'],
      mediaUrl: json['mediaUrl'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mediaUrl': mediaUrl,
      'type': type,
    };
  }
}
