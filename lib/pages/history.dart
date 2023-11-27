// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/components/history_card.dart';
import 'package:watch_tower_flutter/pages/profile.dart';
import 'package:watch_tower_flutter/services/db_service.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';

import '../components/bottom_navigation.dart';
import '../utils/login_utils.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  String apiResponse = "";
  int apiResponseCode = 0;
  String userId = "";
  List<dynamic> jsonList = [];
  @override
  void initState() {
    _getUserHistory();
  }

  void _getUserHistory() async {
    String userId = await LoginUtils().getUserId();
    ApiResponse response = await DbServices().getUserHistory(userId);
    if(response.statusCode > 400){
       AlertUtils().InfoAlert("Couldn't Find Any Record!", context);
       await Future.delayed(Duration(seconds: 1));
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (route) => false,
      );
    }
    setState(() {
      userId = userId;
      jsonList = json.decode(response.response);
      apiResponseCode = response.statusCode;
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
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("History", style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    )),
                ),
                for (var i = 0; i < jsonList.length; i++)
                  HistoryCard(
                    tagId: jsonList[i]['ID'],
                    date: jsonList[i]['createdAt'],
                    batteryLevel: jsonList[i]['battery_level'],
                    name: jsonList[i]['name'],
                    isItself: jsonList[i]['_id'] != userId,
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(
          pageName: "HomePage",
        ),
      ),
    );
  }
}
