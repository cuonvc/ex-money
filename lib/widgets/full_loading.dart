import 'dart:ui';

import 'package:flutter/material.dart';

void showBlurLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return Stack(
        children: [
          // Blur Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          const Center(child: CircularProgressIndicator(color: Colors.white,),)
        ],
      );
    },
  );
}