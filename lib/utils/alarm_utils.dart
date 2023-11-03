import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import '../pages/alert_screen.dart';

class WebSocketService {
  static IOWebSocketChannel? _channel;

  static Future<void> initializeWebSocket(BuildContext context) async {
    if (_channel != null) {
      return;
    }

    try {
      print('1111');
      _channel = IOWebSocketChannel.connect('ws://192.168.1.160:3000');

      _channel!.stream.listen((data) async {
        print('datadatadatadata');
        print(data);
        if (data is String) {
          if (!data.contains(await LoginUtils().getUserId())) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertScreen(data: data)));
          }
        } else {
          print('2');
          String decoded = String.fromCharCodes(data);
          if (!decoded.contains(await LoginUtils().getUserId())) {
            print('3');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertScreen(data: decoded)));
          }
        }
      });
    } catch (e) {
      print('3');
      print("WebSocket connection error: $e");
      // Handle the error as needed
    }
  }

  static void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  static void dispose() {
    _channel?.sink.close();
    _channel = null;
  }
}
