import 'package:bars/utilities/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkRequestOrOfferModel {
  final String id;
  final String userId;
  final bool isEvent;
  final String overView;
  final List<String> genre; // This may refer to hiphop, afor beat, cracking
  final List<String> type; // types of events to perfrom at.
  final List<String>
      availableLocations; // available locations to perform at eg, Tema, Las Angeles e.t.c
  final double price; // Pries per performance
  final String currency; //
  final Timestamp? timestamp;

  WorkRequestOrOfferModel({
    required this.id,
    required this.userId,
    required this.overView,
    required this.genre,
    required this.type,
    required this.availableLocations,
    required this.price,
    required this.currency,
    required this.isEvent,
    required this.timestamp,
  });

  factory WorkRequestOrOfferModel.fromDoc(DocumentSnapshot doc) {
    return WorkRequestOrOfferModel(
      id: doc['id']!,
      userId: doc['userId']!,
      genre: (doc['genre'] as List<dynamic>?)
              ?.map((genre) => genre.toString())
              .toList() ??
          [],
      isEvent: doc['isEvent'] ?? false,
      timestamp: doc['timestamp'] as Timestamp?,
      currency: doc['currency'] ?? '',
      overView: doc['overView'] ?? '',
      type: (doc['type'] as List<dynamic>?)
              ?.map((type) => type.toString())
              .toList() ??
          [],
      availableLocations: List<String>.from(doc['availableLocations'] ?? []),
      price: doc['price'] ?? 0.0,
    );
  }

  factory WorkRequestOrOfferModel.fromJson(Map<String, dynamic> json) {
    return WorkRequestOrOfferModel(
      id: json['id']!,
      userId: json['userId']!,
      genre: (json['genre'] as List<dynamic>?)
              ?.map((genre) => genre.toString())
              .toList() ??
          [],
      isEvent: json['isEvent'] ?? false,
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      currency: json['currency'] ?? '',
      overView: json['overView'] ?? '',
      type: (json['type'] as List<dynamic>?)
              ?.map((type) => type.toString())
              .toList() ??
          [],
      availableLocations: List<String>.from(json['availableLocations'] ?? []),
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'genre': genre,
      'isEvent': isEvent,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'currency': currency,
      'overView': overView,
      'type': type,
      'availableLocations': availableLocations,
      'price': price,
    };
  }
}
