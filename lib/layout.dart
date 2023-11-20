import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/alert_details.dart';
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import '../pages/home.dart';
import '../pages/admin_home.dart';
import '../pages/admin_nfc_order.dart';
import '../pages/alert_screen.dart';
import '../pages/profile.dart';
import '../pages/alert_details.dart';
import 'components/bottom_navigation.dart';

class LayoutPage extends StatefulWidget {
  final int index;
  const LayoutPage({Key? key, required this.index}) : super(key: key);
  @override
  LayoutPageState createState() => LayoutPageState();
}

class LayoutPageState extends State<LayoutPage> {


  List<Widget> _pages = [
    HomePage(), //0
    AdminHomePage(), //1
    AlertDetails(), //2
    ProfilePage(), //3
    NfcHomePage(), //4
  ];

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
        body: _pages[widget.index],
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
