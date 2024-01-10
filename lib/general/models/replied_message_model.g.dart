// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replied_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReplyToMessageAdapter extends TypeAdapter<ReplyToMessage> {
  @override
  final int typeId = 4;

  @override
  ReplyToMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReplyToMessage(
      id: fields[0] as String,
      message: fields[1] as String,
      imageUrl: fields[2] as String,
      athorId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReplyToMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.athorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyToMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
