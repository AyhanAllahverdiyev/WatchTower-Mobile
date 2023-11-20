// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/admin_nfc_order.dart';
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import '../services/nfc_Services.dart';
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

  Future<void> confirmationAlert(String message, BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: message,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        if (NfcHomePageState.session) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            text:
                'You already have an onging session. End previous and start a new one?',
            confirmBtnText: 'Yes',
            cancelBtnText: 'No',
            confirmBtnColor: Colors.green,
            onCancelBtnTap: () {
              Navigator.pop(context);
              print('Previous session ongoing');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NfcHomePage()));
            },
            onConfirmBtnTap: () async {
              Navigator.pop(context);
              NfcHomePageState.session = false;
              if (await NfcService().resetReadOrder()) {
                print('new sessing initialised');
                NfcHomePageState.session = true;
                await successfulAlert('New Session Initialised!', context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NfcHomePage()));
              } else {
                print('unable to launch new session');
                await errorAlert(
                    'System was not able to launch a new session', context);
                Navigator.pop(context);
              }
            },
          );
        } else {
          await successfulAlert('New Session Initialised!', context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NfcHomePage()));
        }
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
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
