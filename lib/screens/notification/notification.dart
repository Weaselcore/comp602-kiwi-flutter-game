import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Notification() {
    _init();
  }

  void _init() async {
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    //android setting
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //ios setting
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //set each setting
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    //init setting
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  sendNotification() async {
    print("----------------------notify----------------------");
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            //channel id, channel name, channel description
            'kiwi game',
            'kiwi game',
            'kiwi game',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
        0,
        'You beat the high score',
        'Congratulation! Keep it up!',
        platformChannelSpecifics,
        );
  }
}
