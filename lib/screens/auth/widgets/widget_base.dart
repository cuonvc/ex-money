import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';

Widget oAuthSelectionBtn(Color color, String text, double space, String imageName, double imageScale) {
  return Container(
    height: Size.buttonHeight,
    width: 160,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: cLineText),
      borderRadius: BorderRadius.circular(Size.borderButton),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/auth/$imageName.png', scale: imageScale,),
        SizedBox(width: space),
        Text(
          text,
        ),
      ],
    ),
  );
}