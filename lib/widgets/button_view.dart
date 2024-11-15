import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';

Widget buttonView(bool isPrimary, String text, Color? textColor) {
  return Container(
    height: ConstantSize.buttonHeight,
    decoration: BoxDecoration(
      color: isPrimary ? cPrimary : cBlurPrimary,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(ConstantSize.borderButton),
    ),
    child: Center(
      child: Text(
          text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isPrimary ? Colors.white : (textColor ?? cPrimary)
          )
      ),
    ),
  );
}

Widget buttonLoading(bool isPrimary, Color? loadingColor) {
  return Container(
    height: ConstantSize.buttonHeight,
    decoration: BoxDecoration(
      color: isPrimary ? cPrimary : cBlurPrimary,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(ConstantSize.borderButton),
    ),
    child: Center(
      child: CircularProgressIndicator(
        color: loadingColor,
      )
    ),
  );
}