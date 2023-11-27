// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import '../components/bottom_navigation.dart';
import './admin_nfc_order.dart';
import '../components/custom_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool isStartSelected = false;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Quick Access",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Card(
                  color: Colors.purple.shade800,
                  clipBehavior: Clip.hardEdge,
                  shadowColor: Colors.blueGrey,
                  child: InkWell(
                    splashColor: Colors.grey.withAlpha(90),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NfcOrderPage()));
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width - 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Change Order!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text("Reorder NFC Tags Now",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/images/nfc_reader.png'),
                            height: 180,
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 20),
              SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: false,
                ),
                items: [
                  CustomCard(
                      text: "Change Auth Level",
                      title: "Change Auth Level",
                      imgRoute: "assets/images/nfc.png",
                      customWidth: 'full',
                      navigatorName: "UsersListPage"),
                  CustomCard(
                      text: "Second Card",
                      title: "Card 2",
                      imgRoute: "assets/images/nfc.png",
                      customWidth: 'full',
                      navigatorName: ""),
                  CustomCard(
                      text: "Third Card",
                      title: "Card 3",
                      imgRoute: "assets/images/nfc.png",
                      customWidth: 'full',
                      navigatorName: ""),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
