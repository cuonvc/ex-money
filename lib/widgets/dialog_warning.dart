import 'package:ex_money/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showDialogWarningSingle(BuildContext context, String title, String content) {
  showDialog(
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
                child: const Text("OK", style: TextStyle(color: cPrimary),)
            ),
          ],
        );
      }
  );
}