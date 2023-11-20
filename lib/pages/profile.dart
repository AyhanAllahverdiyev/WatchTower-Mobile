// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import './login.dart';
import '../utils/login_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String userEmail = "";
  bool light = true;
  @override
  void initState() {
    loadSavedCredentials();
  }

  loadSavedCredentials() async {
    final credentials = await LoginUtils().loadSavedCredentials();
    String email = credentials.email;

    int atIndex = email.indexOf("@");

    String updatedEmail = email.substring(0, atIndex);
    updatedEmail = updatedEmail.replaceAll(".", " ");
    updatedEmail = updatedEmail.replaceFirst(
        updatedEmail[0], updatedEmail[0].toUpperCase());
    updatedEmail = updatedEmail.replaceFirst(
        updatedEmail[updatedEmail.indexOf(' ') + 1],
        updatedEmail[updatedEmail.indexOf(' ') + 1].toUpperCase());
    setState(() {
      userName = updatedEmail;
      userEmail = credentials.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/profile_1.png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(57, 108, 126, 241),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  fixedSize: Size.fromHeight(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'My Location',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: light,
                      activeColor: Colors.blue.shade100,
                      onChanged: (bool value) {
                        setState(() {
                          light = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(57, 108, 126, 241),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  fixedSize: Size.fromHeight(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.bookmark,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'My History',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(57, 108, 126, 241),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  fixedSize: Size.fromHeight(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('jwt');
                await AlertUtils().successfulAlert('Logging  out...', context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  Text('Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
