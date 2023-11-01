import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:web_socket_channel/io.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/alert_screen.dart';
import '../pages/alert_details.dart';

class BottomAppBarWidget extends StatefulWidget {
  BottomAppBarWidget({Key? key}) : super(key: key);

  @override
  BottomAppBarWidgetState createState() => BottomAppBarWidgetState();
}

class BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  String message = ''; // Variable to store received messages
  final channel = IOWebSocketChannel.connect('ws://192.168.1.160:3000');
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  @override
  void initState() {
    super.initState();
    // Listen to incoming WebSocket messages
    channel.stream.listen((data) async {
      if (data is String) {
        if (!data.contains(await LoginUtils().getUserId())) {
          print('here1 ');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AlertScreen(data: data)));

          setState(() {
            message = data;
          });
        }
      } else {
        String decoded = String.fromCharCodes(data);
        // Handle other types of data if necessary
        if (!decoded.contains(await LoginUtils().getUserId())) {
          print('here 2');
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
    // Don't forget to close the WebSocket channel when the widget is disposed.
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromARGB(57, 108, 126, 241),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.flashlight_on),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                // Navigate to HomePage or perform any other action
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.add_alert_sharp),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AlertDetails()));
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
