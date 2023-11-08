import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/components/bottom_navigation.dart';
import 'package:web_socket_channel/io.dart';
import '../components/admin_bottom_navigation.dart';
import '../utils/login_utils.dart';
import '../components/bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/alarm_utils.dart';

class Data {
  String content;
  String type;
  String topic;
  String id;
  Data(this.content, this.type, this.topic, this.id);
}

class AlertDetails extends StatefulWidget {
  const AlertDetails({Key? key}) : super(key: key);

  @override
  State<AlertDetails> createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Alert Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textFieldController1,
              decoration: InputDecoration(
                  labelText: 'content',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: textFieldController2,
              decoration: InputDecoration(
                  labelText: 'type',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: textFieldController3,
              decoration: InputDecoration(
                  labelText: 'topic',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () async {
                Data data=Data(textFieldController1.text, textFieldController2.text,
                    textFieldController3.text, await LoginUtils().getUserId());
                BottomAppBarWidgetState().sendMessage(data);
                await WebSocketService().sendBroadcastMessage(
                    textFieldController1.text,
                    textFieldController2.text,
                    'Broadcast_Alert');
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
