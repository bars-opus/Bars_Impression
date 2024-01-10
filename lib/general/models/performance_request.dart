import 'package:bars/utilities/exports.dart';


class PerformanceRequest {
  final String userId;
  final String info;

  final String availableTime;
  final String performanceDuration;
  final String performanceType;
  final String genre;
  final List<String> availableDays;
  final List<String> eventTypes;

  final List<String> availableLocations;
  final List<PriceModel> price;
  final String answer;
  final bool validated;
  final Timestamp? timestamp;

  PerformanceRequest({
    required this.availableTime,
    required this.userId,
    required this.info,
    required this.performanceDuration,
    required this.performanceType,
    required this.genre,
    required this.availableDays,
    required this.eventTypes,
    required this.availableLocations,
    required this.price,
    required this.answer,
    required this.validated,
    required this.timestamp,
  });

  factory PerformanceRequest.fromDoc(DocumentSnapshot doc) {
    return PerformanceRequest(
      userId: doc['userId']!,
      performanceDuration: doc['performanceDuration']!,
      performanceType: doc['performanceType']!,
      genre: doc['genre']!,
      validated: doc['validated'] ?? false,
      timestamp: doc['timestamp'] as Timestamp?,
      answer: doc['answer'] ?? '',
      info: doc['info'] ?? '',
      availableDays: List<String>.from(doc['availableDays'] ?? []),
      eventTypes: (doc['eventTypes'] as List<dynamic>?)
              ?.map((eventTypes) => eventTypes.toString())
              .toList() ?? [],
      availableLocations: List<String>.from(doc['availableLocations'] ?? []),
      price: (doc['price'] as List<dynamic>?)
              ?.map((price) => PriceModel.fromJson(price))
              .toList() ?? [],
      availableTime: doc['availableTime'] ?? '',
    );
  }

  factory PerformanceRequest.fromJson(Map<String, dynamic> json) {
    return PerformanceRequest(
      userId: json['userId']!,
      performanceDuration: json['performanceDuration']!,
      performanceType: json['performanceType']!,
      genre: json['genre']!,
      validated: json['validated'] ?? false,
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      answer: json['answer'] ?? '',
      info: json['info'] ?? '',
      availableDays: List<String>.from(json['availableDays'] ?? []),
      eventTypes: (json['eventTypes'] as List<dynamic>?)
              ?.map((eventTypes) => eventTypes.toString())
              .toList() ?? [],
      availableLocations: List<String>.from(json['availableLocations'] ?? []),
      price: (json['price'] as List<dynamic>?)
              ?.map((price) => PriceModel.fromJson(price))
              .toList() ?? [],
      availableTime: json['availableTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'performanceDuration': performanceDuration,
      'performanceType': performanceType,
      'genre': genre,
      'validated': validated,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'answer': answer,
      'info': info,
      'availableDays': availableDays,
      'eventTypes': eventTypes,
      'availableLocations': availableLocations,
      'price': price.map((p) => p.toJson()).toList(),
      'availableTime': availableTime,
    };
  }
}
