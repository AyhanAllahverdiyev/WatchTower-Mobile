// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_tower_flutter/main.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'dart:convert';
import '../components/bottom_navigation.dart';
import '../services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/login_Services.dart';
import '../services/db_service.dart';
import '../utils/alert_utils.dart';

class NfcOrderPage extends StatefulWidget {
  const NfcOrderPage({super.key});

  @override
  State<NfcOrderPage> createState() => NfcOrderPageState();
}

class NfcOrderPageState extends State<NfcOrderPage> {
  List<Map<String, dynamic>> resultArray = [];
  List<dynamic> allowedOrderArray = [];
  List<String> newAllowedOrderArray = [];
  int? pressedOrderIndex;
  bool isEditing = false;
  bool isDeleteSelected = false;
  int dbResponse = 500;
  bool isLightModeSelected = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _getOrderArrayForAdmin();
    LoginUtils().getThemeMode().then((value) {
      setState(() {
        isLightModeSelected = value;
      });
    });
  }

  Future _getOrderArrayForAdmin() async {
    ApiResponse orderArray = await NfcService().getOrderArray(context);
    print("orderArray: ${orderArray.response}");
    Map<String, dynamic> jsonResponse = json.decode(orderArray.response);

    print('allowedOrderArrayAA: $jsonResponse');

    setState(() {
      //  allowedOrderArray = newAllowedOrderArray;
    });
  }

  List<String> deleteTag(List<String> array, int index) {
    array.removeAt(index);
    print('NewallowedOrderArray: $newAllowedOrderArray');
    return array;
  }

  void addValuesToArray(String name, bool order, int index) {
    resultArray.add({'name': name, 'isRead': order, 'index': index});
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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    !isLightModeSelected ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleThemeMode();

                    setState(() {
                      isLightModeSelected = !isLightModeSelected;
                    });
                  },
                ),
              ],
            )),
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextButton(
                      onPressed: () {
                        print('pressed delete button at index $i');

                        if (isDeleteSelected) {
                          setState(() {
                            allowedOrderArray =
                                deleteTag(newAllowedOrderArray, i);
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.nfc_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text("Tag Name: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background)),
                                Text(
                                  allowedOrderArray[i],
                                  style: TextStyle(
                                    fontSize: 25.0,
                                  ),
                                ),
                              ],
                            ),
                            if (isDeleteSelected)
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
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
                child: Icon(Icons.edit,
                    color: Theme.of(context).colorScheme.background),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            if (isEditing)
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      addNewTag newTag =
                          await AlertUtils().addNewTagDialog(context);
                      if (newTag.isConfirmed) {
                        if (newTag.tagName.isEmpty) {
                          await AlertUtils()
                              .errorAlert('Tag Name Cannot Be Empty!', context);
                        } else if (allowedOrderArray.contains(newTag.tagName)) {
                          await AlertUtils()
                              .errorAlert('Tag names must be unique', context);
                        } else {
                          setState(() {
                            allowedOrderArray.add(newTag.tagName);
                          });
                        }
                      }
                    },
                    tooltip: 'Add Tag',
                    child: Icon(Icons.add, color: Colors.white),
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
                      child: Icon(Icons.delete, color: Colors.white)),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      resultArray.clear();
                      index = 0;
                      newAllowedOrderArray.forEach((element) {
                        addValuesToArray(element, false, index++);
                      });
                      index = 0;

                      dbResponse = await DbServices().updateArray(resultArray);
                      print('newAllowedOrderArray: $newAllowedOrderArray');
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
                    child: Icon(Icons.save, color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBarWidget(
          pageName: "NfcOrderPage",
        ),
      ),
    );
  }
}
