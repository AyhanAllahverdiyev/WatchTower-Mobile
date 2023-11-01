// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AdminNfcBlockWidget extends StatelessWidget {
  final String order;
  const AdminNfcBlockWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
  onPressed: () {

  },
  style: TextButton.styleFrom(
    backgroundColor: Color.fromARGB(57, 108, 126, 241),
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
  Text(
            order,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
       
      ],
    ),
  ),
);
  }
}
