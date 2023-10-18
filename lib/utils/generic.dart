import 'dart:async';

import 'package:flutter/material.dart';

class DialogUtils {
  void showAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    IconData? iconData;
    Color? iconColor;

    if (title == 'ERROR') {
      iconData = Icons.error;
      iconColor = Colors.red;
    } else if (title == 'OK') {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    }

    final GlobalKey<_AnimatedAlertState> animatedAlertKey =
        GlobalKey<_AnimatedAlertState>();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _AnimatedAlert(
          key: animatedAlertKey,
          iconData: iconData,
          iconColor: iconColor,
          message: message,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );

    // Close the dialog after 3 seconds
    Future.delayed(Duration(seconds: 2), () {
      animatedAlertKey.currentState?.closeDialog();
    });
  }
}

class _AnimatedAlert extends StatefulWidget {
  final IconData? iconData;
  final Color? iconColor;
  final String message;

  const _AnimatedAlert({
    Key? key,
    required this.iconData,
    required this.iconColor,
    required this.message,
  }) : super(key: key);

  @override
  _AnimatedAlertState createState() => _AnimatedAlertState();
}

class _AnimatedAlertState extends State<_AnimatedAlert> {
  bool _isClosed = false;

  void closeDialog() {
    if (!_isClosed) {
      _isClosed = true;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          Icon(
            widget.iconData,
            color: widget.iconColor,
            size: 30.0,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              widget.message,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            closeDialog();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
