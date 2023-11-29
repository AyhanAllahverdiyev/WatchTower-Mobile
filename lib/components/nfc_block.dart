// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NfcBlockWidget extends StatelessWidget {
  final String order;
  final String isRead;
  final int index;

  const NfcBlockWidget({
    Key? key,
    required this.order,
    required this.isRead,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
        
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                            index != 0
                                ? SizedBox(
                                    height: 30,
                                    child: Container(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                  )
                                : SizedBox(
                                    height: 30,
                                  ),
                            isRead == 'true'
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 40,
                                  )
                                : Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                          ],
                        ),
                       
                
                        Row(
                          children: [

                            SizedBox(
                              width: 10.0,
                            ),
                          
                            Padding(
                              padding:  EdgeInsets.only(top: 25.0),
                              child: Text(
                                'Tag Id: ',
                                style: TextStyle(
                                  fontSize: 28.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Text(
                                order,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 28.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
       
        ],
      ),
    );
  }
}
