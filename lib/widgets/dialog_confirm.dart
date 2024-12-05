import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showDialogConfirm(BuildContext context, String title, String content) async {
  bool? result = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(content, style: const TextStyle(fontSize: 14),))
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Hủy", style: TextStyle(color: Colors.red),)
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("OK", style: TextStyle(color: Colors.black),)
            )
          ],
        );
      }
  );

  return result ?? false;
}