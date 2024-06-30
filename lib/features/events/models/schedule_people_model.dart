class SchedulePeopleModel {
  String id;
  final String name; // tagged person name
  final String? profileImageUrl;
  final bool
      verifiedTag; // if the tagged is verified by the tagged person or not
  final String? internalProfileLink; // like to tagged person on Bars impression
  final String? externalProfileLink; //link to tagged person to external sites

  SchedulePeopleModel({
    required this.id,
    required this.name,
    required this.verifiedTag,
    required this.internalProfileLink,
    required this.externalProfileLink,
    required this.profileImageUrl,
  });

  factory SchedulePeopleModel.fromJson(Map<String, dynamic> json) {
    return SchedulePeopleModel(
      id: json['id'],
      name: json['name'],
      verifiedTag: json['verifiedTag'],
      profileImageUrl: json['profileImageUrl'],
      internalProfileLink: json['internalProfileLink'],
      externalProfileLink: json['externalProfileLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'verifiedTag': verifiedTag,
      'profileImageUrl': profileImageUrl,
      'internalProfileLink': internalProfileLink,
      'externalProfileLink': externalProfileLink,
    };
  }
}
