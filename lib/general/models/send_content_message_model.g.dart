// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_content_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SendContentMessageAdapter extends TypeAdapter<SendContentMessage> {
  @override
  final int typeId = 2;

  @override
  SendContentMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SendContentMessage(
      id: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SendContentMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendContentMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
