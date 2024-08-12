import 'package:bars/utilities/exports.dart';

class UserSettingsGeneralModel {
  final bool? disableChat;
  final bool? privateAccount;
  final bool? disableAdvice;
  final bool? hideAdvice;
  final bool? disableBooking;
  final bool? disabledAccount;
final bool? isEmailVerified;
  final bool? disableEventSuggestionNotification;
  final bool? muteEventSuggestionNotification;
  final String? androidNotificationToken;
  final String? userId;
  final List<String>
      preferredEventTypes; // e.g., ["Concert", "Theatre", "Sport"]
  final List<String>
      preferredCreatives; // e.g., ["Concert", "Theatre", "Sport"]
  final bool
      disableNewCreativeNotifications; // Receive notifications for new events
  final bool
      disableWorkVacancyNotifications; // Receive notifications for new events
  final bool
      muteWorkVacancyNotifications; // Receive notifications for new events
  final String? report;
  final bool? reportConfirmed;

  UserSettingsGeneralModel({
    required this.disableChat,
    required this.privateAccount,
    required this.disableAdvice,
    required this.hideAdvice,
    required this.disableBooking,
    required this.disabledAccount,
    required this.isEmailVerified,
    required this.disableEventSuggestionNotification,
    required this.preferredCreatives,
    required this.muteEventSuggestionNotification,
    required this.androidNotificationToken,
    required this.preferredEventTypes,
    required this.disableNewCreativeNotifications,
    required this.disableWorkVacancyNotifications,
    required this.muteWorkVacancyNotifications,
    required this.report,
    required this.reportConfirmed,
    required this.userId,
  });

  factory UserSettingsGeneralModel.fromDoc(DocumentSnapshot doc) {
    return UserSettingsGeneralModel(
      disableChat: doc['disableChat'],
      privateAccount: doc['privateAccount'],
      disableAdvice: doc['disableAdvice'],
      hideAdvice: doc['hideAdvice'],
      disableBooking: doc['disableBooking'],
      disabledAccount: doc['disabledAccount'],
      isEmailVerified: doc['isEmailVerified'],
      disableEventSuggestionNotification: doc['disableEventSuggestionNotification'],
      muteEventSuggestionNotification: doc['muteEventSuggestionNotification'],
      androidNotificationToken: doc['androidNotificationToken'],
      userId: doc['userId'],
      preferredEventTypes: List<String>.from(doc['preferredEventTypes']),
      preferredCreatives: List<String>.from(doc['preferredCreatives']),
      disableNewCreativeNotifications: doc['disableNewCreativeNotifications'],
      disableWorkVacancyNotifications: doc['disableWorkVacancyNotifications'],
      muteWorkVacancyNotifications: doc['muteWorkVacancyNotifications'],
      report: doc['report'],
      reportConfirmed: doc['reportConfirmed'],
    );
  }

  factory UserSettingsGeneralModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserSettingsGeneralModel(
      disableChat: data['disableChat'],
      privateAccount: data['privateAccount'],
      disableAdvice: data['disableAdvice'],
      hideAdvice: data['hideAdvice'],
      disableBooking: data['disableBooking'],
      disabledAccount: data['disabledAccount'],
      isEmailVerified: data['isEmailVerified'],
      disableEventSuggestionNotification:
          data['disableEventSuggestionNotification'],
      muteEventSuggestionNotification: data['muteEventSuggestionNotification'],
      androidNotificationToken: data['androidNotificationToken'],
      userId: data['userId'],
      preferredEventTypes: List<String>.from(data['preferredEventTypes']),
      preferredCreatives: List<String>.from(data['preferredCreatives']),
      disableNewCreativeNotifications: data['disableNewCreativeNotifications'],
      disableWorkVacancyNotifications: data['disableWorkVacancyNotifications'],
      muteWorkVacancyNotifications: data['muteWorkVacancyNotifications'],
      report: data['report'],
      reportConfirmed: data['reportConfirmed'],
    );
  }
}
