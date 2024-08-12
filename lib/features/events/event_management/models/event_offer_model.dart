
class EventOffer {
  String id;
  final String name; 
  final String role;
  final String taggedType; 
  final bool
      verifiedTag;
  final String? internalProfileLink; 
  final String? externalProfileLink; 

  EventOffer({
    required this.id,
    required this.name,
    required this.role,
    required this.taggedType,
    required this.verifiedTag,
    required this.internalProfileLink,
    required this.externalProfileLink,
  });

  factory EventOffer.fromJson(Map<String, dynamic> json) {
    return EventOffer(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      taggedType: json['taggedType'],
      verifiedTag: json['verifiedTag'],
      internalProfileLink: json['internalProfileLink'],
      externalProfileLink: json['externalProfileLink'],
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
    };
  }
}


