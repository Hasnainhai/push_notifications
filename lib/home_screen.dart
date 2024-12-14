import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:push_notifications/notifications_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsServices notificationsServices = NotificationsServices();
  @override
  void initState() {
    super.initState();
    notificationsServices.requestNotificationsPermissions();
    notificationsServices.firebaseInit(context);
    notificationsServices.setupInterectMessage(context);
    notificationsServices.refreshToken();
    notificationsServices.getDeviceToken().then((value) {
      print('device Token: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              notificationsServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value,
                  'priority': 'high',
                  'notification': {
                    'title': 'Hasnain',
                    'body': 'this message is send this my device',
                    'data': {
                      'type': 'mesg',
                      'id': 'hasnain123',
                    }
                  }
                };
                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json;charset=UTF-8',
                      'Authorization': 'key=CLOUD MESSAGES API KEY',
                    });
              });
            },
            child: const Text('Send notification')),
      ),
    );
  }
}
