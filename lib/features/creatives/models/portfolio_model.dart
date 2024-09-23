import 'package:hive/hive.dart';

part 'portfolio_model.g.dart';

@HiveType(typeId: 12) // Use unique IDs for different classes

class PortfolioModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
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
