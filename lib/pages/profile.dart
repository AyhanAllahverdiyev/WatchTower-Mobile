// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../components/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(36, 32, 50, 1000),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(backgroundColor: Color.fromARGB(57, 108, 126, 241))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                  SizedBox(height: 60),
                  Center(
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage('assets/images/profile_1.png'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Spacer(), // Boş alanı kapla
              Text(
                'Bu metin sabit altta',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
                ],
              ),
            ),
          ),
        ),
   
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
