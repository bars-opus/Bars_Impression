import 'package:bars/utilities/exports.dart';

class BookedAppointmentModel {
  final String id;
  double price;
  final List<ShopWorkerModel> workers;
  String service;
  String type;
  String duruation;
  TimeOfDay? selectedSlot;

  BookedAppointmentModel({
    required this.id,
    required this.price,
    required this.workers,
    required this.service,
    required this.type,
    required this.duruation,
    required this.selectedSlot,
  });

  factory BookedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookedAppointmentModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      workers: (json['workers'] as List<dynamic>?)
              ?.map((worker) => ShopWorkerModel.fromJson(worker))
              .toList() ??
          [],
      service: json['service'] ?? 'General',
      type: json['type'],
      duruation: json['duruation'],
      selectedSlot: json['selectedSlot'] != null
          ? TimeOfDay(
              hour: json['selectedSlot']['hour'],
              minute: json['selectedSlot']['minute'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'workers': workers.map((worker) => worker.toJson()).toList(),
      'service': service,
      'type': type,
      'duruation': duruation,
      'selectedSlot': selectedSlot != null
          ? {'hour': selectedSlot!.hour, 'minute': selectedSlot!.minute}
          : null,
    };
  }

  static BookedAppointmentModel fromTicketModel({
    required AppointmentSlotModel ticketModel,
    required ShopWorkerModel woker,
    required String transactionId,
    required String service,
    required List<ShopWorkerModel> workers,
    required String idempotencyKey,
    required Timestamp lastTimeScanned,
    required TimeOfDay? selectedSlot,
  }) {
    return BookedAppointmentModel(
      id: ticketModel.id,
      price: ticketModel.price,
      type: ticketModel.type,
      selectedSlot: selectedSlot,
      duruation: ticketModel.duruation,
      workers: workers,
      service: service,
    );
  }
}

// class BookedAppointmentModel {
//   final String id;
//   double price;
//   final List<ShopWorkerModel> workers;
//   String service;
//   String type;
//   String duruation;
//   TimeOfDay? selectedSlot;

//   BookedAppointmentModel({
//     required this.id,
//     required this.price,
//     required this.workers,
//     required this.service,
//     required this.type,
//     required this.duruation,
//     required this.selectedSlot,
//   });

//   factory BookedAppointmentModel.fromJson(Map<String, dynamic> json) {
//     return BookedAppointmentModel(
//       id: json['id'],
//       // selectedSlot: json['selectedSlot'],
//       selectedSlot: json['selectedSlot'] != null
//           ? TimeOfDay(
//               hour: json['selectedSlot']['hour'],
//               minute: json['selectedSlot']['minute'],
//             )
//           : null,
//       price: json['price'].toDouble(),
//       workers: (json['workers'] as List<dynamic>?)
//               ?.map((worker) => ShopWorkerModel.fromJson(worker))
//               .toList() ??
//           [],
//       type: json['type'],
//       duruation: json['duruation'],
//       service: json['service'] ?? 'General',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'price': price,
//       'type': type,
//       'duruation': duruation,
//       'selectedSlot': selectedSlot != null
//           ? {'hour': selectedSlot!.hour, 'minute': selectedSlot!.minute}
//           : null,
//       // 'selectedSlot': selectedSlot,
//     };
//   }

//   // A method to convert a TicketModel to a BookedAppointmentModel
//   static BookedAppointmentModel fromTicketModel({
//     required AppointmentSlotModel ticketModel,
//     required ShopWorkerModel woker,
//     required String transactionId,
//     required String service,
//     required List<ShopWorkerModel> workers,
//     required String idempotencyKey,
//     required Timestamp lastTimeScanned,
//     required TimeOfDay? selectedSlot,
//   }) {
//     return BookedAppointmentModel(
//       id: ticketModel.id,
//       price: ticketModel.price,
//       type: ticketModel.type,
//       selectedSlot: selectedSlot,
//       duruation: ticketModel.duruation,
//       workers: workers,
//       service: service,
//     );
//   }
// }
