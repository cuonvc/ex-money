import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/constant.dart';

//return data on change and on submit
class BaseTextFieldSubmit extends StatefulWidget {
  TextEditingController controller;
  TextInputType inputType;
  IconData? icon;
  String hintText;
  bool submitBtn;
  final fetchMethod;

  BaseTextFieldSubmit({
    super.key,
    required this.controller,
    required this.inputType,
    required this.icon,
    required this.hintText,
    required this.submitBtn,
    required this.fetchMethod
  });

  @override
  State<BaseTextFieldSubmit> createState() => _BaseTextFieldSubmitState();
}

class _BaseTextFieldSubmitState extends State<BaseTextFieldSubmit> {

  late bool isTyping;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isTyping = false;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = widget.controller;
    TextInputType inputType = widget.inputType;
    IconData? icon = widget.icon;
    String hintText = widget.hintText;
    bool submitBtn = widget.submitBtn;
    var fetchMethod = widget.fetchMethod;

    return TextFormField(
      controller: controller,
      onChanged: (String value) {
        setState(() {
          isTyping = value.isNotEmpty;
        });
        onChangeFetch(controller.text, fetchMethod, true);
      },

      keyboardType: inputType,
      cursorColor: Colors.black,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: cLineText, width: 1),
            borderRadius: BorderRadius.circular(ConstantSize.borderButton)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: cLineText),
            borderRadius: BorderRadius.circular(ConstantSize.borderButton)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        prefixIcon: icon != null ? Icon(
          icon,
          size: 26,
        ) : null,
        suffixIcon: isTyping && submitBtn ? GestureDetector(
          onTap: () => onChangeFetch(controller.text, fetchMethod, false),
          child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.arrow_forward_rounded, color: cPrimary,)
          ),
        ) : const Text(""),
        hintText: hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400
        ),
        // filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void onChangeFetch(String value, var fetchMethod, bool isDelay) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    int delayTime = isDelay ? 1000 : 0;
    _debounce = Timer(
        Duration(milliseconds: delayTime), () {
          fetchMethod(value);
        });
  }
}