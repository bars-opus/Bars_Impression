import 'package:hive_flutter/hive_flutter.dart';
import 'package:bars/utilities/exports.dart';

// part 'user_store_model.g.dart';

// @HiveType(typeId: 11)
class UserStoreModel {
  // @HiveField(0)
  final String userId;
  // @HiveField(1)
  final String shopName;
  // @HiveField(2)
  final String shopLogomageUrl;
  // @HiveField(3)
  final bool verified;
  // @HiveField(4)
  final String shopType;
  // @HiveField(5)
  final String dynamicLink;
  // @HiveField(6)
  final String terms;
  // @HiveField(7)
  final String overview;
  // @HiveField(8)
  final bool noBooking;
  // @HiveField(9)
  final String city;
  // @HiveField(10)
  final String country;
  final String address;

  // @HiveField(11)
  final String currency;
  // @HiveField(12)
  final List<PortfolioModel> awards;
  // @HiveField(13)
  final List<PortfolioModel> links;
  // @HiveField(14)
  final List<PortfolioModel> services;
  // @HiveField(15)
  final List<String> professionalImageUrls;
  // @HiveField(16)
  final double randomId;
  // @HiveField(17)
  final List<PortfolioContactModel> contacts;
  // @HiveField(18)
  final String transferRecepientId;
  // @HiveField(19)
  final String? accountType;
  // @HiveField(20)
  final int? currentVisitors;
  // @HiveField(21)
  final int? maxCapacity;
  // @HiveField(22)
  final List<String> amenities;
  // @HiveField(23)
  final int? averageRating;
  // @HiveField(24)
  final Map<String, DateTimeRange> openingHours;
  // @HiveField(25)
  final List<AppointmentSlotModel> appointmentSlots;

  UserStoreModel({
    required this.userId,
    required this.shopName,
    required this.shopLogomageUrl,
    required this.verified,
    required this.shopType,
    required this.dynamicLink,
    required this.terms,
    required this.overview,
    required this.noBooking,
    required this.city,
    required this.country,
    required this.currency,
    required this.awards,
    required this.links,
    required this.services,
    required this.professionalImageUrls,
    required this.randomId,
    required this.contacts,
    required this.transferRecepientId,
    required this.accountType,
    this.currentVisitors,
    this.maxCapacity,
    required this.amenities,
    this.averageRating,
    required this.openingHours,
    required this.appointmentSlots,
    required this.address,
  });

