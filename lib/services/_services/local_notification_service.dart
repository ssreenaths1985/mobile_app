import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String id) async {
        // print("onSelectNotification");
        // if (id.isNotEmpty) {
        //   print("Router Value1234 $id");

        //   // Navigator.of(context).push(
        //   //   MaterialPageRoute(
        //   //     builder: (context) => DemoScreen(
        //   //       id: id,
        //   //     ),
        //   //   ),
        //   // );

        // }
      },
    );
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "igot_karmayogi_mobile",
          "igot_karmayogi_mobile_channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        // payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      // print(e);
      throw e;
    }
  }

  static getDeviceTokenToSendNotification() async {
    String deviceTokenToSendPushNotification = '';
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    // print("Token Value $deviceTokenToSendPushNotification");
    return deviceTokenToSendPushNotification;
  }
}
