// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_attachement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAttachmentAdapter extends TypeAdapter<MessageAttachment> {
  @override
  final int typeId = 3;

  @override
  MessageAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageAttachment(
      id: fields[0] as String,
      mediaUrl: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageAttachment obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mediaUrl)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
