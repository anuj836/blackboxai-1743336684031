import 'package:flutter/material.dart';

class ErrorAlert {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}