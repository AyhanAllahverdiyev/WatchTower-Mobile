// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'dart:convert';
import '../components/bottom_navigation.dart';
import '../components/nfc_block.dart';
import '../services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import '../utils/alarm_utils.dart';

class NfcHomePage extends StatefulWidget {
  const NfcHomePage({super.key});

  @override
  State<NfcHomePage> createState() => NfcHomePageState();
}

List<Map<String, dynamic>> orderJsonArray = [];

class NfcHomePageState extends State<NfcHomePage> {
  List<String> allowedOrderArray = [];
  static bool session = false;

  @override
  void initState() {
    isSessionOn();
    super.initState();
  }

  void isSessionOn() {
    if (session == false) {
      getOrderArray();
      session = true;
    } else {
      print('Session is already on');
    }
  }

  void addValuesToArray(String name, bool order) {
    orderJsonArray.add({"name": name, "isRead": order});
  }

  Future<void> getOrderArray() async {
    ApiResponse orderArray = await NfcService().getOrderArray(context);
    Map<String, dynamic> jsonResponse = json.decode(orderArray.response);
    print(jsonResponse);

    List<dynamic> allowedOrderMaps = jsonResponse['allowedOrderArray'];
    List<String> newAllowedOrderArray =
        allowedOrderMaps.map((map) => map['name'].toString()).toList();

    setState(() {
      allowedOrderArray = newAllowedOrderArray;
      orderJsonArray.clear(); // Clear the existing data
    });

    newAllowedOrderArray.forEach((element) {
      addValuesToArray(element, false);
    });

    print(
        '////////////////////////////////TESTING////////////////////////////////');
    print(orderJsonArray);
    print(
        '////////////////////////////////TESTING////////////////////////////////');
  }

  Future<void> updateIsReadValue(String name, String newReadValue) async {
    for (int i = 0; i < orderJsonArray.length; i++) {
      print('orderJsonArray in each loop ${orderJsonArray[i]['name']}');
      if (orderJsonArray[i]['name'] == name) {
        orderJsonArray[i]['isRead'] = newReadValue;
        print('Updated orderJsonArray: $orderJsonArray');
        break;
      }
    }
  }

  // void checkIfAllRead() {
  //   for (int i = 0; i < orderJsonArray.length; i++) {
  //     if (orderJsonArray[i]['isRead'] == false) {
  //       return;
  //     }
  //     AlertUtils().successfulAlert('All orders read', context);
  //   }
  // }

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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < orderJsonArray.length; i++)
                  NfcBlockWidget(
                    order: orderJsonArray[i]["name"],
                    isRead: orderJsonArray[i]["isRead"].toString(),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print(
                        '==============================CONTENTS OF NFC TAG==============================');
                    bool readTagResult = await NfcService().tagRead(context);
                    if (readTagResult == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NfcHomePage()),
                      );
                    }
                    print("tag read result:$readTagResult");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text('Read tag',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool result = await NfcService().resetReadOrder();
                    if (result) {
                      print('read order resetted');
                      session = false;
                      Navigator.pop(context);
                      print('session stopped');
                    } else {
                      print('error while resetting read order');
                      AlertUtils()
                          .errorAlert("Unable to end current session", context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text('End Session',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
