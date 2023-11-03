// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

import '../services/db_service.dart';
import 'package:quickalert/quickalert.dart';

class addNewTag {
  String tagName;
  bool isConfirmed;
  addNewTag(this.tagName, this.isConfirmed);
}

class AlertUtils {
  bool isDialogOpen = false;
  Future<void> successfulAlert(
      String successMessage, BuildContext context) async {
    isDialogOpen = true;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      showConfirmBtn: false,
      title: successMessage,
      autoCloseDuration: Duration(milliseconds: 1500),
      titleColor: Colors.green,
    );
    isDialogOpen = false;
  }

  Future<void> errorAlert(String errorMessage, BuildContext context) async {
    isDialogOpen = true;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: errorMessage,
      titleColor: Colors.red,
      showConfirmBtn: false,
      autoCloseDuration: Duration(milliseconds: 1500),
    );
    isDialogOpen = false;
  }

  Future<addNewTag> addNewTagDialog(BuildContext context) async {
    String newTag = '';
    bool isConfirmed = false;

    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      barrierDismissible: true,
      confirmBtnText: 'Save',
      cancelBtnText: 'Cancel',
      showCancelBtn: true,
      title: 'Add a Tag',
      widget: TextFormField(
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter Tag Name',
          prefixIcon: Icon(
            Icons.create,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) => newTag = value,
      ),
      onConfirmBtnTap: () async {
        isConfirmed = true;
        Navigator.pop(context);
      },
      onCancelBtnTap: () async {
        isConfirmed = false;
        Navigator.pop(context);
      },
    );

    return addNewTag(newTag, isConfirmed);


  }
}
