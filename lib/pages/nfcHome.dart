// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/bottom_navigation.dart';
import '../components/nfc_block.dart';
import '../services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import '../utils/alarm_utils.dart';

class NfcHomePage extends StatefulWidget {
  const NfcHomePage({super.key});

  @override
  State<NfcHomePage> createState() => _NfcHomePageState();
}

class _NfcHomePageState extends State<NfcHomePage> {
  List<String> allowedOrderArray = [];
  @override
  void initState() {
    _getOrderArray();
   }

  Future _getOrderArray() async {
    ApiResponse orderArray = await NfcService().getOrderArray();
    Map<String, dynamic> jsonResponse = json.decode(orderArray.response);
    List<String> newAllowedOrderArray =
        List<String>.from(jsonResponse['allowedOrderArray']);

    setState(() {
      allowedOrderArray = newAllowedOrderArray;
    });
  }

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
                for (var order in allowedOrderArray)
                  NfcBlockWidget(order: order, isOrderDone: false),
                SizedBox(height: 20),
                 ElevatedButton(
                  onPressed: () async {
                    print(
                        '==============================CONTENTS OF NFC TAG==============================');
                    bool readTagResult = await NfcService().tagRead(context);
                    print("tag read result:$readTagResult");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:20,right:20,top:10,bottom:10),
                    child: Text('Read tag',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                    ),
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
