import 'package:flutter/material.dart';

void showDialogResponse(BuildContext context, bool isSuccess, String title, String content) {
  showDialog(
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 16),)
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(isSuccess ? 'OK' : "Huỷ"),
            ),
          ],
        );
      }
  );
}