// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/utils/payload_utils.dart';
import '../components/admin_bottom_navigation.dart';
import '../services/db_service.dart';
import '../utils/alert_utils.dart';
import '../components/users_list_block.dart';
import '../services/payload_services.dart';


class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => UsersListPageState();
}

class UsersListPageState extends State<UsersListPage> {
  String usersListString = '';
  List<dynamic> usersList = [];
  @override
  void initState() {
    _getUsersArray();
    PayloadServices().clearUpdatedAuthLevelList();
  }

  Future _getUsersArray() async {
    dbResponse userListResponce = await DbServices().getAllUsers();
    if (userListResponce.statusCode >= 399) {
      if (!AlertUtils().isDialogOpen) {
        await AlertUtils().errorAlert("Internal Server Error!", context);
      }
    }
    else{

      String usersListString2 = userListResponce.response;
          List<dynamic> usersList2 = json.decode(usersListString2);
    print("usersListString: $usersListString");
    setState(() {
      usersListString = usersListString2;
      usersList = usersList2;
    });
    }
    
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
                SizedBox(height: 20),
                for (int index=0; index<usersList.length; index++)
                  UserListBlockWidget(email: usersList[index]['email'], auth_level:usersList[index]['auth_level'], index: index)
              
               
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                
                 var aaa=PayloadServices().getUpdatedAuthLevelList().toString();
                 print('//////////////////////////////////////////////');
                 print(aaa);
                    },
                    tooltip: 'Save',
                    backgroundColor: Colors.green,
                    child: Icon(Icons.save),
                  ),
               
        bottomNavigationBar: AdminBottomAppBarWidget(),
      ),
    );
  }
}
