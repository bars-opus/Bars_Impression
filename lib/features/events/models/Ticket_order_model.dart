import 'package:bars/utilities/exports.dart';

class TicketOrderModel {
  final String orderId;
  final String userOrderId;
  final String eventId;
  // final String entranceId;
  final String orderNumber;
  final List<TicketPurchasedModel> tickets;
  final double total;
  final bool isInvited;
  final String eventImageUrl;
  final String eventTitle;
  // final bool validated;
  final String purchaseReferenceId;
  final String refundRequestStatus;

  final Timestamp? timestamp;
  final Timestamp? eventTimestamp;

  TicketOrderModel({
    required this.orderNumber,
    required this.eventId,
    // required this.entranceId,
    required this.eventImageUrl,
    // required this.validated,
    required this.timestamp,
    required this.eventTimestamp,
    required this.orderId,
    required this.userOrderId,
    required this.tickets,
    required this.total,
    required this.isInvited,
    required this.eventTitle,
    required this.purchaseReferenceId,
    required this.refundRequestStatus,
  });

  factory TicketOrderModel.fromDoc(DocumentSnapshot doc) {
    return TicketOrderModel(
      orderId: doc['orderId'] ?? '',
      refundRequestStatus: doc['refundRequestStatus'] ?? '',
      eventId: doc['eventId']!,
      // validated: doc['validated'] ?? false,
      timestamp: doc['timestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      eventTimestamp: doc['eventTimestamp'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      // entranceId: doc['entranceId'] ?? '',
      eventTitle: doc['eventTitle'] ?? '',
      eventImageUrl: doc['eventImageUrl'] ?? '',
      purchaseReferenceId: doc['purchaseReferenceId'] ?? '',
      isInvited: doc['isInvited'] ?? false,
      orderNumber: doc['orderNumber']!,
      tickets: (doc['tickets'] as List<dynamic>?)
              ?.map((ticket) => TicketPurchasedModel.fromJson(ticket))
              .toList() ??
          [],
      total: (doc['total'] as num).toDouble(),
      userOrderId: doc['userOrderId']!,
    );
  }

  factory TicketOrderModel.fromJson(Map<String, dynamic> json) {
    return TicketOrderModel(
      orderId: json['orderId']!,
      eventId: json['eventId']!,
      // validated: json['validated'] ?? false,
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      eventTimestamp: json['eventTimestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['eventTimestamp'])
          : null,
      // entranceId: json['entranceId'] ?? '',
      refundRequestStatus: json['refundRequestStatus'] ?? '',
      eventImageUrl: json['eventImageUrl'] ?? '',
      eventTitle: json['eventTitle'] ?? '',
      isInvited: json['isInvited'] ?? false,
      orderNumber: json['orderNumber']!,
      tickets: (json['tickets'] as List<dynamic>?)
              ?.map((ticket) => TicketPurchasedModel.fromJson(ticket))
              .toList() ??
          [],
      total: json['total'] ?? 0.0,
      userOrderId: json['userOrderId']!,
      purchaseReferenceId: json['purchaseReferenceId']!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'eventId': eventId,
      // 'validated': validated,
      'timestamp': timestamp,
      'eventTimestamp': eventTimestamp,
      // 'entranceId': entranceId,
      'refundRequestStatus': refundRequestStatus,
      'eventImageUrl': eventImageUrl,
      'isInvited': isInvited,
      'purchaseReferenceId': purchaseReferenceId,
      'orderNumber': orderNumber,
      'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
      'total': total,
      'userOrderId': userOrderId,
      'eventTitle': eventTitle,
    };
  }
}
