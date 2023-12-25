import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import 'package:watch_tower_flutter/services/nfc_Services.dart';
import 'package:watch_tower_flutter/services/session_services.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class logoutServices {
  String baseUrl = LoginUtils().baseUrl;
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    LoginUtils().printAllSharedPreferences();
    if (jwt != null) {
      final response = await http.post(
        Uri.parse(baseUrl + 'logout'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'jwt': jwt}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        prefs.remove('jwt');
        print('Logged out successfully');
        await SessionService().endActiveSessionStatus();
        await prefs.clear();
      } else {
        print('Logout failed: ${response.body}');
      }
    } else {
      print('jwt is null');
      await prefs.clear();
      print('Logged out successfully');
      await SessionService().endActiveSessionStatus();
    }
  }






   Future<void> logout2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    LoginUtils().printAllSharedPreferences();
    if (jwt != null) {
      final response = await http.post(
        Uri.parse(baseUrl + 'logout'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'jwt': jwt}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        prefs.remove('jwt');
        print('Logged out successfully');
        await SessionService().endActiveSessionStatus();
       } else {
        print('Logout failed: ${response.body}');
      }
    } else {
      print('jwt is null');
       print('Logged out successfully');
      await SessionService().endActiveSessionStatus();
    }
  }
}
