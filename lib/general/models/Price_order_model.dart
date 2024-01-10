import 'package:bars/utilities/exports.dart';

class PriceModel {
  final String id;
  final String price;
  final String name;
  final String value;

  PriceModel({
    required this.price,
    required this.name,
    required this.value,
    required this.id,
  });

  factory PriceModel.fromDoc(DocumentSnapshot doc) {
    return PriceModel(
      id: doc['id'] ?? '',
      name: doc['name']!,
      price: doc['price'] ?? '',
      value: doc['value'] ?? '',
    );
  }

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id']!,
      name: json['name']!,
      price: json['price'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'value': value,
    };
  }
}


