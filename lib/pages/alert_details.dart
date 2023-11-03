import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/components/bottom_navigation.dart';
import 'package:web_socket_channel/io.dart';
import '../components/admin_bottom_navigation.dart';
import '../utils/login_utils.dart';

class AlertDetails extends StatefulWidget {
  const AlertDetails({Key? key}) : super(key: key);

  @override
  State<AlertDetails> createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();

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
                  labelText: 'Text 1',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: textFieldController2,
              decoration: InputDecoration(
                  labelText: 'Text 2',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to another screen with the data inputted

                final data = {
                  'text1': textFieldController1.text,
                  'text2': textFieldController2.text,
                  'id': await LoginUtils().getUserId(),
                };
                // Send a WebSocket message when the button is pressed
                // BottomAppBarWidgetState().sendMessage(data.toString());
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
