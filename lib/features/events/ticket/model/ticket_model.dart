import 'package:bars/utilities/exports.dart';

class TicketModel {
  String id;
  double price;
  bool isSoldOut;
  String type;
  String group;
  String accessLevel;
  final Timestamp eventTicketDate;
  int maxOder; // new property for the number of available tickets
  int salesCount; // new property for the number of available tickets
  int maxSeatsPerRow; // New property for the seat number

  TicketModel({
    required this.id,
    required this.price,
    this.isSoldOut = false,
    required this.type,
    required this.group,
    this.accessLevel = 'General',
    required this.maxOder,
    required this.maxSeatsPerRow,
    required this.salesCount,
    required this.eventTicketDate,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      price: json['price'].toDouble(),
      isSoldOut: json['isSoldOut'] ?? false,
      // isRefundable: json['isRefundable'] ?? false,
      type: json['type'],
      group: json['group'],
      accessLevel: json['accessLevel'] ?? 'General',
      maxOder: json['maxOder'],
      salesCount: json['salesCount'],

      maxSeatsPerRow: json['maxSeatsPerRow'],
      eventTicketDate: json['eventTicketDate'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
    );
  }

  factory TicketModel.fromJsonSharedPref(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      isSoldOut: json['isSoldOut'] ?? false,
      type: json['type'],
      group: json['group'],
      accessLevel: json['accessLevel'] ?? 'General',
      maxOder: json['maxOder'],
      salesCount: json['salesCount'],
      maxSeatsPerRow: json['maxSeatsPerRow'],
      eventTicketDate:
          Timestamp.fromMillisecondsSinceEpoch(json['eventTicketDate'] ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'isSoldOut': isSoldOut,
      // 'isRefundable': isRefundable,
      'type': type,
      'group': group,
      'accessLevel': accessLevel,
      'maxOder': maxOder,
      'salesCount': salesCount,

      'maxSeatsPerRow': maxSeatsPerRow,
      // 'eventTicketDate': eventTicketDate.millisecondsSinceEpoch,

      'eventTicketDate': eventTicketDate,
    };
  }

  Map<String, dynamic> toJsonSharedPref() {
    return {
      'id': id,
      'price': price,
      'isSoldOut': isSoldOut,
      // 'isRefundable': isRefundable,
      'type': type,
      'group': group,
      'accessLevel': accessLevel,
      'maxOder': maxOder,
      'salesCount': salesCount,

      'maxSeatsPerRow': maxSeatsPerRow,
      'eventTicketDate': eventTicketDate.millisecondsSinceEpoch,

      // 'eventTicketDate': eventTicketDate,
    };
  }
}
