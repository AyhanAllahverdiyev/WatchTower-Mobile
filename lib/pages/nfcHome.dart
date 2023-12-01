// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_tower_flutter/main.dart';
import 'package:watch_tower_flutter/pages/home.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'dart:convert';
import '../components/bottom_navigation.dart';
import '../components/nfc_block.dart';
import '../services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';

import '../services/session_services.dart';
import '../utils/login_utils.dart';

class NfcHomePage extends StatefulWidget {
  final bool isOldSessionOn;
  const NfcHomePage({super.key, required this.isOldSessionOn});

  @override
  State<NfcHomePage> createState() => NfcHomePageState();
}


List<Map<String, dynamic>> finalOrderArray = [];

class NfcHomePageState extends State<NfcHomePage> {
  List<String> allowedOrderArray = [];
  static bool session = false;
  static bool tour = false;

  bool isLightModeSelected = true;
  @override
  void initState() {

    print(widget.isOldSessionOn);
    LoginUtils().getThemeMode().then((value) {
      setState(() {
        isLightModeSelected = value;
      });
    });
    getOrderArrayForReadPage();
  }




  Future<void> getOrderArrayForReadPage() async {
    print("!!!!!!!!!!!!!!!!!!!! GET ORDER ARRAY FOR READ PAGE !!!!!!!!!!!!!!!!!!!!!!");
    ApiResponse jsonResponse = await SessionService().checkSessionStatus();
    Map<String, dynamic> orderArray = json.decode(jsonResponse.response);


    List<dynamic> allowedOrderMaps = orderArray['data'];
      finalOrderArray = allowedOrderMaps.map((item) {
    return {
      'name': item['name'],
      'isRead': item['isRead'],
    };
  }).toList();

  setState(() {
    finalOrderArray = finalOrderArray;
  });


    List<String> newAllowedOrderArray =
        allowedOrderMaps.map((map) => map['name'].toString()).toList();
    print("newAllowedOrderArray: $newAllowedOrderArray");
    setState(() {
      allowedOrderArray = newAllowedOrderArray;

    });

 

  }

  Future<void> updateIsReadValue(String name, String newReadValue) async {
    for (int i = 0; i < finalOrderArray.length; i++) {
      print('finalOrderArray in each loop ${finalOrderArray[i]['name']}');
      if (finalOrderArray[i]['name'] == name) {
        finalOrderArray[i]['isRead'] = newReadValue;
        print('Updated finalOrderArray: $finalOrderArray');
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    !isLightModeSelected ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleThemeMode();

                    setState(() {
                      isLightModeSelected = !isLightModeSelected;
                    });
                  },
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < finalOrderArray.length; i++)
                  NfcBlockWidget(
                    order: finalOrderArray[i]["name"],
                    isRead: finalOrderArray[i]["isRead"].toString(),
                    index: i,
                  ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        print(
                            '==============================CONTENTS OF NFC TAG==============================');
                        int readTagResult = await NfcService().tagRead(context);
                        if (readTagResult == 302) {
                          await AlertUtils().successfulAlert(
                              "Tour Completed", context);
                       Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NfcHomePage(
                                      isOldSessionOn: true,
                                    )),
                          );
                        } else if (readTagResult < 400) {
                          print("tag read successfully");
                          print("//////////////////////////////////////////");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NfcHomePage(
                                      isOldSessionOn: true,
                                    )),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        int result = await SessionService()
                            .endActiveSessionStatus();
                                print("nfc Home 2");
                        if (result<400) {
                          print('read order resetted');
                    
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          print('session stopped');
                        } else {
                          print('error while resetting read order');
                          AlertUtils().errorAlert(
                              "Unable to end current session", context);
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(pageName: "NfcHomePage"),
      ),
    );
  }
}
