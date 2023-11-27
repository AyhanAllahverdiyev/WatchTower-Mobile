import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/services/nfc_Services.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

String baseUrl = LoginUtils().baseUrl;
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jwt = prefs.getString('jwt');

  // Adjust the logout endpoint to accept the JWT in the request body
  final response = await http.post(
    Uri.parse(baseUrl + 'logout'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({'jwt': jwt}), // Sending JWT in the request body
  );
  print(response.body);
  bool result = await NfcService().resetReadOrder();
  await resetRead();
  if (response.statusCode == 200) {
    prefs.remove('jwt');
    print('Logged out successfully');
  } else {
    print('Logout failed: ${response.body}');
  }
}

Future<void> resetRead() async {
  var url =
      Uri.parse(baseUrl + 'logs/reset_read'); // Replace with your API endpoint

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful GET request
      print('Response: ${response.body}');
      // Process the response data here
    } else {
      // Request failed with an error code
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Error occurred during the request
    print('Error: $e');
  }
}
