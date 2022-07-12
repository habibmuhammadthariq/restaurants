import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/utils/receive_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:restaurant/data/model/restaurant.dart';

final selectNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject = BehaviorSubject<ReceiveNotification>();

class NotificationHelper {
  static const _channelId = '01';
  static const _channelName = "new resto";
  static const _channelDesc = "Notification that show you new resto";
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceiveNotification(
            id: id, title: title, body: body, payload: payload
        ));
      });

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload : $payload');
        }
        selectNotificationSubject.add(payload);
      });
  }

  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation
        <IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  void configureDidReceiveLocalNotificationSubject(
      BuildContext context, String route
      ) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceiveNotification receiveNotification) async {
          await showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: receiveNotification.title != null
                    ? Text(receiveNotification.title!)
                    : null,
                content: receiveNotification.body != null
                  ? Text(receiveNotification.body!)
                    : null,
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('ok'),
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                      await Navigator.pushNamed(context, route, arguments: receiveNotification);
                      // receiveNotification need to be change because of restaurant detail need id not that one
                    },
                  )
                ]
              )
          );
    });
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, route,
          arguments: payload);
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant
      ) async {

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        _channelId, _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      restaurant.name,
      'Lokasi ${restaurant.city}',
      platformChannelSpecifics,
      payload: restaurant.id,
    );
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {

    var dateTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
      channelDescription: _channelDesc,
      icon: 'secondary_icon',
      // largeIcon:
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500
    );
    var iOSPlatformSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
    0,
    'schedule title',
    'schedule body',
    // dateTime,
    platformChannelSpecifics,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
      payload: 'scheduled notification',
      // androidAllowWhileIdle: true,
    );
  }
}