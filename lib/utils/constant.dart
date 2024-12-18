import 'package:flutter/material.dart';

const cPrimary = Color(0xFF636AE8);
const cMediumPrimary = Color(0xB2636AE8);
const cBlurPrimary = Color(0xFFF2F2FD);
const cText = Color(0xFF1D1B20);
const cTextDisable = Color(0xFF707070);
const cTextInputHint = Color(0xFFD3D3D3);
const cLineText = Color(0xFF9D9D9D);
const cTextMediumBlur = Color(0xFF6A6A6A);
const cGreyBackground = Color(0xFFFAFAFA);
const cBackground = Color(0xFFFFFFFF);
const cDisableBtn = Color(0xFF9D9D9D);

class ConstantSize {
  static const double hozPadScreen = 20;
  static const double buttonHeight = 44;
  static const double borderButton = 16;
}

class NavigatePath {
  static String signInPath = "/auth/sign_in";
  static String signUpPath = "/auth/sign_up";
  static String homePath = "/home";
  static String expenseAll = "/expense/all";
  static String expenseDetailPath = "/expense/detail";
  static String categoryListPath = "/category/list";
}

class WalletUserChange {
  static String wallet_user_change_add = "ADD";
  static String wallet_user_change_remove = "REMOVE";
}