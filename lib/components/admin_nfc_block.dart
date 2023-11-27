// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/admin_nfc_order.dart';
import '../pages/admin_nfc_order.dart';

class AdminNfcBlockWidget extends StatefulWidget {
  final String order;
  final bool isDeleteSelected;
  final int index;
  const AdminNfcBlockWidget(
      {Key? key,
      required this.order,
      required this.isDeleteSelected,
      required this.index})
      : super(key: key);

  @override
  AdminNfcBlockWidgetState createState() => AdminNfcBlockWidgetState();
}

class AdminNfcBlockWidgetState extends State<AdminNfcBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('pressed delete button at index ${widget.index}');
      },
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(57, 108, 126, 241),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.order,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          if (widget.isDeleteSelected)
            Icon(
              Icons.delete,
              color: Colors.red,
              size: 20,
            ),
        ],
      ),
    );
  }
}
