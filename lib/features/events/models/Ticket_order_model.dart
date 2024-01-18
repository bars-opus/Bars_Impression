import 'package:bars/utilities/exports.dart';

class TicketOrderModel {
  final String orderId;
  final String userOrderId;
  final String eventId;
  final String orderNumber;
  final List<TicketPurchasedModel> tickets;
  final double total;
  final bool isInvited;
  final String eventImageUrl;
  final String eventTitle;
  final String purchaseReferenceId;
  final String transactionId;
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
    required this.transactionId,
  });

  factory TicketOrderModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError(
          'Document data is missing and cannot be converted to TicketOrderModel.');
    }
    return TicketOrderModel(
      orderId: data['orderId'] ?? '',
      refundRequestStatus: data['refundRequestStatus'] ?? '',
      transactionId: data['transactionId'] ?? '',
      eventId: data['eventId'] ?? '',
      timestamp:
          data['timestamp'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
      eventTimestamp: data['eventTimestamp'] as Timestamp? ??
          Timestamp.fromDate(DateTime.now()),
      eventTitle: data['eventTitle'] ?? '',
      eventImageUrl: data['eventImageUrl'] ?? '',
      purchaseReferenceId: data['purchaseReferenceId'] ?? '',
      isInvited: data['isInvited'] ?? false,
      orderNumber: data['orderNumber'] ?? '',
      tickets: (data['tickets'] as List<dynamic>?)
              ?.map((ticket) =>
                  TicketPurchasedModel.fromJson(ticket as Map<String, dynamic>))
              .toList() ??
          [],
      total: (data['total'] as num?)?.toDouble() ??
          0.0, // Provide a default value of 0.0 if the field is missing
      userOrderId: data['userOrderId'] ??
          '', // provide a default value or handle the error if this field is required
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

      transactionId: json['transactionId'] ?? '',

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
      'transactionId': transactionId,
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
