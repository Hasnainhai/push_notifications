import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifications/message_screen.dart';

class NotificationsServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// notification permissions
  void requestNotificationsPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user allow the notifications');
      // AppSettings.openAppSettings(type: AppSettingsType.notification);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Authorize the provisional authorization');
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('Authorization Denied!');
    }
  }

// local notifications setup
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializeSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializeSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMesg(context, message);
    });
  }

// get FCM token or device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

// refresh FCM
  void refreshToken() {
    messaging.onTokenRefresh.listen((event) {
      print('Event: $event');
    });
  }

// main func
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      } else {
        showNotifications(message);
      }
    });
  }

// show notification fun
  Future<void> showNotifications(RemoteMessage message) async {
    const String channelId = 'high_alert_channel';
    const String channelName = 'High Alert Notifications';

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'This channel is for high alert notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      Random.secure().nextInt(10000000).toString(),
      channel.name,
      channelDescription: 'This is hasnain channel',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    // await _flutterLocalNotificationsPlugin.show(
    //   0, // Unique notification id
    //   message.notification!.title,
    //   message.notification!.body,
    //   notificationDetails,
    // );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

//setup for interact message notifications
  Future<void> setupInterectMessage(BuildContext context) async {
    // when application is terminated
    RemoteMessage? initialMessge =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessge != null) {
      handleMesg(context, initialMessge);
    }
    // when application is on background
    FirebaseMessaging.onMessage.listen((event) {
      handleMesg(context, event);
    });
  }

// handle notification navigator
  void handleMesg(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'hasnain') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessageScreen(
                    id: message.data['id'],
                  )));
    }
  }
}
