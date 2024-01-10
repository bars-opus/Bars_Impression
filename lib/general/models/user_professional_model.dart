import 'package:bars/utilities/exports.dart';

class UserProfessionalModel {
  final String id;
  final String userName;
  final String profileImageUrl;
  final bool verified;
  final String profileHandle;
  final String dynamicLink;
  final String terms;
  final String overview;
  final bool noBooking;
  final String city;
  final String country;
  final String continent;
  final String currency;

  List<PortfolioCompanyModel> company;
  List<PortfolioCollaborationModel> collaborations;
  List<PortfolioModel> performances;
  List<PortfolioContactModel> contacts;
  List<PortfolioModel> awards;
  List<PortfolioModel> skills;
  List<PortfolioModel> links;
  List<PortfolioModel> genreTags;
  List<String> professionalImageUrls;
  List<String> subAccountType;
  List<PriceModel> priceTags;

  final double randomId;

  UserProfessionalModel({
    required this.id,
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
    required this.company,
    required this.collaborations,
    required this.performances,
    required this.awards,
    required this.contacts,
    required this.skills,
    required this.links,
    required this.genreTags,
    required this.professionalImageUrls,
    required this.subAccountType,
    required this.priceTags,
    required this.dynamicLink,
    required this.randomId,
    required this.currency,
  });

  factory UserProfessionalModel.fromDoc(DocumentSnapshot doc) {
    return UserProfessionalModel(
      id: doc.id,
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
      randomId: doc['randomId'] ?? 0.0,
      noBooking: doc['noBooking'] ?? false,
      company: List<PortfolioCompanyModel>.from(doc['company']
              ?.map((company) => PortfolioCompanyModel.fromJson(company)) ??
          []),
      collaborations: List<PortfolioCollaborationModel>.from(
          doc['collaborations']?.map((collaborations) =>
                  PortfolioCollaborationModel.fromJson(collaborations)) ??
              []),
      performances: List<PortfolioModel>.from(doc['performances']
              ?.map((performances) => PortfolioModel.fromJson(performances)) ??
          []),
      awards: List<PortfolioModel>.from(
          doc['awards']?.map((awards) => PortfolioModel.fromJson(awards)) ??
              []),
      contacts: List<PortfolioContactModel>.from(doc['contacts']
              ?.map((contacts) => PortfolioContactModel.fromJson(contacts)) ??
          []),
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
      id: json['id'],
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
      company: (json['company'] as List<dynamic>)
          .map((company) => PortfolioCompanyModel.fromJson(company))
          .toList(),
      collaborations: (json['collaborations'] as List<dynamic>)
          .map((collaboration) =>
              PortfolioCollaborationModel.fromJson(collaboration))
          .toList(),
      performances: (json['performances'] as List<dynamic>)
          .map((performance) => PortfolioModel.fromJson(performance))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>)
          .map((contact) => PortfolioContactModel.fromJson(contact))
          .toList(),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'company': company.map((company) => company.toJson()).toList(),
      'collaborations': collaborations
          .map((collaborations) => collaborations.toJson())
          .toList(),
      'performances':
          performances.map((performances) => performances.toJson()).toList(),
      'contacts': contacts.map((contacts) => contacts.toJson()).toList(),
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
