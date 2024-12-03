import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constant.dart';

TextFormField baseInputTextField(TextEditingController controller, TextInputType inputType, IconData? icon, String hintText) {
  return TextFormField(
    controller: controller,
    keyboardType: inputType,
    cursorColor: Colors.black,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: cLineText, width: 1),
            borderRadius: BorderRadius.circular(ConstantSize.borderButton)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: cLineText),
            borderRadius: BorderRadius.circular(ConstantSize.borderButton)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        prefixIcon: icon != null ? Icon(
          icon,
          size: 26,
        ) : null,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400
        ),
        // filled: true,
        fillColor: Colors.white,
    ),
  );
}