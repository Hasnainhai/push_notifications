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
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
