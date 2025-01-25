import 'package:flutter/material.dart';

import '../utils/constant.dart';

class Loading extends StatelessWidget {
  final Color? loadingColor;
  const Loading({super.key, required this.loadingColor});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: cBlurPrimary, backgroundColor: cPrimary,);
  }
}
