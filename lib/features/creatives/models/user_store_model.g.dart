// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_store_model.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class UserStoreModelAdapter extends TypeAdapter<UserStoreModel> {
//   @override
//   final int typeId = 11;

//   @override
//   UserStoreModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return UserStoreModel(
//       userId: fields[0] as String,
//       userName: fields[1] as String,
//       shopLogomageUrl: fields[2] as String,
//       verified: fields[3] as bool,
//       shopType: fields[4] as String,
//       dynamicLink: fields[5] as String,
//       terms: fields[6] as String,
//       overview: fields[7] as String,
//       noBooking: fields[8] as bool,
//       city: fields[9] as String,
//       country: fields[10] as String,
//       currency: fields[11] as String,
//       awards: (fields[12] as List).cast<PortfolioModel>(),
//       links: (fields[13] as List).cast<PortfolioModel>(),
//       services: (fields[14] as List).cast<PortfolioModel>(),
//       professionalImageUrls: (fields[15] as List).cast<String>(),
//       randomId: fields[16] as double,
//       contacts: (fields[17] as List).cast<PortfolioContactModel>(),
//       transferRecepientId: fields[18] as String,
//       accountType: fields[19] as String?,
//       currentVisitors: fields[20] as int?,
//       maxCapacity: fields[21] as int?,
//       amenities: (fields[22] as List).cast<String>(),
//       averageRating: fields[23] as int?,
//       openingHours: (fields[24] as Map).cast<String, DateTimeRange>(),
//       appointmentSlots: (fields[25] as List).cast<AppointmentSlotModel>(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, UserStoreModel obj) {
//     writer
//       ..writeByte(26)
//       ..writeByte(0)
//       ..write(obj.userId)
//       ..writeByte(1)
//       ..write(obj.userName)
//       ..writeByte(2)
//       ..write(obj.shopLogomageUrl)
//       ..writeByte(3)
//       ..write(obj.verified)
//       ..writeByte(4)
//       ..write(obj.shopType)
//       ..writeByte(5)
//       ..write(obj.dynamicLink)
//       ..writeByte(6)
//       ..write(obj.terms)
//       ..writeByte(7)
//       ..write(obj.overview)
//       ..writeByte(8)
//       ..write(obj.noBooking)
//       ..writeByte(9)
//       ..write(obj.city)
//       ..writeByte(10)
//       ..write(obj.country)
//       ..writeByte(11)
//       ..write(obj.currency)
//       ..writeByte(12)
//       ..write(obj.awards)
//       ..writeByte(13)
//       ..write(obj.links)
//       ..writeByte(14)
//       ..write(obj.services)
//       ..writeByte(15)
//       ..write(obj.professionalImageUrls)
//       ..writeByte(16)
//       ..write(obj.randomId)
//       ..writeByte(17)
//       ..write(obj.contacts)
//       ..writeByte(18)
//       ..write(obj.transferRecepientId)
//       ..writeByte(19)
//       ..write(obj.accountType)
//       ..writeByte(20)
//       ..write(obj.currentVisitors)
//       ..writeByte(21)
//       ..write(obj.maxCapacity)
//       ..writeByte(22)
//       ..write(obj.amenities)
//       ..writeByte(23)
//       ..write(obj.averageRating)
//       ..writeByte(24)
//       ..write(obj.openingHours)
//       ..writeByte(25)
//       ..write(obj.appointmentSlots);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is UserStoreModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
