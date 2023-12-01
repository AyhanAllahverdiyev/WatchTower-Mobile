import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/services/nfc_Services.dart';

import 'package:watch_tower_flutter/utils/login_utils.dart';

import 'login_Services.dart';


class SessionService {
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<ApiResponse> checkSessionStatus() async {
    if (await HttpServices().verifyToken()) {
      String userId = await LoginUtils().getUserId();

      final url = LoginUtils().baseUrl + 'session/check';

      print('======================Check Session======================');
      try {
        final response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(<String, String>{'id': userId}));

        if (response.statusCode >= 399) {
          print('ERROR: ${response.body}');
          return ApiResponse(response.statusCode, response.body);
        } else {
          print('OK: ${response.body}');
          return ApiResponse(response.statusCode, response.body);
        }
      } catch (e) {
        print("Error in db_services: $e");
        return ApiResponse(500, "Error: $e");
      }
    } else {
      print('JWT is not valid');
      return ApiResponse(-1, "Error: JWT is not valid");
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> endActiveSessionStatus() async {
    if (await HttpServices().verifyToken()) {
      String userId = await LoginUtils().getUserId();

      final url = LoginUtils().baseUrl + 'session/end';

      print('======================Check Session======================');
      try {
        final response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(<String, String>{'id': userId}));

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
    } else {
      print('JWT is not valid');
      return -1;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<ApiResponse> createNewSession() async {
    if (await HttpServices().verifyToken()) {
      String userId = await LoginUtils().getUserId();

      final url = LoginUtils().baseUrl + 'session/create';

      print('======================Check Session======================');
      try {
           var orderArray = await NfcService().getOrderArray();
    List<dynamic> jsonResponse = jsonDecode(orderArray.response);
        final response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(<String, dynamic>{
              'userId': userId,
              "isActive": true,
              'tagOrderIsread': jsonResponse
            }));

        if (response.statusCode >= 399) {
          print('ERROR: ${response.body}');
          return ApiResponse(response.statusCode, response.body);
        } else {
          print('OK: ${response.body}');
          return ApiResponse(response.statusCode, response.body);
        }
      } catch (e) {
        print("Error in db_services: $e");
        return ApiResponse(500, "Error: $e");
      }
    } else {
      print('JWT is not valid');
      return ApiResponse(-1, "Error: JWT is not valid");
    }
  }


}
