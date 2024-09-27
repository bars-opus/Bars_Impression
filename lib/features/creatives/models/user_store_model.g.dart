// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStoreModelAdapter extends TypeAdapter<UserStoreModel> {
  @override
  final int typeId = 11;

  @override
  UserStoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStoreModel(
      userId: fields[0] as String,
      userName: fields[1] as String,
      storeLogomageUrl: fields[2] as String,
      storeType: fields[4] as String,
      verified: fields[3] as bool,
      terms: fields[6] as String,
      city: fields[9] as String,
      country: fields[10] as String,
      overview: fields[7] as String,
      noBooking: fields[8] as bool,
      awards: (fields[12] as List).cast<PortfolioModel>(),
      contacts: (fields[18] as List).cast<PortfolioContactModel>(),
      links: (fields[13] as List).cast<PortfolioModel>(),
      services: (fields[14] as List).cast<PortfolioModel>(),
      professionalImageUrls: (fields[15] as List).cast<String>(),
      priceTags: (fields[16] as List).cast<PriceModel>(),
      dynamicLink: fields[5] as String,
      randomId: fields[17] as double,
      currency: fields[11] as String,
      transferRecepientId: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserStoreModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.storeLogomageUrl)
      ..writeByte(3)
      ..write(obj.verified)
      ..writeByte(4)
      ..write(obj.storeType)
      ..writeByte(5)
      ..write(obj.dynamicLink)
      ..writeByte(6)
      ..write(obj.terms)
      ..writeByte(7)
      ..write(obj.overview)
      ..writeByte(8)
      ..write(obj.noBooking)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.currency)
      ..writeByte(12)
      ..write(obj.awards)
      ..writeByte(13)
      ..write(obj.links)
      ..writeByte(14)
      ..write(obj.services)
      ..writeByte(15)
      ..write(obj.professionalImageUrls)
      ..writeByte(16)
      ..write(obj.priceTags)
      ..writeByte(17)
      ..write(obj.randomId)
      ..writeByte(18)
      ..write(obj.contacts)
      ..writeByte(19)
      ..write(obj.transferRecepientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
