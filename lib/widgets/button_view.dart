import 'package:ex_money/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

Widget buttonView(bool isPrimary, String text) {
  return GestureDetector(
    onTap: () {

    },
    child: Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        color: isPrimary ? cPrimary : Colors.white,
        border: Border.all(color: isPrimary ? Colors.white : cLineText),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
    ),
  );
}