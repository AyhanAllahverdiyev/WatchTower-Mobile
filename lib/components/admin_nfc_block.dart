// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AdminNfcBlockWidget extends StatefulWidget {
  final String order;
  const AdminNfcBlockWidget({Key? key, required this.order}) : super(key: key);

  @override
  _AdminNfcBlockWidgetState createState() => _AdminNfcBlockWidgetState();
}

class _AdminNfcBlockWidgetState extends State<AdminNfcBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
       
      },
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(57, 108, 126, 241),
      ),
      child: Row(
    
        children: [
          Text(
            widget.order,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ],
     
      ),
    );
  }
}
