import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> init() async {

    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid
    );

    await notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {});

    await Permission.notification.request();
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName')
    );
  }

  Future showNotification({String? title, String? body, String? payLoad}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public, // Make it public
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item id 2',
    );
  }
}