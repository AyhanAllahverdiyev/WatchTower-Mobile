import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('handleBackgroundMessage');
  print('Title:  ${message.notification?.title ?? 'No title'}');
  print('Body:  ${message.notification?.body ?? 'No body'}');
  print('Payload:  ${message.data ?? 'No payload'}');
}

class FirebaseUtils {
  final localNotifications = FlutterLocalNotificationsPlugin();
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    String deviceToken = await getDeviceTokenIos();
    print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION######");
    print(deviceToken);
    print("#######################################################");

    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print('===================================');
    print("TOKEN: $fcmToken");
    initPushNotifications();
    // initLocalNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    print('-===========================-');
    print(message.notification.toString());
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
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      // Create a local notification with the message content
      localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(iOS: iOS, android: android);
    await localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload as String));
      handleMessage(message);
    });
    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

////////////////////////////////////////////////
  ///12:28
  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'this channel is used for important notifications',
    importance: Importance.high,
  );

///////////////////////////////////////////////////
//get device token to use for push notification
  Future getDeviceTokenIos() async {
    //request user permission for push notification
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
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
