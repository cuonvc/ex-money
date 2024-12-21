import 'dart:developer';

import 'package:intl/intl.dart';

String dateTimeFormated(DateTime dateTime, bool getTime) {
  DateTime now = DateTime.now();
  late String formated = "";
  if (now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day) {
    formated = 'Hôm nay - ${DateFormat('HH:mm').format(dateTime)}';
  } else {
    formated = getTime
        ? DateFormat('dd/MM/yyyy - HH:mm').format(dateTime)
        : DateFormat('dd/MM/yyyy').format(dateTime);
  }

  return formated;
}

String dateTimeFormatedFromStr(String dateTime, bool getTime) {
  DateTime input = DateTime.parse(dateTime);
  return dateTimeFormated(input, getTime);
}

DateTime dateTimeFromString(String dateTime) {
  return DateTime.parse(dateTime);
}

String getDateTimeToRequest(String dateTime) {
  return dateTime.substring(0, 19);
}

String getCurrentMonth(int month) {
  return DateTime.now().month == month ? "Này" : month.toString();
}

String getAmountFormated(int amount) {
  var formatter = NumberFormat.decimalPattern('vi_VN');
  return formatter.format(amount);
}

num numberFromString(String input) {
  try {
    return num.parse(input);
  } catch (e) {
    return 0;
  }
}

String toAmountVNFormat(num amount) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: "VNĐ"
  ).format(amount);
}

String toAmountFormat(dynamic amount) {
  if (amount is num) {
    return NumberFormat.currency(
        locale: 'vi_VN',
        symbol: ''
    ).format(amount).trim();
  } else if (amount is String) {
    return NumberFormat.currency(
        locale: 'vi_VN',
        symbol: ''
    ).format(num.parse(amount.replaceAll('.', '').replaceAll(',', '').trim())).trim();
  } else {
    log("=============> Error toAmountFormat");
    return "";
  }
}

num fromAmountFormatted(String value) {
  value = value.replaceAll('VNĐ', '')
      .replaceAll('.', '')
      .replaceAll(',', '')
      .trim();
  return numberFromString(value);
}