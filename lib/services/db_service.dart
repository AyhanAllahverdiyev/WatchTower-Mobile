import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/services/login_Services.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import '../utils/login_utils.dart';
import '../pages/nfcHome.dart';

class dbResponse {
  final int statusCode;
  final String response;
  final String error;

  dbResponse(this.statusCode, this.response, [this.error = ""]);
}

class DbServices {
  int keyvalue = 0;
  String BaseUrl = LoginUtils().baseUrl;
  Future<bool> saveToDatabase(BuildContext context, String inputString) async {
    try {
      final jsonObject = jsonDecode(inputString);
      print('what is being sent to server: $jsonObject');
      final response = await http.post(
        Uri.parse(BaseUrl + 'logs'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
        await AlertUtils().errorAlert(response.body, context);
        return false;
      } else if (response.statusCode == 302) {
        await AlertUtils().successfulAlert('Tour Completed', context);
        print('inputString: ${inputString}');
        String jsonStringWithoutQuotes =
            inputString.substring(1, inputString.length - 1);
        print('jsonStringWithoutQuotes: ${jsonStringWithoutQuotes}');
        Map<String, dynamic> newJsonObject =
            json.decode('{$jsonStringWithoutQuotes}');
        print('newJsonObject: ${newJsonObject}');
        print('ID: ${newJsonObject['ID']}');
        await NfcHomePageState()
            .updateIsReadValue(newJsonObject['ID'].toString(), 'true');
        print('Final version of orderJsonArray:${orderJsonArray}}');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NfcHomePage()),
          (route) =>
              false, // This condition always returns false, so it clears everything
        );
        return true;
      } else {
        await AlertUtils()
            .successfulAlert('Please proceed to the next tag ', context);
        print('inputString: ${inputString}');
        String jsonStringWithoutQuotes =
            inputString.substring(1, inputString.length - 1);
        print('jsonStringWithoutQuotes: ${jsonStringWithoutQuotes}');
        Map<String, dynamic> newJsonObject =
            json.decode('{$jsonStringWithoutQuotes}');
        print('newJsonObject: ${newJsonObject}');
        print('ID: ${newJsonObject['ID']}');
        await NfcHomePageState()
            .updateIsReadValue(newJsonObject['ID'].toString(), 'true');
        print('Final version of orderJsonArray:${orderJsonArray}}');

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

/////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> updateArray(List<Map<String, dynamic>> array) async {
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
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<ApiResponse> getUserHistory() async {
    final url = BaseUrl + 'logs/user_history';
    print('======================getUserHistory======================');
    String userId= await LoginUtils().getUserId();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          '_id': userId,
        }),
      );
      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
      } else {
        print('OK: ${response.body}');
      }
      return ApiResponse(response.statusCode, response.body);
    } catch (e) {
      print("Error in db_services: $e");
      return ApiResponse(500, e.toString());
    }
  }

}
