import 'package:intl/intl.dart';

String dateTimeFormated(DateTime dateTime) {
  DateTime now = DateTime.now();
  late String formated = "";
  if (now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day) {
    formated = 'Hôm nay - ${DateFormat('HH:mm').format(dateTime)}';
  } else {
    formated = DateFormat('dd/MM/yyyy').format(dateTime);
  }

  return formated;
}

String dateTimeFormatedFromStr(String dateTime) {
  DateTime input = DateTime.parse(dateTime);
  DateTime now = DateTime.now();
  late String formated = "";
  if (now.year == input.year && now.month == input.month && now.day == input.day) {
    formated = 'Hôm nay - ${DateFormat('HH:mm').format(input)}';
  } else {
    formated = DateFormat('dd/MM/yyyy').format(input);
  }

  return formated;
}

String getAmountFormated(int amount) {
  var formatter = NumberFormat.decimalPattern('vi_VN');
  return formatter.format(amount);
}