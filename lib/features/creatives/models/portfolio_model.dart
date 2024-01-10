class PortfolioModel {
  String id;
  final String name;
  final String link;

  PortfolioModel({
    required this.id,
    required this.name,
    required this.link,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'],
      name: json['name'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
    };
  }
}


