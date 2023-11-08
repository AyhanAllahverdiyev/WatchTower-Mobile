import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/firebase_options.dart';
import 'package:watch_tower_flutter/pages/alert_screen.dart';
import './pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import "./utils/firebase_utils.dart";

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseUtils().initNotifications();
  await FirebaseMessaging.instance.subscribeToTopic('Broadcast_Alert');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
