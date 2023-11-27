import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/components/bottom_navigation.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import 'package:watch_tower_flutter/pages/home.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import '../utils/login_utils.dart';
import '../utils/alarm_utils.dart';

const List<String> list = <String>[
  'location_report',
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
  final TextEditingController textFieldController3 = TextEditingController();
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
              DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.blue.shade700),
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
                      label: capitalizeFirstLetter(value
                          .replaceFirst('_', ' ')
                          .replaceFirst(value[value.indexOf('_') + 1],
                              value[value.indexOf('_') + 1].toUpperCase())));
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: textFieldController1,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.blue.shade700),
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
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(height: 20),
              TextField(
                controller: textFieldController3,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  labelStyle: TextStyle(color: Colors.blue.shade700),
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
                style: TextStyle(color: Colors.blue),
              ),
              ElevatedButton(
                onPressed: () async {
                  Data data = Data(
                      textFieldController1.text,
                      selectedType,
                      textFieldController3.text,
                      await LoginUtils().getUserId());
                  await BottomAppBarWidgetState().sendMessage(data);
                  int res = await WebSocketService()
                      .sendBroadcastMessageFirebase(textFieldController1.text,
                          selectedType, 'Broadcast_Alert');
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
                        MaterialPageRoute(
                            builder: (context) => HomePage()),
                        (route) => false,
                      );
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(pageName: "AlertDetail",),
      ),
    );
  }
}
