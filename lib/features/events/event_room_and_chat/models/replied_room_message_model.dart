class ReplyToRoomMessage {
  final String id;
  final String message;
  final String imageUrl;
  final String athorId;

  ReplyToRoomMessage({
    required this.id,
    required this.message,
    required this.imageUrl,
    required this.athorId,
  });

  factory ReplyToRoomMessage.fromMap(Map<String, dynamic> map) {
    return ReplyToRoomMessage(
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
