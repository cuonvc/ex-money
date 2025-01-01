import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/constant.dart';

class Loading extends StatelessWidget {
  final Color? loadingColor;
  const Loading({super.key, required this.loadingColor});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(color: loadingColor != null ? loadingColor! : cPrimary, size: 40);
  }
}
