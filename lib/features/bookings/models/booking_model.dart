// The Booking class represents a booking request. It includes fields for the booking details,
// such as the event details, the parties involved, and the status of the booking.
//  If the calendar is meant to show confirmed bookings, you would display the booking model.
// Target User: Both creatives and organizers.
// Displayed Data: Dates and times of confirmed bookings.
// Purpose: To keep track of when events are scheduled and avoid double-booking.

import 'package:bars/features/creatives/models/Price_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id;
  String creativeId;
  String clientId;
  bool isEvent;
  final Timestamp bookingDate;
  final String reviewComment;
  final String termsAndConditions;
  String location;
  String description;
  String specialRequirements;
  String answer;
  PriceModel priceRate;
  bool isFinalPaymentMade;
  bool isdownPaymentMade;
  // final String serviceStatus;
  String cancellationReason;
  Timestamp startTime;
  Timestamp endTime;
  final int rating;
  final Timestamp timestamp;
    final bool reNogotiate;

  Timestamp? arrivalScanTimestamp;
  Timestamp? departureScanTimestamp;

  BookingModel({
    required this.id,
    required this.creativeId,
    required this.clientId,
    required this.isEvent,
    required this.bookingDate,
    required this.location,
    required this.description,
    required this.answer,
    required this.priceRate,
    required this.isFinalPaymentMade,
    required this.rating,
    required this.reviewComment,
    required this.termsAndConditions,
    required this.timestamp,
    required this.cancellationReason,
    required this.startTime,
    required this.endTime,
    required this.reNogotiate,
    required this.specialRequirements,
    required this.isdownPaymentMade,
    this.arrivalScanTimestamp,
    this.departureScanTimestamp,
  });

  factory BookingModel.fromDoc(DocumentSnapshot doc) {
    return BookingModel(
      id: doc.id,
      creativeId: doc['creativeId'],
      clientId: doc['clientId'] ?? '',
      rating: doc['rating'] ?? 0,
      cancellationReason: doc['cancellationReason'] ?? '',
      isEvent: doc['isEvent'] ?? false,
      termsAndConditions: doc['termsAndConditions'] ?? '',
      bookingDate: doc['bookingDate'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      location: doc['location'] ?? '',
      reNogotiate: doc['reNogotiate'] ?? false,
      description: doc['description'] ?? '',
      reviewComment: doc['reviewComment'] ?? '',
      specialRequirements: doc['specialRequirements'] ?? '',
      answer: doc['answer'] ?? '',
      priceRate: PriceModel.fromJson(doc['priceRate'] ?? {}),
      isFinalPaymentMade: doc['isFinalPaymentMade'] ?? false,
      isdownPaymentMade: doc['isdownPaymentMade'] ?? false,
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      startTime: doc['startTime'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      endTime: doc['endTime'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      arrivalScanTimestamp: doc['arrivalScanTimestamp'],
      departureScanTimestamp: doc['departureScanTimestamp'],
    );
  }

  // Deserialization
  factory BookingModel.fromJson(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      creativeId: map['creativeId'],
      clientId: map['clientId'],
      isEvent: map['isEvent'],
      rating: map['rating'],
      termsAndConditions: map['termsAndConditions'],
      cancellationReason: map['cancellationReason'],
      bookingDate: map['bookingDate'] ?? Timestamp.fromDate(DateTime.now()),
      reviewComment: map['reviewComment'],
      location: map['location'],
      description: map['description'],
      specialRequirements: map['specialRequirements'],
      answer: map['answer'],
      reNogotiate: map['reNogotiate'],
      priceRate: PriceModel.fromJson(map['priceRate'] ?? {}),
      isFinalPaymentMade: map['isFinalPaymentMade'],
      isdownPaymentMade: map['isdownPaymentMade'],
      timestamp: map['timestamp'] ?? Timestamp.fromDate(DateTime.now()),
      startTime: map['startTime'] ?? Timestamp.fromDate(DateTime.now()),
      endTime: map['endTime'] ?? Timestamp.fromDate(DateTime.now()),
      arrivalScanTimestamp: map['arrivalScanTimestamp'],
      departureScanTimestamp: map['departureScanTimestamp'],
    );
  }

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creativeId': creativeId,
      'rating': rating,
      'reviewComment': reviewComment,
      'termsAndConditions': termsAndConditions,
      'clientId': clientId,
      'isEvent': isEvent,
      'bookingDate': bookingDate,
      'location': location,
      'description': description,
      'specialRequirements': specialRequirements,
      'cancellationReason': cancellationReason,
      'answer': answer,
      'isdownPaymentMade': isdownPaymentMade,
      'reNogotiate': reNogotiate,
      'priceRate': priceRate.toJson(),
      'isFinalPaymentMade': isFinalPaymentMade,
      'timestamp': timestamp,
      'startTime': startTime,
      'endTime': endTime,
      'arrivalScanTimestamp': arrivalScanTimestamp,
      'departureScanTimestamp': departureScanTimestamp,
    };
  }
}
