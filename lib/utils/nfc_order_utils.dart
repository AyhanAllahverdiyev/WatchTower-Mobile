import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

import '../services/db_service.dart';

class addTag{
  String tagName;
  bool isConfirmed;
  addTag(this.tagName, this.isConfirmed);

}
class NfcOrderUtils{
  Future<void> setAsDefaultReadOrder(List<String> newOrder) async {
    print('Final format of list after re-ordering: $newOrder');
    await DbServices().updateArray(newOrder);
  }

  Future<addTag> showAddTagDialog(BuildContext context) async {
    String newTag = '';
    bool isConfirmed = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a Tile'),
          content: TextField(
            onChanged: (value) {
              newTag = value;
            },
            decoration: InputDecoration(labelText: 'Tile content'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                isConfirmed = false;
                Navigator.pop( context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                isConfirmed = true;
                         Navigator.pop( context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
    return addTag(newTag,isConfirmed);
  }
}
