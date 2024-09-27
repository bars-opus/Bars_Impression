// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceModelAdapter extends TypeAdapter<PriceModel> {
  @override
  final int typeId = 13;

  @override
  PriceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceModel(
      price: fields[1] as String,
      name: fields[2] as String,
      value: fields[3] as String,
      id: fields[0] as String,
      duruation: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PriceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.duruation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
