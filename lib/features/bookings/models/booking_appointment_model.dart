import 'package:bars/features/bookings/models/booked_apoinment_model.dart';
import 'package:bars/utilities/exports.dart';

class BookingAppointmentModel {
  String id;
  String shopId;
  String clientId;
  final List<BookedAppointmentModel> appointment;
  final Timestamp bookingDate;
  final String reviewComment;
  final String termsAndConditions;
  String location;
  String specialRequirements;
  bool isFinalPaymentMade;
  bool isdownPaymentMade;
  String cancellationReason;
  Timestamp startTime;
  Timestamp endTime;
  final int rating;
  final Timestamp timestamp;

  BookingAppointmentModel({
    required this.id,
    required this.shopId,
    required this.clientId,
    required this.appointment,
    required this.bookingDate,
    required this.location,
    required this.isFinalPaymentMade,
    required this.rating,
    required this.reviewComment,
    required this.termsAndConditions,
    required this.timestamp,
    required this.cancellationReason,
    required this.startTime,
    required this.endTime,
    required this.specialRequirements,
    required this.isdownPaymentMade,
  });

  factory BookingAppointmentModel.fromDoc(DocumentSnapshot doc) {
    return BookingAppointmentModel(
      id: doc.id,
      shopId: doc['shopId'],
      clientId: doc['clientId'] ?? '',
      appointment: (doc['appointment'] as List)
          .map((e) => BookedAppointmentModel.fromJson(e))
          .toList(),
      bookingDate: doc['bookingDate'],
      location: doc['location'] ?? '',
      isFinalPaymentMade: doc['isFinalPaymentMade'] ?? false,
      rating: doc['rating'] ?? 0,
      reviewComment: doc['reviewComment'] ?? '',
      termsAndConditions: doc['termsAndConditions'] ?? '',
      timestamp: doc['timestamp'],
      cancellationReason: doc['cancellationReason'] ?? '',
      startTime: doc['startTime'],
      endTime: doc['endTime'],
      specialRequirements: doc['specialRequirements'] ?? '',
      isdownPaymentMade: doc['isdownPaymentMade'] ?? false,
    );
  }

  factory BookingAppointmentModel.fromJson(Map<String, dynamic> map) {
    return BookingAppointmentModel(
      id: map['id'],
      shopId: map['shopId'],
      clientId: map['clientId'],
      appointment: (map['appointment'] as List)
          .map((e) => BookedAppointmentModel.fromJson(e))
          .toList(),
      bookingDate: map['bookingDate'],
      location: map['location'],
      isFinalPaymentMade: map['isFinalPaymentMade'],
      rating: map['rating'],
      reviewComment: map['reviewComment'],
      termsAndConditions: map['termsAndConditions'],
      timestamp: map['timestamp'],
      cancellationReason: map['cancellationReason'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      specialRequirements: map['specialRequirements'],
      isdownPaymentMade: map['isdownPaymentMade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'clientId': clientId,
      'appointment': appointment.map((e) => e.toJson()).toList(),
      'bookingDate': bookingDate,
      'location': location,
      'isFinalPaymentMade': isFinalPaymentMade,
      'rating': rating,
      'reviewComment': reviewComment,
      'termsAndConditions': termsAndConditions,
      'timestamp': timestamp,
      'cancellationReason': cancellationReason,
      'startTime': startTime,
      'endTime': endTime,
      'specialRequirements': specialRequirements,
      'isdownPaymentMade': isdownPaymentMade,
    };
  }
}
