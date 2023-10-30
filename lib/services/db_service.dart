import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DbServices {
  Future<bool> saveToDatabase(BuildContext context, String inputString) async {
    try {
      final jsonObject = jsonDecode(inputString);
      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        //192.168.1.153
        Uri.parse('http://192.168.1.153:3000/logs'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');

        return false;
      } else {
        print('OKEE: ${response}');
        return true;
      }
    } catch (e) {
      print("error in db_servces : $e");
      return false;
    }
  }

 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> updateArray(List<String> array) async {
    final url = 'http://192.168.1.153:3000/order';
    print('trying to set read order : $array');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'allowedOrderArray': array,
        }),
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
      } else {
        print('OK: ${response.body}');
      }
    } catch (e) {
      print("Error in db_services: $e");
    }
  }
}
