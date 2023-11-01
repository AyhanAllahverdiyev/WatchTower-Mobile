// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/login.dart';
import './nfcHome.dart';
import '../components/bottom_navigation.dart';
import '../services/nfc_Services.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor:   Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(backgroundColor: Color.fromARGB(57, 108, 126, 241))
          ),
        body: SingleChildScrollView(
        
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                //////Potential error in the future: the height of the SizedBox is too large depending on the device
                SizedBox(height: 250),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.all(65),
                        shape: CircleBorder()),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NfcHomePage()));
                    },
                    child: Text(
                      'Start Tour',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print(
                        '==============================CONTENTS OF NFC TAG==============================');
                    bool readTagResult = await NfcService().tagRead(context);
                    print("tag read result:$readTagResult");
                  },
                  child: Text('Read tag'),
                ),
      
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  },
                  child: Text('Logout'),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
