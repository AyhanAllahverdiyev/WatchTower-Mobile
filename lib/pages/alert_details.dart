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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0), child: AppBar()),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Send an Alert Message",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20),
              DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 3),
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
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      value: value,
                      label: capitalizeFirstLetter(value).replaceAll('_', ' '));
                }).toList(),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Content:",
                      style: TextStyle(fontSize: 20,))),
              SizedBox(height: 10),
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue,width: 3),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              
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
