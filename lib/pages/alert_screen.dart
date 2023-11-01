import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  final String data;
  const AlertScreen({super.key, required this.data});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    String message = widget.data;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(57, 108, 126, 241),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
