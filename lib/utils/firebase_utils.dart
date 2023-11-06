import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_tower_flutter/main.dart';
import 'package:watch_tower_flutter/pages/alert_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:  ${message.notification?.title}');
  print('Body:  ${message.notification?.body}');
  print('Payload:  ${message.data}');
}

class FirebaseUtils {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print('===================================');
    print("TOKEN: $fcmToken");
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    } else if (message.notification == null) {
      return;
    }
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => AlertScreen(data: message.notification!.body!),
      ),
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}






























  // Future<void> configure() async {
  //   // Subscribe to a topic (optional)
  //   firebaseMessaging.subscribeToTopic('your_topic_name');

  //   // Configure the background message handler
  //   FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  // }

  // // Handle background messages
  // Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  //   print('Handling a background message ${message.messageId}');
  // }

  // void requestNotificationPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission();
  //   print("User granted permission: ${settings.authorizationStatus}");
  // }
 
