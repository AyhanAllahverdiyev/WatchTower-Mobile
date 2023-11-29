import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:watch_tower_flutter/firebase_options.dart';
import 'package:watch_tower_flutter/pages/alert_screen.dart';
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import 'package:watch_tower_flutter/themes.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import './pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import "./utils/firebase_utils.dart";

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseUtils().initNotifications();
  await FirebaseMessaging.instance.subscribeToTopic('Broadcast_Alert');
 
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
bool isLightMode = brightness == Brightness.light;
 LoginUtils().saveThemeMode(isLightMode);

    return MaterialApp(
      title: 'Watch Tower',
      home: LoginPage(),

      theme: Provider.of<ThemeProvider>(context).isLightModeSelected
          ? ThemeClass.lightTheme
          : ThemeClass.darkTheme,
  
      debugShowCheckedModeBanner: false,
    );
  }
}
class ThemeProvider with ChangeNotifier {
  bool _isLightModeSelected = true;

  bool get isLightModeSelected => _isLightModeSelected;

  ThemeProvider() {
    _initThemeMode();
  }

  Future<void> _initThemeMode() async {
    var brightness = SchedulerBinding.instance!.platformDispatcher.platformBrightness;
    _isLightModeSelected = brightness == Brightness.light;
    await LoginUtils().saveThemeMode(_isLightModeSelected);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _isLightModeSelected = !_isLightModeSelected;
    await LoginUtils().changeThemeMode();

    notifyListeners();
  }
}



