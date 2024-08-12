import 'package:bars/utilities/exports.dart';

class PriceModel {
  final String id;
  final String price;
  final String name;
  final String value;
  final String duruation;

  PriceModel({
    required this.price,
    required this.name,
    required this.value,
    required this.id,
    required this.duruation,
  });

  factory PriceModel.fromDoc(DocumentSnapshot doc) {
    return PriceModel(
      id: doc['id'] ?? '',
      name: doc['name']!,
      price: doc['price'] ?? '',
      value: doc['value'] ?? '',
      duruation: doc['duruation'] ?? '',
    );
  }

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id']!,
      name: json['name']!,
      price: json['price'] ?? '',
      value: json['value'] ?? '',
      duruation: json['duruation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'value': value,
      'duruation': duruation,
    };
  }
}
