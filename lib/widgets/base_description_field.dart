import 'package:flutter/material.dart';

import '../utils/constant.dart';

class BaseDescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? minLine;
  final int? maxLine;

  const BaseDescriptionField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.minLine,
    required this.maxLine
  });

  @override
  State<BaseDescriptionField> createState() => _BaseDescriptionFieldState();
}

class _BaseDescriptionFieldState extends State<BaseDescriptionField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      cursorColor: Colors.black,
      minLines: widget.minLine ?? 4,
      maxLines: widget.maxLine ?? 6,
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
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400
        ),
        // filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}