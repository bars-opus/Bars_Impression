import 'package:cloud_firestore/cloud_firestore.dart';

class ShopWorkerModel {
  String id;
  final String name;
  final List<String> role;
  final List<String> services;
  final String? profileImageUrl;
  final int? averageRating;

  ShopWorkerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.services,
    required this.profileImageUrl,
    this.averageRating,
  });

  factory ShopWorkerModel.fromDoc(DocumentSnapshot doc) {
    return ShopWorkerModel(
      id: doc.id,
      name: doc['shopName'] ?? '',
      profileImageUrl: doc['profileImageUrl'] ?? '',
      averageRating: doc['averageRating'] ?? '',
      role: List<String>.from(doc['role'] ?? []),
      services: List<String>.from(doc['services'] ?? []),
    );
  }

  factory ShopWorkerModel.fromJson(Map<String, dynamic> json) {
    return ShopWorkerModel(
      id: json['id'],
      name: json['name'],
      role: List<String>.from(json['role']),
      services: List<String>.from(json['services']),
      profileImageUrl: json['profileImageUrl'],
      averageRating: json['averageRating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'services': services,
      'averageRating': averageRating,
      'profileImageUrl': profileImageUrl,
    };
  }
}
