// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_id_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketIdModelAdapter extends TypeAdapter<TicketIdModel> {
  @override
  final int typeId = 9;

  @override
  TicketIdModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketIdModel(
      eventId: fields[0] as String,
      isNew: fields[1] as bool,
      timestamp: fields[2] as Timestamp?,
      lastMessage: fields[3] as String,
      muteNotification: fields[4] as bool,
      isSeen: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TicketIdModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.isNew)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.lastMessage)
      ..writeByte(4)
      ..write(obj.muteNotification)
      ..writeByte(5)
      ..write(obj.isSeen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketIdModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
