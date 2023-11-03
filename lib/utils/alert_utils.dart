import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

import '../services/db_service.dart';


class AlertUtils{


  Future<void> SuccessfullySavedAlert(BuildContext context) async {

    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a Tag'),
          content: TextField(
            onChanged: (value) {
    
            },
    
          ),
          
        );
      },
    );

  }
}
