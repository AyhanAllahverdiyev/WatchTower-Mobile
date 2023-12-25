// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last

import 'dart:io';

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
import 'package:uuid/uuid.dart';

class NfcOrderPage extends StatefulWidget {
  const NfcOrderPage({super.key});

  @override
  State<NfcOrderPage> createState() => NfcOrderPageState();
}

class NfcOrderPageState extends State<NfcOrderPage> {
  WritingResult resultOfNfcWrite=WritingResult(NfcData(card_id: "", name: "", loc: Location(lat: "", long: "")), false);
  var uuid = Uuid();
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

  int a = 0;
  int generateID() {
    a++;
    return a;
  }

  Future _getOrderArrayForAdmin() async {
    ApiResponse orderArray = await NfcService().getOrderArray();
    List<dynamic> jsonResponse = jsonDecode(orderArray.response);
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
    print('jsonResponse: $jsonResponse');

    for (var item in jsonResponse) {
      if (item.containsKey('name')) {
        newAllowedOrderArray.add(item['name']);

        addValuesToArray(item['name'], false, item['index'], item['card_id'],
            Location(lat: item['loc']['lat'], long: item['loc']['long']));
      }
    }

    if (resultArray.isEmpty) {
      await AlertUtils().InfoAlert('No Tags Found!', context);
    }

    setState(() {
      allowedOrderArray = newAllowedOrderArray;
    });
  }

  List<String> deleteTag(List<String> array, int index) {
    array.removeAt(index);

    return array;
  }

  void addValuesToArray(
      String name, bool order, int index, String card_id, Location loc) {
    setState(() {
      resultArray.add({
        'name': name,
        'isRead': order,
        'index': index,
        'card_id': card_id,
        'loc': loc.toJson()
      });
    });
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
                final Map<String, dynamic> movedItem =
                    resultArray.removeAt(oldIndex);
                resultArray.insert(newIndex, movedItem);
              });
            },
            children: [
              for (var i = 0; i < allowedOrderArray.length; i++)
                Container(
                  key: ValueKey(generateID()),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextButton(
                      onPressed: () {
                        print('pressed delete button at index $i');

                        if (isDeleteSelected) {
                          setState(() {
                            allowedOrderArray =
                                deleteTag(newAllowedOrderArray, i);
                            resultArray.removeAt(i);
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
                      var newTagName =
                          await AlertUtils().addNewTagDialog(context);
                      if (newTagName.isConfirmed) {
                        if (newTagName.tagName.isEmpty) {
                          await AlertUtils()
                              .errorAlert('Tag Name Cannot Be Empty!', context);
                        } else if (allowedOrderArray
                            .contains(newTagName.tagName)) {
                          await AlertUtils()
                              .errorAlert('Tag names must be unique', context);
                        } else {
                          var nfcData = await NfcService()
                              .createNfcData(newTagName.tagName);
                       
                  
                           if(Platform.isIOS){
                            print("!!!!!!!!!!!!!!!!!!! IOS !!!!!!!!!!!!!!!!!!!!!!!!");
                            var resultOfNfcWrite =
                              await NfcService().writeServiceForIOS(nfcData);
                              setState(() {
                                resultOfNfcWrite=resultOfNfcWrite;
                              });
                              print('resultOfNfcWrite: $resultOfNfcWrite');
                              if (resultOfNfcWrite.status) {
                            setState(() {
                              allowedOrderArray.add(newTagName.tagName);
                              addValuesToArray(
                                  newTagName.tagName,
                                  false,
                                  index++,
                                  resultOfNfcWrite.nfcData.card_id,
                                  resultOfNfcWrite.nfcData.loc);
                            });
                          } else {
                            await AlertUtils()
                                .errorAlert('Error Writing to Tag', context);
                          }

                          }else{
                          print("!!!!!!!!!!!!!!!!!!! Other !!!!!!!!!!!!!!!!!!!!!!!!");
                                var resultOfNfcWrite =
                              await NfcService().writeService(nfcData);
                              setState(() {
                                resultOfNfcWrite=resultOfNfcWrite;
                              });
                              print('resultOfNfcWrite: $resultOfNfcWrite');
                              if (resultOfNfcWrite.status) {
                            setState(() {
                              allowedOrderArray.add(newTagName.tagName);
                              addValuesToArray(
                                  newTagName.tagName,
                                  false,
                                  index++,
                                  resultOfNfcWrite.nfcData.card_id,
                                  resultOfNfcWrite.nfcData.loc);
                            });
                          } else {
                            await AlertUtils()
                                .errorAlert('Error Writing to Tag', context);
                          }
                          }
                       
               
                     
                          
                        }
                      }
                    },
                    tooltip: 'Add Tag',
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: () {}, child: Text('STOP')),
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
                      if (isDeleteSelected) {
                        setState(() {
                          isDeleteSelected = !isDeleteSelected;
                        });
                      }

                      index = 0;

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
