import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';

Widget buttonView(bool isPrimary, String text) {
  return Container(
    height: Size.buttonHeight,
    decoration: BoxDecoration(
      color: isPrimary ? cPrimary : Colors.white,
      border: Border.all(color: isPrimary ? Colors.white : cLineText),
      borderRadius: BorderRadius.circular(Size.borderButton),
    ),
    child: Center(
      child: Text(
          text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isPrimary ? Colors.white : cPrimary
          )
      ),
    ),
  );
}