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
  static const double heightBottomBar = 70;
}

class NavigatePath {
  static String authSelectionPath = "/auth/selection";
  static String signInPath = "/auth/sign_in";
  static String signUpPath = "/auth/sign_up";
  static String homePath = "/home";
  static String settingPath = "/setting";
  static String passwordChangePath = "/passwordChange";
  static String expenseAll = "/expense/all";
  static String expenseDetailPath = "/expense/detail";
  static String categoryListPath = "/category/list";
  static String categoryDetailPath = "category/detail";
}

class WalletUserChange {
  static String wallet_user_change_add = "ADD";
  static String wallet_user_change_remove = "REMOVE";
}

class CategorySaveType {
  static Map<String, String> category_save_type = {
    "WALLET": "Ví",
    "ACCOUNT": "Tài khoản"
  };
}

class ScheduleTimeIntervalType {
  static MapEntry<String, String> monthly = const MapEntry("MONTHLY", "Hằng tháng");
  static MapEntry<String, String> weekly = const MapEntry("WEEKLY", "Hằng tuần");
  static MapEntry<String, String> daily = const MapEntry("DAILY", "Hằng ngày");
  // static MapEntry<String, String> per_hour = const MapEntry("PER_HOUR", "Mỗi giờ");
  // static MapEntry<String, String> per_minute = const MapEntry("PER_MINUTE", "Mỗi phút");

  static List<MapEntry<String, String>> interval_type_list = [monthly, weekly, daily];
}

class CategoryIcon {
  static List<String> list = [
  "health",
  "health_pharmacy",
  "health_insurance",
  "health_doctor",
  "gym",
  "shopping",
  "shopping_accessories",
  "shopping_shoes",
  "shopping_clothing",
  "investment",
  "sport",
  "pets",
  "entertainment",
  "children",
  "children_babysitting",
  "children_tuition",
  "children_toy",
  "children_pocketmoney",
  "children_milk",
  "living",
  "living_xecongnghe",
  "living_servicefix",
  "living_internet",
  "living_home",
  "living_electricity",
  "living_fuel",
  "living_gas",
  "living_water",
  "living_taxi",
  "living_phone",
  "margin",
  "food",
  "food_restaurant",
  "food_cart",
  "food_dinner",
  "food_lunch",
  "food_breakfast",
  "food_coffee",
  "personal",
  "personal_relax",
  "personal_hobbies",
  "personal_onlineservice",
  "personal_education",
  "gift",
  "other",
  "customize_1",
  "customize_2",
  "customize_3",
  "customize_4",
  "customize_5",
  "customize_6",
  "customize_7",
  "customize_8",
  "customize_9",
  "customize_10",
  "customize_11",
  "customize_12",
  "customize_13",
  "customize_14",
  "customize_15",
  "customize_16",
  "customize_17",
  "customize_18",
  "customize_19",
  "customize_20",
  "customize_21",
  "customize_22",
  "customize_23",
  "customize_24",
  "customize_25",
  ];
}