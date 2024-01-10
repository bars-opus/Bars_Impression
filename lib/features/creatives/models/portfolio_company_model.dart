class PortfolioCompanyModel {
  String id;
  final String name;
  final String type;
  final String link;
  final bool verified;

  PortfolioCompanyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.link,
    required this.verified,
  });

  factory PortfolioCompanyModel.fromJson(Map<String, dynamic> json) {
    return PortfolioCompanyModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      link: json['link'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'link': link,
      'verified': verified,
    };
  }
}

