import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

part 'portfolio_contact_model.g.dart'; // Ensure you create this file

@HiveType(typeId: 14) // Choose a unique type ID for this model



class PortfolioContactModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String number;

  PortfolioContactModel({
    required this.id,
    required this.email,
    required this.number,
  });

  factory PortfolioContactModel.fromJson(Map<String, dynamic> json) {
    return PortfolioContactModel(
      id: json['id'],
      email: json['email'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'number': number,
    };
  }
}

