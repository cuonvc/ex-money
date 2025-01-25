import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';

Widget buttonView(bool isPrimary, String text, Color? textColor) {
  return Container(
    height: ConstantSize.buttonHeight,
    decoration: BoxDecoration(
      color: isPrimary ? cPrimary : cBlurPrimary,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(ConstantSize.borderButton),
    ),
    child: Center(
      child: Text(
          text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isPrimary ? Colors.white : (textColor ?? cPrimary)
          )
      ),
    ),
  );
}

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//
//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: cPrimary, // Adjust this color to match the button
//         minimumSize: const Size(double.infinity, 43), // Full width and height
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(ConstantSize.borderButton), // Rounded corners
//         ),
//         elevation: 0, // Remove shadow
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//           color: Colors.white, // White text color
//         ),
//       ),
//     );
//   }
// }


Widget buttonLoading(bool isPrimary, Color? loadingColor) {
  return Container(
    height: ConstantSize.buttonHeight,
    decoration: BoxDecoration(
      color: isPrimary ? cPrimary : cBlurPrimary,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(ConstantSize.borderButton),
    ),
    child: Center(
      child: Loading(loadingColor: loadingColor,)
    ),
  );
}