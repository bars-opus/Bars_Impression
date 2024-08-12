// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_room_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventRoomAdapter extends TypeAdapter<EventRoom> {
  @override
  final int typeId = 8;

  @override
  EventRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventRoom(
      id: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[3] as String,
      linkedEventId: fields[2] as String,
      timestamp: fields[4] as Timestamp?,
      eventAuthorId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventRoom obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.linkedEventId)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.eventAuthorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
