import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/generic.dart';

class HttpServices {
  Future<bool> loginPost(BuildContext context, String inputString) async {
    try {
      final jsonObject = jsonDecode(inputString);
      print('what is being sent to server: $jsonObject');

      final response = await http.post(
        Uri.parse('http://192.168.1.232:3000/post'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        // Show a message to inform the user about failure
        DialogUtils()
            .showAlertDialog(context, 'ERROR', response.body.toString());
        return false;
      } else {
        // Show a message to inform the user about success
        DialogUtils().showAlertDialog(context, 'OK', "Okuma Işlemi Başarılı");
        return true;
      }
    } catch (e) {
      print("error in db_servces : $e");
      return false;
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<String>> fetchOrderArray() async {
    final url = 'http://192.168.1.232:3000/order';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final allowedOrderArray = jsonResponse['allowedOrderArray'];

        // Ensure each element is a String
        List<String> stringArray =
            allowedOrderArray.map<String>((item) => item.toString()).toList();

        // Print the array (you cannot write to .env file directly on client-side)
        print('Received array: $stringArray');
        return stringArray;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> updateArray(List<String> array) async {
    final url = 'http://192.168.1.232:3000/order';
    print('trying to set read order : $array');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'allowedOrderArray': array,
        }),
      );

      if (response.statusCode >= 399) {
        print('ERROR: ${response.body}');
      } else {
        print('OK: ${response.body}');
      }
    } catch (e) {
      print("Error in db_services: $e");
    }
  }
}
