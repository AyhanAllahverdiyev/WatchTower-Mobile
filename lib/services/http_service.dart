import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpServices {
  Future<bool> loginPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,
      };

      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print(response.body);
        return false;
      } else {
        print(response.body);
        return true;
      }
    } catch (e) {
      print("error in db_servces : $e");
      return false;
    }
  }


  Future<bool> signUpPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,

      };

      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        Uri.parse('http://localhost:3000/signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print(response.body);
        return false;
      } else {
        print(response.body);
        return true;
      }
    } catch (e) {
      print("error in db_servces : $e");
      return false;
    }
  }
}
