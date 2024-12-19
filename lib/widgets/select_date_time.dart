import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/material.dart';

class SelectDateTime extends StatefulWidget {
  TextEditingController dateTimeController;
  DateTime initDateTime;

  SelectDateTime({
    super.key,
    required this.dateTimeController,
    required this.initDateTime
  });

  @override
  State<SelectDateTime> createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        iconStyle(Icons.access_time_rounded),
        Expanded(
            child: TextFormField(
              controller: widget.dateTimeController,
              readOnly: true,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: "Chọn thời gian",
                  // filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none
                  )
              ),
              onTap: () async {
                TimeOfDay? timeOfDay;
                DateTime? newDate = await showDatePicker(
                    context: context,
                    locale: const Locale("vi"),
                    initialDate: widget.initDateTime,
                    firstDate: DateTime.now().add(Duration(days: -1)),
                    lastDate: DateTime.now().add(Duration(days: 365))
                );

                if(newDate != null) {
                  timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: newDate.hour, minute: newDate.minute)
                  );
                }

                if(newDate != null && timeOfDay != null) {
                  setState(() {
                    widget.initDateTime = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        timeOfDay!.hour,
                        timeOfDay.minute
                    );
                    widget.dateTimeController.text = dateTimeFormated(widget.initDateTime, true);
                  });
                }
              },
            )
        )
      ],
    );
  }
}

Widget iconStyle(IconData icon) {
  return Icon(
    icon,
    size: 20,
    color: cTextDisable,
  );
}

TextStyle hintStyle() {
  return const TextStyle(
    fontSize: 16,
    color: cTextDisable,
  );
}

TextStyle selectedStyle() {
  return const TextStyle(
    fontSize: 16,
    color: cText,
  );
}