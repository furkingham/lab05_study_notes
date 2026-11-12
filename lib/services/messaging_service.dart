import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagingService {
  final FirebaseMessaging _messaging;

  MessagingService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  Future<String?> init() async {
    await _messaging.requestPermission();
    await _messaging.subscribeToTopic('comp205');
    return await _messaging.getToken();
  }

  void listenInForeground(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null && context.mounted) {
        final title = notification.title ?? '';
        final body = notification.body ?? '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: $body'),
          ),
        );
      }
    });
  }
}