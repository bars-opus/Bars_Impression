import 'package:bars/utilities/exports.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_settings_loading_preference_model.g.dart';

// This settinfs model is considered user prefernece for querying contents
// based on a users information such as location and currency

@HiveType(typeId: 10) // Use unique IDs for different classes

class UserSettingsLoadingPreferenceModel {
  @HiveField(0)
  final String? city;
  @HiveField(1)
  final String? country;
  @HiveField(2)
  final String? continent;
  @HiveField(3)
  final String? currency;
  @HiveField(4)
  final String? userId;
  @HiveField(5)
  final Timestamp? timestamp;
  @HiveField(6)
  final String? subaccountId;
  @HiveField(8)
  final String? transferRecepientId;

  UserSettingsLoadingPreferenceModel({
    required this.city,
    required this.country,
    required this.continent,
    required this.userId,
    required this.currency,
    required this.timestamp,
    required this.subaccountId,
    required this.transferRecepientId,
  });

  factory UserSettingsLoadingPreferenceModel.fromDoc(DocumentSnapshot doc) {
    return UserSettingsLoadingPreferenceModel(
      userId: doc.id,
      country: doc['country'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.fromDate(DateTime.now()),
      continent: doc['continent'],
      city: doc['city'] ?? '',
      currency: doc['currency'] ?? '',
      subaccountId: doc['subaccountId'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
    );
  }

  factory UserSettingsLoadingPreferenceModel.fromFirestore(
      DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserSettingsLoadingPreferenceModel(
      userId: doc.id,
      timestamp: doc['timestamp'] ?? Timestamp.fromDate(DateTime.now()),
      country: data['country'] ?? '',
      continent: data['continent'],
      city: data['city'] ?? '',
      currency: data['currency'] ?? '',
      subaccountId: data['subaccountId'] ?? '',
      transferRecepientId: data['transferRecepientId'] ?? '',
    );
  }
}
