// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../pages/admin_user_list.dart';
import '../services/payload_services.dart';

class AdminUserListBlockWidget extends StatefulWidget {
  final String email;
  final String auth_level;
  final String id;
  const AdminUserListBlockWidget(
      {Key? key,
      required this.email,
      required this.auth_level,
      required this.id})
      : super(key: key);

  @override
  AdminUserListBlockWidgetState createState() => AdminUserListBlockWidgetState();
}

class AdminUserListBlockWidgetState extends State<AdminUserListBlockWidget> {
  String? finalAuthLevel;

  List<DropdownMenuItem<String>> authLevelList = [
    DropdownMenuItem(
      child: Text('User'),
      value: 'user',
    ),
    DropdownMenuItem(
      child: Text('Admin'),
      value: 'admin',
    ),
    DropdownMenuItem(
      child: Text('Super Admin'),
      value: 'super_admin',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(57, 108, 126, 241),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.email.length > 23
                ? widget.email.substring(0, 20) + "..."
                : widget.email,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          Text(
              widget.auth_level.replaceFirst(
                    widget.auth_level[0], widget.auth_level[0].toUpperCase()),
              style: TextStyle(color: Colors.white),
            ),
            
         
        ],
      ),
    );
  }
}
