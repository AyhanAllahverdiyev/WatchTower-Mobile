// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NfcBlockWidget extends StatelessWidget {
  final String order;
  final bool isOrderDone;
  const NfcBlockWidget({Key? key, required this.order,required this.isOrderDone}) : super(key: key);

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
                      order,
                      style: TextStyle(fontSize: 28.0, color: Colors.white),
                    ),
                    isOrderDone?Icon(Icons.check_circle,color: Colors.green,):
                    Icon(Icons.remove_circle,color: Colors.red,),
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
