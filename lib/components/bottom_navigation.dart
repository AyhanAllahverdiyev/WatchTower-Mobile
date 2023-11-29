import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_tower_flutter/services/device_services.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:web_socket_channel/io.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/alert_screen.dart';
import '../pages/alert_details.dart';
import '../utils/login_utils.dart';
import '../pages/admin_home.dart';

class BottomAppBarWidget extends StatefulWidget {
  final String pageName;
  const BottomAppBarWidget({
    Key? key,
    required this.pageName,
  }) : super(key: key);

  @override
  BottomAppBarWidgetState createState() => BottomAppBarWidgetState();
}

class BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  bool isTorchPressed = false;
  String authLevel = '';
  String message = '';
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  final channel = IOWebSocketChannel.connect('ws://192.168.1.73:3000');
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> sendMessage(Data message) async {
    try {
      channel.sink.add(message.getJson(message).toString());
    } catch (error) {
      print("error first time sending message:$error");
      channel.sink.add(message.getJson(message).toString());
    }
  }

  @override
  void initState() {
    _getAuthLevel();
    super.initState();
    // Listen to incoming WebSocket messages
    channel.stream.listen((data) async {
      if (data is String) {
        if (!data.contains(await LoginUtils().getUserId())) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AlertScreen(data: data)));

          setState(() {
            message = data;
          });
        }
      } else {
        String decoded = String.fromCharCodes(data);
        if (!decoded.contains(await LoginUtils().getUserId())) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AlertScreen(data: decoded)));

          setState(() {
            message = decoded;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Future<void> _getAuthLevel() async {
    String getauthLevel = await LoginUtils().getAuthLevel();
    setState(() {
      authLevel = getauthLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 30.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.flashlight_on_outlined),
              iconSize: 40,
              onPressed: () async {
                setState(() {
                  isTorchPressed = !isTorchPressed;
                });
                DeviceService().toggleTorch(isTorchPressed);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_alert_outlined),
              iconSize: 40,
              onPressed: () {
                if (widget.pageName != "AlertDetail") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AlertDetails()),
                    (route) => false,
                  );
                }
              },
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
                color: Colors.blue,
              ),
              child: IconButton(
                icon: Icon(Icons.home_outlined),
                color: Theme.of(context).colorScheme.background,
                iconSize: 40,
                onPressed: () {
                  if (widget.pageName != "HomePage" &&
                      widget.pageName != "AdminHomePage") {
                    if (authLevel == "super_admin" || authLevel == "admin") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminHomePage()),
                        (route) => false,
                      );
                    } else if (authLevel == "user") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.location_on_outlined),
              iconSize: 40,
              onPressed: () async {
                LoginUtils().printAllSharedPreferences();
              },
            ),
            IconButton(
              icon: Icon(Icons.person_outlined),
              iconSize: 40,
              onPressed: () {
                if (widget.pageName != "ProfilePage") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                    (route) =>
                        false, // This condition always returns false, so it clears everything
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
