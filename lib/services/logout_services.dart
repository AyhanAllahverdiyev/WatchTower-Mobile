import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/pages/nfcHome.dart';
import 'package:watch_tower_flutter/services/nfc_Services.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class logoutServices {
  String baseUrl = LoginUtils().baseUrl;
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    LoginUtils().printAllSharedPreferences();

    final response = await http.post(
      Uri.parse(baseUrl + 'logout'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'jwt': jwt}), // Sending JWT in the request body
    );
    print(response.body);
    bool result = await NfcService().resetReadOrder();
    if (response.statusCode == 200) {
      prefs.remove('jwt');
      print('Logged out successfully');
      NfcHomePageState().endSession();
    } else {
      print('Logout failed: ${response.body}');
    }
  }
}
