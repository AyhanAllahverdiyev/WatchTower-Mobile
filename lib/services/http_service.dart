import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HttpServices {
  Future<bool> loginPost(BuildContext context, String email, String password) async {
  try {
    final jsonObject = {
      "email": email,
      "password": password,
    };

    print('what is being sent to server: $jsonObject');

    final response = await http.post(
      Uri.parse('http://192.168.1.232:3000/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(jsonObject),
    );

    if (response.statusCode >= 399) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    print("error in db_servces : $e");
    return false;
  }
}


}
