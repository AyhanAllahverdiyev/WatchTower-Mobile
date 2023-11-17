import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jwt = prefs.getString('jwt');
  String baseUrl = LoginUtils().baseUrl;

  // Adjust the logout endpoint to accept the JWT in the request body
  final response = await http.post(
    Uri.parse(baseUrl + 'logout'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({'jwt': jwt}), // Sending JWT in the request body
  );
  print(response.body);

  if (response.statusCode == 200) {
    prefs.remove('jwt');
    print('Logged out successfully');
  } else {
    print('Logout failed: ${response.body}');
  }
}
