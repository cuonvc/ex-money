import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/constant.dart';

class OTPCountdown extends StatefulWidget {
  final String rawMessage;
  final int initialMinutes;
  final int initialSeconds;

  const OTPCountdown({super.key, required this.rawMessage, required this.initialMinutes, required this.initialSeconds});

  @override
  _OTPCountdownState createState() => _OTPCountdownState();
}

class _OTPCountdownState extends State<OTPCountdown> {
  late int minutes;
  late int seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialMinutes;
    seconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes == 0 && seconds == 0) {
        timer.cancel(); // Stop the timer when reaching 0
      } else {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            minutes--;
            seconds = 59;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String value = "$minutes:$seconds";
    String disp = widget.rawMessage.replaceFirst("{1}", value);
    return Text(
      disp,
      style: const TextStyle(
          color: cTextDisable,
          fontSize: 14,
          fontWeight: FontWeight.w500
      ),
    );
  }
}