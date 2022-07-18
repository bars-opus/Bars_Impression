import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void initilize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("res_bars"),
            iOS: IOSInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
    });
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    var androidNotificationDetails = AndroidNotificationDetails(
      "com.example.barsImpression",
      "barsImpression",
      importance: Importance.max,
      priority: Priority.high,
      icon: "res_bars",
    );
    var ios = IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final notificationDetail =
        NotificationDetails(android: androidNotificationDetails, iOS: ios);
    _notificationsPlugin.show(
      DateTime.now().microsecond,
      message.notification?.title,
      message.notification?.body,
      notificationDetail,
    );
  }
}
