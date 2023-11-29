// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/components/bottom_navigation.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import 'package:watch_tower_flutter/pages/home.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import '../utils/login_utils.dart';
import '../utils/alarm_utils.dart';

const List<String> list = <String>[
  'select_an_alert_type',
  'fire',
  'earthquake',
  'flood',
  'burglary',
  'other'
];

class Data {
  String content;
  String type;
  String topic;
  String id;
  Data(this.content, this.type, this.topic, this.id);
  List<String> getJson(Data message) {
    content = message.content;
    type = message.type;
    topic = message.topic;
    id = message.id;
    List<String> list = [content, type, topic, id];
    return list;
  }
}

String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

class AlertDetails extends StatefulWidget {
  const AlertDetails({Key? key}) : super(key: key);
  static const routeName = '/alert_details';
  @override
  State<AlertDetails> createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController = TextEditingController();
  String selectedType = '';

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(backgroundColor: Color.fromARGB(57, 108, 126, 241))),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Send an Alert Message!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 20),
              DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(242, 25, 118, 210)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                width: MediaQuery.of(context).size.width - 36,
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                      value: value,
                      label: capitalizeFirstLetter(value).replaceAll('_', ' '));
                }).toList(),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Content:",
                      style: TextStyle(fontSize: 20, color: Colors.white))),
              SizedBox(height: 20),
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (selectedType == "select_an_alert_type" ||
                      selectedType.isEmpty) {
                    await AlertUtils()
                        .errorAlert('Please select a type', context);
                  } else if (textFieldController.text.isEmpty) {
                    await AlertUtils()
                        .errorAlert('Please enter a message', context);
                  } else {
                    Data data = Data(
                        "content",
                        selectedType,
                        textFieldController.text,
                        await LoginUtils().getUserId());

                    await BottomAppBarWidgetState().sendMessage(data);
                    int res =
                        await WebSocketService().sendBroadcastMessageFirebase();
                    if (res >= 399) {
                      await AlertUtils().errorAlert('Failed to send', context);
                    } else {
                      await AlertUtils().successfulAlert('Success', context);
                      String authLevel = await LoginUtils().getAuthLevel();
                      if (authLevel == 'admin' || authLevel == 'super_admin') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminHomePage()),
                          (route) => false,
                        );
                      } else if (authLevel == 'user') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Send!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(
          pageName: "AlertDetail",
        ),
      ),
    );
  }
}
