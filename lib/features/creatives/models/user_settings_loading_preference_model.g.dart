// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_loading_preference_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsLoadingPreferenceModelAdapter
    extends TypeAdapter<UserSettingsLoadingPreferenceModel> {
  @override
  final int typeId = 10;

  @override
  UserSettingsLoadingPreferenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsLoadingPreferenceModel(
      city: fields[0] as String?,
      country: fields[1] as String?,
      userId: fields[3] as String?,
      currency: fields[2] as String?,
      timestamp: fields[4] as Timestamp?,
      subaccountId: fields[5] as String?,
      transferRecepientId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsLoadingPreferenceModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.subaccountId)
      ..writeByte(6)
      ..write(obj.transferRecepientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsLoadingPreferenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
