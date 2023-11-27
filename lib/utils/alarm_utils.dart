import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import '../pages/alert_screen.dart';
import 'package:http/http.dart' as http;

String BaseUrl = LoginUtils().baseUrl;

class WebSocketService {
  static IOWebSocketChannel? _channel;

  static Future<void> initializeWebSocket(BuildContext context) async {
    if (_channel != null) {
      return;
    }

    try {
      _channel = IOWebSocketChannel.connect('ws://192.168.1.73:3000');

      _channel!.stream.listen((data) async {
        print(data);
        if (data is String) {
          if (!data.contains(await LoginUtils().getUserId())) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertScreen(data: data)));
          }
        } else {
          String decoded = String.fromCharCodes(data);
          if (!decoded.contains(await LoginUtils().getUserId())) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertScreen(data: decoded)));
          }
        }
      });
    } catch (e) {
      print("WebSocket connection error: $e");
    }
  }

  static void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  static void dispose() {
    _channel?.sink.close();
    _channel = null;
  }

  Future<int> sendBroadcastMessageFirebase(
      String content, String type, String topic) async {
    try {
      final jsonObject = {'content': content, 'type': type, 'topic': topic};

      print('what is being broadcasted from FireBase: $jsonObject');

      final response = await http.post(
        //192.168.1.153
        Uri.parse(BaseUrl + 'sendBroadcastMessage'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jsonObject),
      );

      if (response.statusCode >= 399) {
        print('ERROR at FireBase: ${response.body}');
      } else {
        print('Message sent to topic from FireBase: ${response.body}');
      }
      return response.statusCode;
    } catch (e) {
      print("error while broadcasting message from FireBase: $e");
      return 500;
    }
  }
}
