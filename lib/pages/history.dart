// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/services/db_service.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';

import '../components/bottom_navigation.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  String apiResponse="";
  int apiResponseCode=0;
    @override
  void initState() {
    _getUserHistory();
  }
void _getUserHistory() async {
    ApiResponse response=await DbServices().getUserHistory();
    setState(() {
      apiResponse=response.response;
      apiResponseCode=response.statusCode;
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("History Page", style: TextStyle(color: Colors.white)),
          ],
        ),
        bottomNavigationBar: BottomAppBarWidget(pageName: "HomePage",),
      ),
    );
  }
}
