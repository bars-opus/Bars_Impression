import 'package:hive/hive.dart';

import 'package:bars/utilities/exports.dart';

// part 'price_order_model.g.dart';

@HiveType(typeId: 13)
class PriceModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String price;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String value;
  @HiveField(4)
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
