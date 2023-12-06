import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:watch_tower_flutter/components/history_card.dart';
import 'package:watch_tower_flutter/pages/profile.dart';
import 'package:watch_tower_flutter/services/db_service.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'package:watch_tower_flutter/components/bottom_navigation.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  String apiResponse = "";
  int apiResponseCode = 0;
  String userId = "";
  List<dynamic> jsonList = [];
  bool isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _getUserHistory();
  }

  void _getUserHistory() async {
    setState(() {
      isLoading = true; // Show loading indicator before fetching data
    });

    String userId = await LoginUtils().getUserId();
    ApiResponse response = await DbServices().getUserHistory(userId);
    if (response.statusCode > 400) {
      AlertUtils().InfoAlert("Couldn't Find Any Record!", context);
      await Future.delayed(Duration(seconds: 2));
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
      isLoading = false; // Hide loading indicator after getting data
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: AppBar(),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            // Show loading indicator conditionally

            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: SpinKitCubeGrid(
                    duration: Duration(milliseconds: 1000),
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBarWidget(
          pageName: "HistoryPage",
        ),
      ),
    );
  }
}
