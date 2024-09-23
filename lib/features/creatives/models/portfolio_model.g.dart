// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioModelAdapter extends TypeAdapter<PortfolioModel> {
  @override
  final int typeId = 12;

  @override
  PortfolioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioModel(
      id: fields[0] as String,
      name: fields[1] as String,
      link: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
