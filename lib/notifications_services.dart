import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void refreshToken() {
    messaging.onTokenRefresh.listen((event) {
      print('Event: $event');
    });
  }
}
