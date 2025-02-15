import 'dart:io';

import 'package:ex_money/utils/constant.dart';
import 'package:flutter/services.dart';

Future<String> getNavigationMode() async {

  if (Platform.isAndroid) {
    const platform = MethodChannel('navigation_mode');
    try {
      final String mode = await platform.invokeMethod('getNavigationMode');
      return mode; // "gesture" or "button"
    } on PlatformException catch (e) {
      return AndroidNavigationMode.gestureMode;
    }
  } else if (Platform.isIOS) {
    return AndroidNavigationMode.gestureMode;
  } else { //computer
    return AndroidNavigationMode.buttonMode;
  }
}