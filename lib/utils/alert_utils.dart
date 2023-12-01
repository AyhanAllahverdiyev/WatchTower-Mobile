// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import 'package:watch_tower_flutter/services/session_services.dart';
import '../services/nfc_Services.dart';
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
      backgroundColor: Theme.of(context).colorScheme.background,
      titleColor: Colors.red,
      showConfirmBtn: false,
      autoCloseDuration: Duration(milliseconds: 1500),
    );
    isDialogOpen = false;
  }

  Future<void> InfoAlert(String infoMessage, BuildContext context) async {
    isDialogOpen = true;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      showConfirmBtn: false,
      title: infoMessage,
      backgroundColor: Theme.of(context).colorScheme.background,
      autoCloseDuration: Duration(milliseconds: 1500),
      titleColor: Colors.yellow,
    );
    isDialogOpen = false;
  }

  Future<void> loadingAlert(BuildContext context) async {
    isDialogOpen = true;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      showConfirmBtn: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: 'Loading',
      autoCloseDuration: Duration(milliseconds: 1500),
      titleColor: Colors.yellow,
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

  ////////////////////////////////////////////////////////////////////////
 Future<void> confirmNewSessionAlert(String message, bool isSessionActive, BuildContext context) async {
  await QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: message,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
    backgroundColor: Theme.of(context).colorScheme.background,
    onConfirmBtnTap: () async {
      Navigator.pop(context);

      if (isSessionActive) {
        int endSessionResult = await SessionService().endActiveSessionStatus();
        print("Alert utils end session result: $endSessionResult");
        if (endSessionResult < 400) {
          print('Session ended successfully');
          
          var startSessionResult = await SessionService().createNewSession();
          if (startSessionResult.statusCode < 400) {
            print('New session started');
            await successfulAlert('New Session Initialized!', context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NfcHomePage(isOldSessionOn: false)),
            );
          } else {
            print('Error starting a new session');
            await errorAlert('System was not able to launch a new session', context);
            Navigator.pop(context);
          }
        } else {
          print('Error ending the active session');
          await errorAlert('Unable to end the current session', context);
          Navigator.pop(context);
        }
      } else {
        var startSessionResult = await SessionService().createNewSession();
        if (startSessionResult.statusCode < 400) {
          print('New session started');
          await successfulAlert('New Session Initialized!', context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NfcHomePage(isOldSessionOn: false)),
          );
        } else {
          print('Error starting a new session');
          await errorAlert('System was not able to launch a new session', context);
          Navigator.pop(context);
        }
      }
    },
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
  );
}


  Future<void> handleActiveSession(BuildContext context) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Continue from where you left off in the last session.',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onCancelBtnTap: () {
        Navigator.pop(context);
    
      },
      onConfirmBtnTap: () async {
             Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NfcHomePage(isOldSessionOn: true,)),
          );
      },
    );
  }
}
