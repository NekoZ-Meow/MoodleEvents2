import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {}

/// 通知が選択された時
Future selectNotification(String? payload) async {}

/// 通知設定の初期化
Future<void> notificationInitialize() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  return;
}

/// 通知を表示する
Future<void> showEventNotification(
    String title, String body, String payload) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('event alarm', '課題アラーム',
          channelDescription: '課題の提出期限が迫っていることをお知らせします',
          importance: Importance.max,
          priority: Priority.high);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);

  return;
}
