import 'package:hive_flutter/hive_flutter.dart';

import 'package:bars/utilities/exports.dart';

part 'user_professional_model.g.dart';

@HiveType(typeId: 11) // Use unique IDs for different classes

class UserProfessionalModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String profileImageUrl;

  @HiveField(3)
  final bool verified;

  @HiveField(4)
  final String profileHandle;

  @HiveField(5)
  final String dynamicLink;

  @HiveField(6)
  final String terms;

  @HiveField(7)
  final String overview;

  @HiveField(8)
  final bool noBooking;

  @HiveField(9)
  final bool? disableAdvice;

  @HiveField(10)
  final bool? hideAdvice;

  @HiveField(11)
  final String city;

  @HiveField(12)
  final String country;

  @HiveField(13)
  final String continent;

  @HiveField(14)
  final String currency;

  // @HiveField(15)
  // final List<PortfolioCompanyModel> company;

  // @HiveField(16)
  // final List<PortfolioCollaborationModel> collaborations;

  // @HiveField(17)
  // final List<PortfolioModel> performances;

  // @HiveField(18)
  // final List<PortfolioContactModel> contacts;

  @HiveField(19)
  final List<PortfolioModel> awards;

  @HiveField(20)
  final List<PortfolioModel> skills;

  @HiveField(21)
  final List<PortfolioModel> links;

  @HiveField(22)
  final List<PortfolioModel> genreTags;

  @HiveField(23)
  final List<String> professionalImageUrls;

  @HiveField(24)
  final List<String> subAccountType;

  @HiveField(25)
  final List<PriceModel> priceTags;

  @HiveField(26)
  final double randomId;

  @HiveField(27)
  final String transferRecepientId;
  //  @HiveField(0)
  // final String userId;
  //  @HiveField(1)
  // final String userName;
  // final String profileImageUrl;
  // final bool verified;
  // final String profileHandle;
  // final String dynamicLink;
  // final String terms;
  // final String overview;
  // final bool noBooking;
  // final bool? disableAdvice;
  // final bool? hideAdvice;

  // final String city;
  // final String country;
  // final String continent;
  // final String currency;

  // List<PortfolioCompanyModel> company;
  // List<PortfolioCollaborationModel> collaborations;
  // List<PortfolioModel> performances;
  // List<PortfolioContactModel> contacts;
  // List<PortfolioModel> awards;
  // List<PortfolioModel> skills;
  // List<PortfolioModel> links;
  // List<PortfolioModel> genreTags;
  // List<String> professionalImageUrls;
  // List<String> subAccountType;
  // List<PriceModel> priceTags;

  // final double randomId;
  //   final String transferRecepientId;

  UserProfessionalModel({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.profileHandle,
    required this.verified,
    required this.terms,
    required this.city,
    required this.country,
    required this.continent,
    required this.overview,
    required this.noBooking,
    // required this.company,
    // required this.collaborations,
    // required this.performances,
    required this.awards,
    // required this.contacts,
    required this.skills,
    required this.links,
    required this.genreTags,
    required this.professionalImageUrls,
    required this.subAccountType,
    required this.priceTags,
    required this.dynamicLink,
    required this.randomId,
    required this.currency,
    required this.disableAdvice,
    required this.hideAdvice,
    required this.transferRecepientId,
  });

  factory UserProfessionalModel.fromDoc(DocumentSnapshot doc) {
    return UserProfessionalModel(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      profileHandle: doc['profileHandle'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      terms: doc['terms'] ?? '',
      overview: doc['overview'] ?? '',
      city: doc['city'] ?? '',
      currency: doc['currency'] ?? '',
      country: doc['country'] ?? '',
      continent: doc['continent'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
      randomId: doc['randomId'] ?? 0.0,
      noBooking: doc['noBooking'] ?? false,
      disableAdvice: doc['disableAdvice'] ?? false,
      hideAdvice: doc['hideAdvice'] ?? false,
      // company: List<PortfolioCompanyModel>.from(doc['company']
      //         ?.map((company) => PortfolioCompanyModel.fromJson(company)) ??
      //     []),
      // collaborations: List<PortfolioCollaborationModel>.from(
      //     doc['collaborations']?.map((collaborations) =>
      //             PortfolioCollaborationModel.fromJson(collaborations)) ??
      //         []),
      // performances: List<PortfolioModel>.from(doc['performances']
      //         ?.map((performances) => PortfolioModel.fromJson(performances)) ??
      //     []),
      awards: List<PortfolioModel>.from(
          doc['awards']?.map((awards) => PortfolioModel.fromJson(awards)) ??
              []),
      // contacts: List<PortfolioContactModel>.from(doc['contacts']
      //         ?.map((contacts) => PortfolioContactModel.fromJson(contacts)) ??
      //     []),
      skills: List<PortfolioModel>.from(
          doc['skills']?.map((skills) => PortfolioModel.fromJson(skills)) ??
              []),
      links: List<PortfolioModel>.from(
          doc['links']?.map((links) => PortfolioModel.fromJson(links)) ?? []),
      genreTags: List<PortfolioModel>.from(doc['genreTags']
              ?.map((genreTags) => PortfolioModel.fromJson(genreTags)) ??
          []),
      professionalImageUrls:
          List<String>.from(doc['professionalImageUrls'] ?? []),
      subAccountType: List<String>.from(doc['subAccountType'] ?? []),
      priceTags: List<PriceModel>.from(
          doc['priceTags']?.map((priceTag) => PriceModel.fromJson(priceTag)) ??
              []),
    );
  }

  factory UserProfessionalModel.fromJson(Map<String, dynamic> json) {
    return UserProfessionalModel(
      userId: json['userId'],
      userName: json['userName'],
      profileImageUrl: json['profileImageUrl'],
      profileHandle: json['profileHandle'],
      dynamicLink: json['dynamicLink'],
      verified: json['verified'],
      terms: json['terms'],
      overview: json['overview'],
      city: json['city'],
      country: json['country'],
      randomId: json['randomId'],
      currency: json['currency'],
      continent: json['continent'],
      noBooking: json['noBooking'],
      disableAdvice: json['disableAdvice'],
      hideAdvice: json['hideAdvice'],
      // company: (json['company'] as List<dynamic>)
      //     .map((company) => PortfolioCompanyModel.fromJson(company))
      //     .toList(),
      // collaborations: (json['collaborations'] as List<dynamic>)
      //     .map((collaboration) =>
      //         PortfolioCollaborationModel.fromJson(collaboration))
      //     .toList(),
      // performances: (json['performances'] as List<dynamic>)
      //     .map((performance) => PortfolioModel.fromJson(performance))
      //     .toList(),
      // contacts: (json['contacts'] as List<dynamic>)
      //     .map((contact) => PortfolioContactModel.fromJson(contact))
      //     .toList(),
      awards: (json['awards'] as List<dynamic>)
          .map((award) => PortfolioModel.fromJson(award))
          .toList(),
      skills: (json['skills'] as List<dynamic>)
          .map((skill) => PortfolioModel.fromJson(skill))
          .toList(),
      links: (json['links'] as List<dynamic>)
          .map((link) => PortfolioModel.fromJson(link))
          .toList(),
      genreTags: (json['genreTags'] as List<dynamic>)
          .map((genreTag) => PortfolioModel.fromJson(genreTag))
          .toList(),
      professionalImageUrls: (json['professionalImageUrls'] as List<dynamic>)
          .map((imageUrl) => imageUrl as String)
          .toList(),
      subAccountType: (json['subAccountType'] as List<dynamic>)
          .map((accountType) => accountType as String)
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
      'profileImageUrl': profileImageUrl,
      'profileHandle': profileHandle,
      'dynamicLink': dynamicLink,
      'verified': verified,
      'terms': terms,
      'overview': overview,
      'city': city,
      'country': country,
      'continent': continent,
      'randomId': randomId,
      'currency': currency,
      'noBooking': noBooking,
      'disableAdvice': disableAdvice,
      'hideAdvice': hideAdvice,
      'transferRecepientId': transferRecepientId,
      // 'company': company.map((company) => company.toJson()).toList(),
      // 'collaborations': collaborations
      //     .map((collaborations) => collaborations.toJson())
      //     .toList(),
      // 'performances':
      //     performances.map((performances) => performances.toJson()).toList(),
      // 'contacts': contacts.map((contacts) => contacts.toJson()).toList(),
      'awards': awards.map((awards) => awards.toJson()).toList(),
      'skills': skills.map((skills) => skills.toJson()).toList(),
      'links': links.map((links) => links.toJson()).toList(),
      'genreTags': genreTags.map((genreTags) => genreTags.toJson()).toList(),
      'professionalImageUrls': professionalImageUrls,
      'subAccountType': subAccountType,
      'priceTags': priceTags.map((priceTag) => priceTag.toJson()).toList(),
    };
  }
}
