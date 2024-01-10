
class SchedulePeopleModel {
  String id;
  final String name; // tagged person name
  final bool verifiedTag; // if the tagged is verified by the tagged person or not
  final String? internalProfileLink; // like to tagged person on Bars impression
  final String? externalProfileLink; //link to tagged person to external sites

  SchedulePeopleModel({
    required this.id,
    required this.name,
    required this.verifiedTag,
    required this.internalProfileLink,
    required this.externalProfileLink,
  });

  factory SchedulePeopleModel.fromJson(Map<String, dynamic> json) {
    return SchedulePeopleModel(
      id: json['id'],
      name: json['name'],
    verifiedTag: json['verifiedTag'],
      internalProfileLink: json['internalProfileLink'],
      externalProfileLink: json['externalProfileLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'verifiedTag': verifiedTag,
      'internalProfileLink': internalProfileLink,
      'externalProfileLink': externalProfileLink,
    };
  }
}

