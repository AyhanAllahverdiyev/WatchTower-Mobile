import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

import '../services/db_service.dart';

class NfcOrderUtils{


  Future<void> setAsDefaultReadOrder(List<String> newOrder) async {
    print('Final format of list after re-ordering: $newOrder');
    await DbServices().updateArray(newOrder);
  }
  
  
  

 
}