  factory UserStoreModel.fromDoc(DocumentSnapshot doc) {
    return UserStoreModel(
      userId: doc.id,
      shopName: doc['shopName'] ?? '',
      shopLogomageUrl: doc['shopLogomageUrl'] ?? '',
      shopType: doc['shopType'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      accountType: doc['accountType'] ?? '',
      verified: doc['verified'] ?? false,
      terms: doc['terms'] ?? '',
      overview: doc['overview'] ?? '',
      city: doc['city'] ?? '',
      country: doc['country'] ?? '',
      currency: doc['currency'] ?? '',
      address: doc['address'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
      randomId: doc['randomId'] ?? 0.0,
      noBooking: doc['noBooking'] ?? false,
      awards: List<PortfolioModel>.from(
          doc['awards']?.map((award) => PortfolioModel.fromJson(award)) ?? []),
      contacts: List<PortfolioContactModel>.from(doc['contacts']
              ?.map((contact) => PortfolioContactModel.fromJson(contact)) ??
          []),
      links: List<PortfolioModel>.from(
          doc['links']?.map((link) => PortfolioModel.fromJson(link)) ?? []),
      services: List<PortfolioModel>.from(
          doc['services']?.map((service) => PortfolioModel.fromJson(service)) ??
              []),
      professionalImageUrls:
          List<String>.from(doc['professionalImageUrls'] ?? []),
      currentVisitors: doc['currentVisitors'],
      maxCapacity: doc['maxCapacity'],
      amenities: List<String>.from(doc['amenities'] ?? []),
      averageRating: doc['averageRating'] ?? 0,
      openingHours: (doc['openingHours'] as Map<String, dynamic>)?.map(
            (key, value) => MapEntry(
              key,
              DateTimeRange(
                start: DateTime.parse(value['start']),
                end: DateTime.parse(value['end']),
              ),
            ),
          ) ??
          {},
      appointmentSlots: List<AppointmentSlotModel>.from(doc['appointmentSlots']
              ?.map((slot) => AppointmentSlotModel.fromJson(slot)) ??
          []),
    );
  }

  // factory UserStoreModel.fromDoc(DocumentSnapshot doc) {
  //   return UserStoreModel(
  //     userId: doc.id,
  //     shopName: doc['shopName'] ?? '',
  //     shopLogomageUrl: doc['shopLogomageUrl'] ?? '',
  //     shopType: doc['shopType'] ?? 'Fan',
  //     dynamicLink: doc['dynamicLink'] ?? '',
  //     accountType: doc['accountType'] ?? '',
  //     verified: doc['verified'] ?? false,
  //     terms: doc['terms'] ?? '',
  //     overview: doc['overview'] ?? '',
  //     city: doc['city'] ?? '',
  //     country: doc['country'] ?? '',
  //     currency: doc['currency'] ?? '',
  //     transferRecepientId: doc['transferRecepientId'] ?? '',
  //     randomId: doc['randomId'] ?? 0.0,
  //     noBooking: doc['noBooking'] ?? false,
  //     awards: List<PortfolioModel>.from(
  //         doc['awards']?.map((award) => PortfolioModel.fromJson(award)) ?? []),
  //     contacts: List<PortfolioContactModel>.from(doc['contacts']
  //             ?.map((contact) => PortfolioContactModel.fromJson(contact)) ??
  //         []),
  //     links: List<PortfolioModel>.from(
  //         doc['links']?.map((link) => PortfolioModel.fromJson(link)) ?? []),
  //     services: List<PortfolioModel>.from(
  //         doc['services']?.map((service) => PortfolioModel.fromJson(service)) ??
  //             []),
  //     professionalImageUrls:
  //         List<String>.from(doc['professionalImageUrls'] ?? []),
  //     currentVisitors: doc['currentVisitors'],
  //     maxCapacity: doc['maxCapacity'],
  //     amenities: List<String>.from(doc['amenities'] ?? []),
  //     averageRating: doc['averageRating'],
  //     openingHours: Map<String, DateTimeRange>.from(doc['openingHours'] ?? {}),
  //     appointmentSlots: List<AppointmentSlotModel>.from(doc['appointmentSlots']
  //             ?.map((slot) => AppointmentSlotModel.fromJson(slot)) ??
  //         []),
  //   );
  // }

  factory UserStoreModel.fromJson(Map<String, dynamic> json) {
    return UserStoreModel(
      userId: json['userId'],
      shopName: json['shopName'],
      shopLogomageUrl: json['shopLogomageUrl'],
      shopType: json['shopType'],
      dynamicLink: json['dynamicLink'],
      verified: json['verified'],
      address: json['address'],
      terms: json['terms'],
      overview: json['overview'],
      accountType: json['accountType'],
      city: json['city'],
      country: json['country'],
      randomId: json['randomId'],
      currency: json['currency'],
      noBooking: json['noBooking'],
      transferRecepientId: json['transferRecepientId'] ?? '',
      contacts: (json['contacts'] as List<dynamic>)
          .map((contact) => PortfolioContactModel.fromJson(contact))
          .toList(),
      awards: (json['awards'] as List<dynamic>)
          .map((award) => PortfolioModel.fromJson(award))
          .toList(),
      links: (json['links'] as List<dynamic>)
          .map((link) => PortfolioModel.fromJson(link))
          .toList(),
      services: (json['services'] as List<dynamic>)
          .map((service) => PortfolioModel.fromJson(service))
          .toList(),
      professionalImageUrls: (json['professionalImageUrls'] as List<dynamic>)
          .map((imageUrl) => imageUrl as String)
          .toList(),
      amenities: (json['amenities'] as List<dynamic>)
          .map((amenity) => amenity as String)
          .toList(),
      averageRating: json['averageRating'],
      openingHours: Map<String, DateTimeRange>.from(json['openingHours'] ?? {}),
      appointmentSlots: (json['appointmentSlots'] as List<dynamic>)
          .map((slot) => AppointmentSlotModel.fromJson(slot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shopName': shopName,
      'shopLogomageUrl': shopLogomageUrl,
      'shopType': shopType,
      'dynamicLink': dynamicLink,
      'verified': verified,
      'address': address,
      'terms': terms,
      'overview': overview,
      'accountType': accountType,
      'city': city,
      'country': country,
      'randomId': randomId,
      'currency': currency,
      'noBooking': noBooking,
      'transferRecepientId': transferRecepientId,
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
      'awards': awards.map((award) => award.toJson()).toList(),
      'links': links.map((link) => link.toJson()).toList(),
      'services': services.map((service) => service.toJson()).toList(),
      'professionalImageUrls': professionalImageUrls,
      'currentVisitors': currentVisitors,
      'maxCapacity': maxCapacity,
      'amenities': amenities,
      'averageRating': averageRating,
      'openingHours': openingHours,
      'appointmentSlots':
          appointmentSlots.map((slot) => slot.toJson()).toList(),
    };
  }
}
