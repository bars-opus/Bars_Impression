import 'package:bars/utilities/exports.dart';

class SelectedSlotModel {
  String id;
  TimeOfDay? selectedSlot;

  String? service;
  String? type;

  SelectedSlotModel({
    required this.id,
    required this.selectedSlot,
    required this.type,
    required this.service,
  });

  factory SelectedSlotModel.fromJson(Map<String, dynamic> json) {
    return SelectedSlotModel(
      id: json['id'],
      selectedSlot: json['selectedSlot'],
      type: json['type'],
      service: json['service'],
      // profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selectedSlot': selectedSlot,
      'type': type,
      'service': service,
      // 'profileImageUrl': profileImageUrl,
    };
  }
}
