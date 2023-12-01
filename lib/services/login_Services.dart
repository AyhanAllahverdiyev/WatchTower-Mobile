import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_tower_flutter/pages/login.dart';
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
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

  Future<bool> checkIfTokenValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    String jwt = prefs.getString('jwt') ?? '';
    if (rememberMe && jwt.isNotEmpty) {
      return verifyToken();
    } else {
      return Future.value(false);
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
    print(
        '-------------------------------------------- JWT TOKEN --------------------------------------------');
    print(jwt);

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
        "auth_level": "user",
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
      print("Error while saving user to DB : $e");
      return ApiResponse(-1, "Error: $e");
    }
  }

  Future<ApiResponse> changePassword(BuildContext context, String email,
      String currentPassword, String newPassword) async {
    if (await HttpServices().verifyToken()) {
      try {
        final jsonObject = {
          "email": email,
          "password": currentPassword,
          "newPassword": newPassword,
        };
        print('what is being sent to Password Update: $jsonObject');

        final response = await http.post(
          Uri.parse(BaseUrl + 'password/update'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(jsonObject),
        );

        final statusCode = response.statusCode;
        final responseBody = response.body;

        print('Response Status Code: $statusCode');
        print('Response Body: $responseBody');

        return ApiResponse(statusCode, responseBody);
      } catch (e) {
        print("Error while updating Password : $e");
        return ApiResponse(-1, "Error: $e");
      }
    } else {
      await AlertUtils()
          .errorAlert('Session  Timeout. Please login again', context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      print('JWT is not valid');
      return ApiResponse(-1, "Error: JWT is not valid");
    }
  }
}
