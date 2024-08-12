// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_author_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountHolderAuthorAdapter extends TypeAdapter<AccountHolderAuthor> {
  @override
  final int typeId = 7;

  @override
  AccountHolderAuthor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountHolderAuthor(
      userId: fields[0] as String?,
      userName: fields[1] as String?,
      profileImageUrl: fields[2] as String?,
      bio: fields[6] as String?,
      profileHandle: fields[4] as String?,
      verified: fields[3] as bool?,
      name: fields[5] as String?,
      dynamicLink: fields[8] as String?,
      disabledAccount: fields[9] as bool?,
      reportConfirmed: fields[10] as bool?,
      lastActiveDate: fields[11] as Timestamp?,
      privateAccount: fields[12] as bool?,
      disableChat: fields[13] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountHolderAuthor obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.profileImageUrl)
      ..writeByte(3)
      ..write(obj.verified)
      ..writeByte(4)
      ..write(obj.profileHandle)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.dynamicLink)
      ..writeByte(9)
      ..write(obj.disabledAccount)
      ..writeByte(10)
      ..write(obj.reportConfirmed)
      ..writeByte(11)
      ..write(obj.lastActiveDate)
      ..writeByte(12)
      ..write(obj.privateAccount)
      ..writeByte(13)
      ..write(obj.disableChat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountHolderAuthorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
