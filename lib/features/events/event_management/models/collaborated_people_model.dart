// import 'package:bars/utilities/exports.dart';

class CollaboratedPeople {
  String id;
  final String name; // tagged person name
  final String
      role; // the role of the tagged person either a special guess, an artist, a sponsor or stc.
  final String? internalProfileLink; // like to tagged person on Bars impression
  final String? externalProfileLink; //link to tagged person to external sites
  final String profileImageUrl;

  CollaboratedPeople({
    required this.id,
    required this.name,
    required this.role,
    required this.internalProfileLink,
    required this.externalProfileLink,
    required this.profileImageUrl,
  });

  factory CollaboratedPeople.fromJson(Map<String, dynamic> json) {
    return CollaboratedPeople(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      internalProfileLink: json['internalProfileLink'],
      externalProfileLink: json['externalProfileLink'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'internalProfileLink': internalProfileLink,
      'externalProfileLink': externalProfileLink,
    };
  }
}
