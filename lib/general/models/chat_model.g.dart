// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 6;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      id: fields[0] as String,
      lastMessage: fields[2] as String,
      messageInitiator: fields[3] as String,
      firstMessage: fields[4] as String,
      seen: fields[6] as bool,
      fromUserId: fields[1] as String,
      mediaType: fields[7] as String,
      restrictChat: fields[8] as bool,
      newMessageTimestamp: fields[10] as Timestamp?,
      toUserId: fields[5] as String,
      timestamp: fields[11] as Timestamp?,
      messageId: fields[9] as String,
      muteMessage: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromUserId)
      ..writeByte(2)
      ..write(obj.lastMessage)
      ..writeByte(3)
      ..write(obj.messageInitiator)
      ..writeByte(4)
      ..write(obj.firstMessage)
      ..writeByte(5)
      ..write(obj.toUserId)
      ..writeByte(6)
      ..write(obj.seen)
      ..writeByte(7)
      ..write(obj.mediaType)
      ..writeByte(8)
      ..write(obj.restrictChat)
      ..writeByte(9)
      ..write(obj.messageId)
      ..writeByte(10)
      ..write(obj.newMessageTimestamp)
      ..writeByte(11)
      ..write(obj.timestamp)
      ..writeByte(12)
      ..write(obj.muteMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
