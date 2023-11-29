// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/admin_user_list.dart';
import '../pages/admin_home.dart';

class HistoryCard extends StatelessWidget {
  final String tagId;
  final String date;
  final String batteryLevel;
  final String name;
  final bool isItself;

  const HistoryCard(
      {Key? key,
      required this.tagId,
      required this.date,
      required this.batteryLevel,
      required this.name,
      required this.isItself})
      : super(key: key);

  String changeDateFormate() {
    DateTime dateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('dd.MM.yyyy').format(dateTime);
    return formattedDate;
  }

  String changeTimeFormate() {
    DateTime dateTime = DateTime.parse(date).toLocal();
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.onPrimary,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        height: 100,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 100,
                width: 25,
                decoration: BoxDecoration(
                  color:
                      (isItself) ? Colors.blue.shade700 : Colors.grey.shade900,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 78,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(changeDateFormate(),
                              style: TextStyle(
                                  fontSize: 20, 
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize
                                .min,
                            children: [
                              Icon(
                                (int.parse(batteryLevel) <= 50)
                                    ? Icons.battery_3_bar
                                    : Icons.battery_5_bar,
                                color: Colors.green.shade700,
                              ),
                          
                              Text(
                                '$batteryLevel%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700
                                  )),
                          
                          SizedBox(
                            width: 10,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.qr_code_scanner,
                              size: 24,
                              color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              SizedBox(width: 4,),
                              Text(tagId,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(children: [
                                Icon(Icons.access_time,
                                size: 19,
                                color: Theme.of(context)
                                          .colorScheme
                                          .background),
                                Text(changeTimeFormate(),
                                    style: TextStyle(
                                        fontSize: 18,
                                         color: Theme.of(context)
                                          .colorScheme
                                          .background,)),
                             
                              ],),
        
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
