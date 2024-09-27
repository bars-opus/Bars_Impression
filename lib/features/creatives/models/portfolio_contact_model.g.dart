// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioContactModelAdapter extends TypeAdapter<PortfolioContactModel> {
  @override
  final int typeId = 14;

  @override
  PortfolioContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioContactModel(
      id: fields[0] as String,
      email: fields[1] as String,
      number: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioContactModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
