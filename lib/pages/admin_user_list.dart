// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import '../components/bottom_navigation.dart';
import '../services/db_service.dart';
import '../utils/alert_utils.dart';
import '../components/users_list_block.dart';
import '../services/payload_services.dart';
import '../utils/login_utils.dart';
import '../components/admin_users_list_block.dart';
import 'home.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => UsersListPageState();
}

class UsersListPageState extends State<UsersListPage> {
  String usersListString = '';
  List<dynamic> usersList = [];
  List<int> statusCodeList = [];
  String mailAddress = "";
  String authLevel = "";
  bool isLoading = false;
  @override
  void initState() {
    _getUsersArray();
    PayloadServices().clearUpdatedAuthLevelList();
    _getAuthLevel();
  }

  _getAuthLevel() async {
    String getauthLevel = await LoginUtils().getAuthLevel();
    setState(() {
      authLevel = getauthLevel;
    });
  }

  Future _getUsersArray() async {
      setState(() {
      isLoading = true;
    });
    dbResponse userListResponce = await DbServices().getAllUsers();
    if (userListResponce.statusCode >= 399) {
      if (!AlertUtils().isDialogOpen) {
        await AlertUtils().errorAlert("An Error Occured!", context);
        await Future.delayed(Duration.zero);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
          (route) => false,
        );
      }
    } else {
      String usersListString2 = userListResponce.response;
      List<dynamic> usersList2 = json.decode(usersListString2);
      setState(() {
        usersListString = usersListString2;
        usersList = usersList2;
      });
      if (usersList.isEmpty) {
        await AlertUtils().InfoAlert("No Users Found!", context);
        await Future.delayed(Duration.zero);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
          (route) => false,
        );
      }
    }
        setState(() {
      isLoading = false;
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
            preferredSize: const Size.fromHeight(40.0), child: AppBar()),
        body: Stack(
          children: [
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading)
           SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("User Email",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("Access Level",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  for (int index = 0; index < usersList.length; index++)
                    if (authLevel == 'admin')
                      AdminUserListBlockWidget(
                          email: usersList[index]['email'],
                          auth_level: usersList[index]['auth_level'],
                          id: usersList[index]['_id'])
                    else if (authLevel == 'super_admin')
                      UserListBlockWidget(
                          email: usersList[index]['email'],
                          auth_level: usersList[index]['auth_level'],
                          id: usersList[index]['_id'])
                ],
              ),
            ),
          ),]
        ),
        floatingActionButton: authLevel == "super_admin"
            ? FloatingActionButton(
                onPressed: () async {
                  for (var item
                      in PayloadServices().getUpdatedAuthLevelList()) {
                    print("item: $item");
                    int statusCode = await DbServices().changeAuthLevel(item);
                    statusCodeList.add(statusCode);
                  }
                  if (statusCodeList.isNotEmpty) {
                    if (statusCodeList.contains(500)) {
                      if (!AlertUtils().isDialogOpen) {
                        await AlertUtils()
                            .errorAlert("Internal Server Error!", context);
                      }
                    } else {
                      if (!AlertUtils().isDialogOpen) {
                        await AlertUtils().successfulAlert(
                            "Auth Level Updated Successfully!", context);
                      }
                      Navigator.pop(context);
                    }
                  } else {
                    if (!AlertUtils().isDialogOpen) {
                      await AlertUtils().errorAlert(
                          "Please make some changes first!", context);
                    }
                  }

                  PayloadServices().clearUpdatedAuthLevelList();
                },
                tooltip: 'Save',
                backgroundColor: Colors.green,
                child: Icon(Icons.save, color: Colors.white),
              )
            : null,
        bottomNavigationBar: BottomAppBarWidget(
          pageName: "UsersListPage",
        ),
      ),
    );
  }
}
