import 'package:flutter/material.dart';
import 'package:push_notifications/notifications_services.dart';

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
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Hasnain',
                    'body': 'this message is send this my device',
                    'data': {'type': ''}
                  }
                };
              });
            },
            child: const Text('Send notification')),
      ),
    );
  }
}
