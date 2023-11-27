// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import '../components/bottom_navigation.dart';
import './nfcHome.dart';
import '../components/custom_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  

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
       body:SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quick Access",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                    ),
                    items: [
                      CustomCard(
                          text: "First Card",
                          title: "Card 1",
                          imgRoute: "assets/images/nfc_reader.png",
                          customWidth: 'full',
                          navigatorName: "",
               ),
                      CustomCard(
                          text: "Second Card",
                          title: "Card 2",
                          imgRoute: "assets/images/nfc_reader.png",
                          customWidth: 'full',
                          navigatorName: "",
     
                          ),
                      CustomCard(
                          text: "Third Card",
                          title: "Card 3",
                          imgRoute: "assets/images/nfc_reader.png",
                          customWidth: 'full',
                          navigatorName: "",),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.purpleAccent.shade700, width: 2)),
                      color: Colors.black,
                      clipBehavior: Clip.hardEdge,
                      shadowColor: Colors.blueGrey,
                      child: InkWell(
                        splashColor: Colors.grey.withAlpha(90),
                        onTap: () {
                          if (NfcHomePageState.session == false) {
                            AlertUtils().confirmationAlert('New Session', context);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NfcHomePage()),
                            );
                          }
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text("Start Tour!",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purpleAccent.shade700)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: Text("Scan NFC Tags Now",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        AlertUtils().confirmationAlert(
                                            'New Session', context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0, top: 10, bottom: 10),
                                        child: Text('New Session',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.purpleAccent.shade700),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image(
                                image: AssetImage('assets/images/nfc_reader.png'),
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      CustomCard(
                          text: "First Card",
                          title: "Card 1",
                          imgRoute: "assets/images/nfc.png",
                          customWidth: 'half',
                          navigatorName: "",
                   ),
                      CustomCard(
                          text: "Second Card",
                          title: "Card 2",
                          imgRoute: "assets/images/nfc.png",
                          customWidth: 'half',
                          navigatorName: "",
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(pageName: "HomePage",),
      ),
    );
  }
}
