import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'nfc_Services.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final int statusCode;
  final String response;

  ApiResponse(this.statusCode, this.response);
}

class HttpServices {
  String BaseUrl = LoginUtils().baseUrl;

  Future<ApiResponse> loginPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,
      };

      print('what is being sent to the server: $jsonObject');

      final response = await http.post(
        Uri.parse(BaseUrl + 'login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );
      final cookies = response.headers['set-cookie'];

      // Split the cookie string to individual cookies
      final cookieList = cookies?.split(';');

      // Find and print the "hwt" cookie
      late String jwtCookieValue;
      if (response.statusCode == 200) {
        for (final cookie in cookieList!) {
          if (cookie.trim().startsWith('jwt=')) {
            final prefs = await SharedPreferences.getInstance();
            jwtCookieValue = cookie.trim().substring(4);
            prefs.setString('jwt', jwtCookieValue);
            break;
          }
        }
        print('======================RESPONSE======================');
        print('JWT Cookie Value: $jwtCookieValue');

        final statusCode = response.statusCode;
        final responseBody = response.body;

        print('Response Status Code: $statusCode');
        print('Response Body: $responseBody');

        return ApiResponse(statusCode, responseBody);
      } else {
        print(response.body);
        return ApiResponse(response.statusCode, response.body);
      }
    } catch (e) {
      print("Error in login post  : $e");
      return ApiResponse(-1, "Error: $e");
    }
  }

  Future<bool> verifyToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt') ?? '';
    final response = await http.post(
      Uri.parse(BaseUrl + 'jwt-verify'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"jwt": jwt}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<ApiResponse> signUpPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,
      };

      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        Uri.parse(BaseUrl + 'signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      final statusCode = response.statusCode;
      final responseBody = response.body;

      print('Response Status Code: $statusCode');
      print('Response Body: $responseBody');

      return ApiResponse(statusCode, responseBody);
    } catch (e) {
      print("Error in db_services : $e");
      return ApiResponse(-1, "Error: $e");
    }
  }

  Future<bool> logout() async {
    print(
        '==========================Before LOGOUT============================');
    await NfcService().printAllSharedPreferences();
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove('jwt');
    });
    print('==========================After LOGOUT============================');
    NfcService().printAllSharedPreferences();
    return Future.value(true);
  }
}
