import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateApp {
  final String? id;
  final Timestamp? timeStamp;
  final String? updateNote;
  final bool? updateIsAvailable;
  final bool? displayMiniUpdate;
  final bool? displayFullUpdate;
  final int? updateVersionIos;
  final int? updateVersionAndroid;

  UpdateApp({
    required this.id,
    required this.updateIsAvailable,
    required this.updateNote,
    required this.displayFullUpdate,
    required this.displayMiniUpdate,
    required this.updateVersionIos,
    required this.updateVersionAndroid,
    required this.timeStamp,
  });

  factory UpdateApp.fromDoc(DocumentSnapshot doc) {
    return UpdateApp(
      id: doc.id,
      updateNote: doc['updateNote'] ?? '',
      updateIsAvailable: doc['updateIsAvailable'] ?? false,
      displayFullUpdate: doc['displayFullUpdate'] ?? false,
      displayMiniUpdate: doc['displayMiniUpdate'] ?? false,
      updateVersionIos: doc['updateVersionIos'] ?? 0,
      updateVersionAndroid: doc['updateVersionAndroid'] ?? 0,
      timeStamp: doc['timeStamp'],
    );
  }
}
