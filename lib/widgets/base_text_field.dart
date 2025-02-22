import 'package:flutter/material.dart';

import '../utils/constant.dart';

class BaseTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final IconData? icon;
  final String? hintText;
  final bool passwordField;
  final bool isValidNumber;
  final double? numberValid;

  const BaseTextField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.icon,
    required this.hintText,
    required this.passwordField,
    required this.isValidNumber,
    required this.numberValid
  });

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      cursorColor: cLineText,
      obscureText: widget.passwordField ? passwordVisible : false,
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
        prefixIcon: widget.icon != null ? Icon(
          widget.icon,
          size: 26,
        ) : null,
        suffixIcon: widget.passwordField ?
        IconButton(
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
        ) : null,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400
        ),
        // filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        if (widget.isValidNumber && widget.numberValid != null) {
          double percent = double.tryParse(value) ?? 0;
          if (percent > widget.numberValid!) {
            widget.controller.text = widget.numberValid!.toInt().toString(); // Limit value to 100
            widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
          }
        }
      },
    );
  }
}