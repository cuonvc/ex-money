import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constant.dart';

Widget expenseEdit(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: const  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("New expense", style: TextStyle(fontSize: 18),)
      ],
    ),
    content: SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
                LengthLimitingTextInputFormatter(11),
                MoneyInputFormatter(), // Custom formatter
              ],
              style: const TextStyle(
                  color: cTextDisable,
                  fontSize: 28,
                  fontWeight: FontWeight.w900
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '0 VND',
                hintStyle: TextStyle(
                    color: cTextInputHint,
                    fontSize: 28,
                    fontWeight: FontWeight.w900
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            const Row(
              children: [
                Text("row2"),
              ],
            )
          ],
        )
    ),
  );
}


//from chatGPT
class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Only update if user input is numeric
    if (newValue.text.isEmpty || !RegExp(r'^\d+$').hasMatch(newValue.text)) {
      return oldValue;
    }

    // Add the "$" symbol at the end, without it being typed directly
    final String newText = "${newValue.text} VND";
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - 4),
    );
  }
}
