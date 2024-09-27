class TaggedEventPeopleModel {
  String id;
  final String name; // tagged person name
  final String
      role; // the role of the tagged person either a special guess, an Salon, a sponsor or stc.
  final String taggedType; // either its a crew tagged, or a guess or a sponsor.
  final bool
      verifiedTag; // if the tagged is verified by the tagged person or not
  final String? internalProfileLink; // like to tagged person on Bars impression
  final String? externalProfileLink; //link to tagged person to external sites
  final String? profileImageUrl;

  TaggedEventPeopleModel({
    required this.id,
    required this.name,
    required this.role,
    required this.taggedType,
    required this.verifiedTag,
    required this.internalProfileLink,
    required this.externalProfileLink,
    required this.profileImageUrl,
  });

  factory TaggedEventPeopleModel.fromJson(Map<String, dynamic> json) {
    return TaggedEventPeopleModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      taggedType: json['taggedType'],
      verifiedTag: json['verifiedTag'],
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
      'taggedType': taggedType,
      'verifiedTag': verifiedTag,
      'internalProfileLink': internalProfileLink,
      'externalProfileLink': externalProfileLink,
      'profileImageUrl': profileImageUrl,
    };
  }
}
