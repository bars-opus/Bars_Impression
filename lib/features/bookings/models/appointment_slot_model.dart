// The Availability model will capture the availability schedule of a creative.
// It should be designed to efficiently handle and query availability data.
// If the calendar is meant to show when a creative (e.g., a service provider)
//  is available, you would display the availability model.
// Target User: Organizer (someone looking to book a creative).
// Displayed Data: Dates and times when the creative is available.
// Purpose: To help organizers find and select available slots for booking.

import 'package:bars/utilities/exports.dart';

class AppointmentSlotModel {
  String id;
  List<String> days;
  final String duruation;
  final String type;
  final String service;
  final double price;
  bool favoriteWorker;
  final List<ShopWorkerModel> workers;

  AppointmentSlotModel({
    required this.id,
    required this.days,
    required this.favoriteWorker,
    required this.type,
    required this.duruation,
    required this.service,
    required this.workers,
    required this.price,
  });

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotModel(
      id: json['id'],
      days: json['days'] != null
          ? List<String>.from(json['days'])
          : [], // Provide an empty list if json['days'] is null
      price: json['price']?.toDouble() ?? 0.0, // Ensure price is double
      type: json['type'] ?? '',
      duruation: json['duruation'] ?? '',
      favoriteWorker: json['favoriteWorker'] ?? false,
      service: json['service'] ?? '', // Provide a default value if null
      workers: (json['workers'] as List<dynamic>?)
              ?.map((worker) => ShopWorkerModel.fromJson(worker))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': days,
      'price': price,
      'duruation': duruation,
      'type': type,
      'favoriteWorker': favoriteWorker,
      'service': service,
      'workers': workers.map((worker) => worker.toJson()).toList(),
    };
  }
}
