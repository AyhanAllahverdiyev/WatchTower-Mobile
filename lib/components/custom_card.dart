// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final String title;
  final String imgRoute;
  final String customWidth;

  const CustomCard(
      {Key? key,
      required this.text,
      required this.title,
      required this.imgRoute,required this.customWidth})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.purple.shade800,
        clipBehavior: Clip.hardEdge,
        shadowColor: Colors.blueGrey,
        child: InkWell(
          splashColor: Colors.grey.withAlpha(90),
          onTap: () {},
          child: Container(
            height: 180,
               width: customWidth == 'full'
          ? MediaQuery.of(context).size.width - 48
           : (MediaQuery.of(context).size.width - 58) / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Text(text,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                if (imgRoute != '')
                  Image(
                    image: AssetImage(imgRoute),
                  ),
              ],
            ),
          ),
        ));
  }
}
