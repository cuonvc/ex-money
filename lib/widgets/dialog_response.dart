import 'package:flutter/material.dart';

import '../utils/constant.dart';

//chỉ dùng cho Bloc listener được thôi
Future<void> showDialogResponse(BuildContext context, bool isSuccess, String title, String content) {
  return showDialog(
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(title, style: const TextStyle(fontSize: 16),))
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

Future<void> showDialogToRedirectLogin(BuildContext context, String message) {
  return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    NavigatePath.authSelectionPath, (route) => false,
                  );
                // });
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
  );
}