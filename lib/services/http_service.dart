import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/login_utils.dart';

class ApiResponse {
  final int statusCode;
  final String response;

  ApiResponse(this.statusCode, this.response);
}

class HttpServices {
  Future<ApiResponse> loginPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,
      };

      print('what is being sent to the server: $jsonObject');

      final response = await http.post(
        //Uri.parse('http://localhost:3000/login'),
        
        Uri.parse('http://192.168.1.119:3000/login'), // ev
        
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

  Future<ApiResponse> signUpPost(String email, String password) async {
    try {
      final jsonObject = {
        "email": email,
        "password": password,
      };

      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        //Uri.parse('http://localhost:3000/signup'),
        Uri.parse('http://192.168.1.119:3000/signup'), //ev
        

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

}
