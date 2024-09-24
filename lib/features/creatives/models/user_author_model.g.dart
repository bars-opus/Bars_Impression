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
      bio: fields[5] as String?,
      storeType: fields[4] as String?,
      verified: fields[3] as bool?,
      dynamicLink: fields[6] as String?,
      disabledAccount: fields[7] as bool?,
      reportConfirmed: fields[8] as bool?,
      lastActiveDate: fields[9] as Timestamp?,
      disableChat: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountHolderAuthor obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.profileImageUrl)
      ..writeByte(3)
      ..write(obj.verified)
      ..writeByte(4)
      ..write(obj.storeType)
      ..writeByte(5)
      ..write(obj.bio)
      ..writeByte(6)
      ..write(obj.dynamicLink)
      ..writeByte(7)
      ..write(obj.disabledAccount)
      ..writeByte(8)
      ..write(obj.reportConfirmed)
      ..writeByte(9)
      ..write(obj.lastActiveDate)
      ..writeByte(10)
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
