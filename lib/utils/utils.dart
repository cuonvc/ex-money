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

String getDateTimeToRequest(String dateTime) {
  return dateTime.substring(0, 19);
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