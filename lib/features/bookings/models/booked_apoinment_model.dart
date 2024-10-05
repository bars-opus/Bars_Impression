import 'package:bars/utilities/exports.dart';

class BookedAppointmentModel {
  final String id;
  // final String entranceId;
  double price;
  // bool isSold;
  WorkersModel woker;
  String service;
  String type;
  String duruation;
  String idempotencyKey;

  // String service;
  // bool validated;
  final String transactionId;
  // final Timestamp eventTicketDate;
  // final Timestamp lastTimeScanned;

  // int row;
  // int seat;

  BookedAppointmentModel({
    // this.isSold = false,
    // this.service = 'General',
    required this.id,
    required this.price,
    required this.woker,
    required this.service,
    required this.type,
    required this.duruation,
    required this.idempotencyKey,
    required this.transactionId,
  });

  factory BookedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookedAppointmentModel(
      id: json['id'],
      price: json['price'].toDouble(),
      // isSold: json['isSold'] ?? false,
      woker: json['woker'] ?? '',
      idempotencyKey: json['idempotencyKey'] ?? '',
      transactionId: json['transactionId'] ?? '',
      // validated: json['validated'] ?? false,
      type: json['type'],
      duruation: json['duruation'],
      service: json['service'] ?? 'General',
      // row: json['row'],
      // seat: json['seat'],
      // eventTicketDate: json['eventTicketDate'] ??
      //     Timestamp.fromDate(
      //       DateTime.now(),
      //     ),
      // lastTimeScanned: json['lastTimeScanned'] ??
      //     Timestamp.fromDate(
      //       DateTime.now(),
      //     ),
      // entranceId: json['entranceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      // 'isSold': isSold,
      'transactionId': transactionId,
      // 'refundRequestStatus': refundRequestStatus,
      'idempotencyKey': idempotencyKey,
      'type': type,
      'duruation': duruation,
      // 'accessLevel': accessLevel,
      // 'validated': validated,
      // 'row': row,
      // 'seat': seat,
      // 'entranceId': entranceId,
      // 'eventTicketDate': eventTicketDate,
      // 'lastTimeScanned': lastTimeScanned,
    };
  }

  // A method to convert a TicketModel to a BookedAppointmentModel
  static BookedAppointmentModel fromTicketModel({
    required AppointmentSlotModel ticketModel,
    required WorkersModel woker,
    // required bool validated,
    required String transactionId,
    // required int row,
    // required int seat,
    required String service,
    required String idempotencyKey,
    required Timestamp lastTimeScanned,
  }) {
    return BookedAppointmentModel(
      id: ticketModel.id,
      price: ticketModel.price,
      // isSold: ticketModel.isSoldOut,
      // refundRequestStatus: refundRequestStatus,
      idempotencyKey: idempotencyKey,
      // validated: validated,
      type: ticketModel.type,
      transactionId: transactionId,
      duruation: ticketModel.duruation, woker: woker, service: service,
      // accessLevel: ticketModel.accessLevel,
      // row: row,
      // seat: seat,
      // eventTicketDate: ticketModel.eventTicketDate,
      // lastTimeScanned: lastTimeScanned,
      // entranceId: entranceId,
    );
  }
}
