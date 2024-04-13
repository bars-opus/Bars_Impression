import 'package:bars/utilities/exports.dart';

class TicketPurchasedModel {
  final String id;
  final String entranceId;
  double price;
  bool isSold;
  String refundRequestStatus;
  String idempotencyKey;
  String type;
  String group;
  String accessLevel;
  bool validated;
  final String transactionId;
  final Timestamp eventTicketDate;
  final Timestamp lastTimeScanned;

  int row;
  int seat;

  TicketPurchasedModel({
    required this.id,
    required this.price,
    required this.refundRequestStatus,
    this.isSold = false,
    required this.validated,
    required this.type,
    required this.group,
    this.accessLevel = 'General',
    required this.row,
    required this.seat,
    required this.eventTicketDate,
    required this.lastTimeScanned,
    required this.entranceId,
    required this.transactionId,
    required this.idempotencyKey,
  });

  factory TicketPurchasedModel.fromJson(Map<String, dynamic> json) {
    return TicketPurchasedModel(
      id: json['id'],
      price: json['price'].toDouble(),
      isSold: json['isSold'] ?? false,
      refundRequestStatus: json['refundRequestStatus'] ?? '',
      idempotencyKey: json['idempotencyKey'] ?? '',
      transactionId: json['transactionId'] ?? '',
      validated: json['validated'] ?? false,
      type: json['type'],
      group: json['group'],
      accessLevel: json['accessLevel'] ?? 'General',
      row: json['row'],
      seat: json['seat'],
      eventTicketDate: json['eventTicketDate'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      lastTimeScanned: json['lastTimeScanned'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      entranceId: json['entranceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'isSold': isSold,
      'transactionId': transactionId,
      'refundRequestStatus': refundRequestStatus,
      'idempotencyKey': idempotencyKey,
      'type': type,
      'group': group,
      'accessLevel': accessLevel,
      'validated': validated,
      'row': row,
      'seat': seat,
      'entranceId': entranceId,
      'eventTicketDate': eventTicketDate,
      'lastTimeScanned': lastTimeScanned,
    };
  }

  // A method to convert a TicketModel to a TicketPurchasedModel
  static TicketPurchasedModel fromTicketModel({
    required TicketModel ticketModel,
    required String entranceId,
    required bool validated,
    required String transactionId,
    required int row,
    required int seat,
    required String refundRequestStatus,
    required String idempotencyKey,
    required Timestamp lastTimeScanned,
  }) {
    return TicketPurchasedModel(
      id: ticketModel.id,
      price: ticketModel.price,
      isSold: ticketModel.isSoldOut,
      refundRequestStatus: refundRequestStatus,
      idempotencyKey: idempotencyKey,
      validated: validated,
      type: ticketModel.type,
      transactionId: transactionId,
      group: ticketModel.group,
      accessLevel: ticketModel.accessLevel,
      row: row,
      seat: seat,
      eventTicketDate: ticketModel.eventTicketDate,
      lastTimeScanned: lastTimeScanned,
      entranceId: entranceId,
    );
  }
}
