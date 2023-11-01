// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/admin_bottom_navigation.dart';
import '../components/admin_nfc_block.dart';
import '../services/nfc_Services.dart';
import '../utils/nfc_order_utils.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import '../services/db_service.dart';

class NfcOrderPage extends StatefulWidget {
  const NfcOrderPage({super.key});

  @override
  State<NfcOrderPage> createState() => _NfcOrderPageState();
}

class _NfcOrderPageState extends State<NfcOrderPage> {
  List<String> allowedOrderArray = [];
  int? pressedOrderIndex;

  @override
  void initState() {
    _getOrderArray();
  }

  Future _getOrderArray() async {
    ApiResponse orderArray = await NfcService().getOrderArray();
    Map<String, dynamic> jsonResponse = json.decode(orderArray.response);
    List<String> newAllowedOrderArray =
        List<String>.from(jsonResponse['allowedOrderArray']);

    setState(() {
      allowedOrderArray = newAllowedOrderArray;
    });
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
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final String item = allowedOrderArray.removeAt(oldIndex);
                allowedOrderArray.insert(newIndex, item);
              });
            },
            children: [
              for (var i = 0; i < allowedOrderArray.length; i++)
                Container(
                  key: ValueKey(allowedOrderArray[i]),
                  child: AdminNfcBlockWidget(order: allowedOrderArray[i]),
                ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                addTag newTag = await NfcOrderUtils().showAddTagDialog(context);
                if (newTag.isConfirmed == true) {
                   setState(() {
                  allowedOrderArray.add(newTag.tagName);
                });
                }
               
              },
              tooltip: 'Add Tag',
              child: Icon(Icons.add),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print(allowedOrderArray);
                NfcOrderUtils().setAsDefaultReadOrder(allowedOrderArray);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 25),
                primary: Colors.green,
              ),
            ),
          ],
        ),
        bottomNavigationBar: AdminBottomAppBarWidget(),
      ),
    );
  }
}
