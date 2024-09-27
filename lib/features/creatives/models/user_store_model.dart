import 'package:hive_flutter/hive_flutter.dart';
import 'package:bars/utilities/exports.dart';

part 'user_store_model.g.dart';

@HiveType(typeId: 11)
class UserStoreModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String storeLogomageUrl;

  @HiveField(3)
  final bool verified;

  @HiveField(4)
  final String storeType;

  @HiveField(5)
  final String dynamicLink;

  @HiveField(6)
  final String terms;

  @HiveField(7)
  final String overview;

  @HiveField(8)
  final bool noBooking;

  @HiveField(9)
  final String city;

  @HiveField(10)
  final String country;

  @HiveField(11)
  final String currency;

  @HiveField(12)
  final List<PortfolioModel> awards;

  @HiveField(13)
  final List<PortfolioModel> links;

  @HiveField(14)
  final List<PortfolioModel> services;

  @HiveField(15)
  final List<String> professionalImageUrls;

  @HiveField(16)
  final List<PriceModel> priceTags;

  @HiveField(17)
  final double randomId;

  @HiveField(18)
  final List<PortfolioContactModel> contacts;

  @HiveField(19)
  final String transferRecepientId;

  UserStoreModel({
    required this.userId,
    required this.userName,
    required this.storeLogomageUrl,
    required this.storeType,
    required this.verified,
    required this.terms,
    required this.city,
    required this.country,
    required this.overview,
    required this.noBooking,
    required this.awards,
    required this.contacts,
    required this.links,
    required this.services,
    required this.professionalImageUrls,
    required this.priceTags,
    required this.dynamicLink,
    required this.randomId,
    required this.currency,
    required this.transferRecepientId,
  });

  factory UserStoreModel.fromDoc(DocumentSnapshot doc) {
    return UserStoreModel(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      storeLogomageUrl: doc['storeLogomageUrl'] ?? '',
      storeType: doc['storeType'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      terms: doc['terms'] ?? '',
      overview: doc['overview'] ?? '',
      city: doc['city'] ?? '',
      country: doc['country'] ?? '',
      currency: doc['currency'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
      randomId: doc['randomId'] ?? 0.0,
      noBooking: doc['noBooking'] ?? false,
      awards: List<PortfolioModel>.from(
          doc['awards']?.map((awards) => PortfolioModel.fromJson(awards)) ??
              []),
      contacts: List<PortfolioContactModel>.from(doc['contacts']
              ?.map((contacts) => PortfolioContactModel.fromJson(contacts)) ??
          []),
      links: List<PortfolioModel>.from(
          doc['links']?.map((links) => PortfolioModel.fromJson(links)) ?? []),
      services: List<PortfolioModel>.from(doc['services']
              ?.map((services) => PortfolioModel.fromJson(services)) ??
          []),
      professionalImageUrls:
          List<String>.from(doc['professionalImageUrls'] ?? []),
      priceTags: List<PriceModel>.from(
          doc['priceTags']?.map((priceTag) => PriceModel.fromJson(priceTag)) ??
              []),
    );
  }

  factory UserStoreModel.fromJson(Map<String, dynamic> json) {
    return UserStoreModel(
      userId: json['userId'],
      userName: json['userName'],
      storeLogomageUrl: json['storeLogomageUrl'],
      storeType: json['storeType'],
      dynamicLink: json['dynamicLink'],
      verified: json['verified'],
      terms: json['terms'],
      overview: json['overview'],
      city: json['city'],
      country: json['country'],
      randomId: json['randomId'],
      currency: json['currency'],
      noBooking: json['noBooking'],
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
      priceTags: (json['priceTags'] as List<dynamic>)
          .map((priceTag) => PriceModel.fromJson(priceTag))
          .toList(),
      transferRecepientId: json['transferRecepientId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'storeLogomageUrl': storeLogomageUrl,
      'storeType': storeType,
      'dynamicLink': dynamicLink,
      'verified': verified,
      'terms': terms,
      'overview': overview,
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
      'priceTags': priceTags.map((priceTag) => priceTag.toJson()).toList(),
    };
  }
}
