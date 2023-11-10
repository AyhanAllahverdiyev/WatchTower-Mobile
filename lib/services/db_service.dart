import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import '../utils/login_utils.dart';

class dbResponse {
  final int statusCode;
  final String response;
  final String error;

  dbResponse(this.statusCode, this.response, [this.error = ""]);
}

class DbServices {
  String BaseUrl = LoginUtils().baseUrl;
  Future<bool> saveToDatabase(BuildContext context, String inputString) async {
    try {
      final jsonObject = jsonDecode(inputString);
      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        //192.168.1.153
        Uri.parse(BaseUrl + 'logs'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
        await AlertUtils().errorAlert(response.body, context);
        Navigator.pop(context);
        return false;
      } else {
        await AlertUtils()
            .successfulAlert('Please proceed to the next tag ', context);
        Navigator.pop(context);
        print('OKEE: ${response}');
        return true;
      }
    } catch (e) {
      print("error in db_servces : $e");
      await AlertUtils().errorAlert(
          'Unexpected error occured, please check connection ', context);
      Navigator.pop(context);
      return false;
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> updateArray(List<String> array) async {
    final url = BaseUrl + 'order';
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
      return response.statusCode;
    } catch (e) {
      print("Error in db_services: $e");
      return 500;
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<dbResponse> getAllUsers() async {
    final url = BaseUrl + 'get_all_users';
    print("======================getAllUsers======================");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
      } else {
        print('OK: ${response.body}');
      }
      return dbResponse(response.statusCode, response.body);
    } catch (e) {
      print("Error in db_services: $e");
      return dbResponse(500, "", e.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> changeAuthLevel(String item) async {
    final url = BaseUrl + 'change_auth_level';
    print('======================changeAuthLevel======================');
    try {
      print("item: $item");
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: item,
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
        return response.statusCode;
      } else {
        print('OK: ${response.body}');
        return response.statusCode;
      }
    } catch (e) {
      print("Error in db_services: $e");
      return 500;
    }
  }

  Future<List<int>> runChangeAuthLevel(List<String> array) async {
    List<int> statusCodeList = [];
    for (var item in array) {
      print("item: $item");
      int statusCode = await changeAuthLevel(item);
      statusCodeList.add(statusCode);
    }
    print(
        "====================================statusCodeList====================================");
    print("statusCodeList: $statusCodeList");
    return statusCodeList;
  }
}
