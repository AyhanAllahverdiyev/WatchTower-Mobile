// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/admin_home.dart';
import 'dart:convert';
import '../components/admin_bottom_navigation.dart';
import '../components/admin_nfc_block.dart';
import '../services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import '../services/db_service.dart';
import '../utils/alert_utils.dart';
import '../utils/alarm_utils.dart';

class NfcOrderPage extends StatefulWidget {
  const NfcOrderPage({super.key});

  @override
  State<NfcOrderPage> createState() => NfcOrderPageState();
}

class NfcOrderPageState extends State<NfcOrderPage> {
  List<String> allowedOrderArray = [];
  int? pressedOrderIndex;
  bool isEditing = false;
  bool isDeleteSelected = false;
  int dbResponse = 500;

  @override
  void initState() {
    super.initState();
    _getOrderArray();
  }

  Future _getOrderArray() async {
    ApiResponse orderArray = await NfcService().getOrderArray(context);
    Map<String, dynamic> jsonResponse = json.decode(orderArray.response);
    List<String> newAllowedOrderArray =
        List<String>.from(jsonResponse['allowedOrderArray']);

    setState(() {
      allowedOrderArray = newAllowedOrderArray;
    });
  }

  List<String> deleteTag(List<String> array, int index) {
    array.removeAt(index);
    print('allowedOrderArray: $allowedOrderArray');
    return array;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isEditing = false;
        });
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
                  child: TextButton(
                    onPressed: () {
                      print('pressed delete button at index $i');

                      if (isDeleteSelected) {
                        setState(() {
                          allowedOrderArray = deleteTag(allowedOrderArray, i);
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(57, 108, 126, 241),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          allowedOrderArray[i],
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        if (isDeleteSelected)
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isEditing)
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Icon(Icons.edit, color: Colors.black),
                backgroundColor: Colors.white,
              ),
            if (isEditing)
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      addNewTag newTag =
                          await AlertUtils().addNewTagDialog(context);
                      if (newTag.isConfirmed == true && newTag.tagName != '') {
                        setState(() {
                          allowedOrderArray.add(newTag.tagName);
                        });
                      }
                      if (newTag.isConfirmed == true && newTag.tagName == '') {
                        await AlertUtils()
                            .errorAlert('Tag Name Cannot Be Empty!', context);
                      }
                    },
                    tooltip: 'Add Tag',
                    child: Icon(Icons.add),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          isDeleteSelected = !isDeleteSelected;
                        });
                      },
                      tooltip: 'Delete',
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete)),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      dbResponse =
                          await DbServices().updateArray(allowedOrderArray);
                      if (dbResponse <= 399) {
                        if (AlertUtils().isDialogOpen == false) {
                          await AlertUtils()
                              .successfulAlert('Successfully Saved!', context);
                          setState(() {
                            isEditing = false;
                          });
                        }
                      } else if (dbResponse == 500) {
                        if (AlertUtils().isDialogOpen == false) {
                          await AlertUtils()
                              .errorAlert('Internal Server Error!', context);
                        }
                      }
                    },
                    tooltip: 'Save',
                    backgroundColor: Colors.green,
                    child: Icon(Icons.save),
                  ),
                ],
              ),
          ],
        ),
        bottomNavigationBar: AdminBottomAppBarWidget(),
      ),
    );
  }
}
