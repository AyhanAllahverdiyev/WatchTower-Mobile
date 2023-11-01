import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../pages/home.dart';
import '../pages/profile.dart';

class BottomAppBarWidget extends StatefulWidget {
  BottomAppBarWidget({Key? key}) : super(key: key);

  @override
  _BottomAppBarWidgetState createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  final channel = IOWebSocketChannel.connect('ws://192.168.1.160:3000');
  String message = ''; // Variable to store received messages

  @override
  void initState() {
    super.initState();
    // Listen to incoming WebSocket messages
    channel.stream.listen((data) {
      if (data is String) {
        // If it's a string, handle it as a message
        setState(() {
          message = data;
          // Handle the received message as needed
        });
      } else {
        // Handle other types of data if necessary
        String decoded = String.fromCharCodes(data);
        print('Received data of buffer type: $decoded');
      }
    });
  }

  @override
  void dispose() {
    // Don't forget to close the WebSocket channel when the widget is disposed.
    channel.sink.close();
    super.dispose();
  }

  void sendMessage(String message) {
    channel.sink.add(message);
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
                // Send a WebSocket message when the button is pressed
                sendMessage("Hello, WebSocket Server!");
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