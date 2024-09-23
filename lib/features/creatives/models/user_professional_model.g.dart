// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_professional_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfessionalModelAdapter extends TypeAdapter<UserProfessionalModel> {
  @override
  final int typeId = 11;

  @override
  UserProfessionalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfessionalModel(
      userId: fields[0] as String,
      userName: fields[1] as String,
      profileImageUrl: fields[2] as String,
      profileHandle: fields[4] as String,
      verified: fields[3] as bool,
      terms: fields[6] as String,
      city: fields[11] as String,
      country: fields[12] as String,
      continent: fields[13] as String,
      overview: fields[7] as String,
      noBooking: fields[8] as bool,
      awards: (fields[19] as List).cast<PortfolioModel>(),
      skills: (fields[20] as List).cast<PortfolioModel>(),
      links: (fields[21] as List).cast<PortfolioModel>(),
      genreTags: (fields[22] as List).cast<PortfolioModel>(),
      professionalImageUrls: (fields[23] as List).cast<String>(),
      subAccountType: (fields[24] as List).cast<String>(),
      priceTags: (fields[25] as List).cast<PriceModel>(),
      dynamicLink: fields[5] as String,
      randomId: fields[26] as double,
      currency: fields[14] as String,
      disableAdvice: fields[9] as bool?,
      hideAdvice: fields[10] as bool?,
      transferRecepientId: fields[27] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfessionalModel obj) {
    writer
      ..writeByte(24)
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
      ..write(obj.dynamicLink)
      ..writeByte(6)
      ..write(obj.terms)
      ..writeByte(7)
      ..write(obj.overview)
      ..writeByte(8)
      ..write(obj.noBooking)
      ..writeByte(9)
      ..write(obj.disableAdvice)
      ..writeByte(10)
      ..write(obj.hideAdvice)
      ..writeByte(11)
      ..write(obj.city)
      ..writeByte(12)
      ..write(obj.country)
      ..writeByte(13)
      ..write(obj.continent)
      ..writeByte(14)
      ..write(obj.currency)
      ..writeByte(19)
      ..write(obj.awards)
      ..writeByte(20)
      ..write(obj.skills)
      ..writeByte(21)
      ..write(obj.links)
      ..writeByte(22)
      ..write(obj.genreTags)
      ..writeByte(23)
      ..write(obj.professionalImageUrls)
      ..writeByte(24)
      ..write(obj.subAccountType)
      ..writeByte(25)
      ..write(obj.priceTags)
      ..writeByte(26)
      ..write(obj.randomId)
      ..writeByte(27)
      ..write(obj.transferRecepientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfessionalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
