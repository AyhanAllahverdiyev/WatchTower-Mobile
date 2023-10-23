// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NfcBlockWidget extends StatelessWidget {
  const NfcBlockWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(57, 108, 126, 241),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome to the',
                      style: TextStyle(fontSize: 30.0, color: Colors.black),
                    ),
                    Icon(Icons.location_on),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
