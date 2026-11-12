import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _messaging;

  MessagingService(this._messaging);

  /// Asks for permission, subscribes to the topic and returns the FCM token.
  Future<String?> init() async {
    await _messaging.requestPermission();
    await _messaging.subscribeToTopic('comp205');
    return _messaging.getToken();
  }

  /// Calls [show] for every message that arrives while the app is open.
  void listenInForeground(void Function(String title, String body) show) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final n = message.notification;
      show(n?.title ?? '', n?.body ?? '');
    });
  }
}