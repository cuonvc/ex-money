import 'package:flutter/cupertino.dart';

class BaseBottomSheet extends StatefulWidget {
  const BaseBottomSheet({super.key});

  @override
  State<BaseBottomSheet> createState() => _BaseBottomSheetState();
}

class _BaseBottomSheetState extends State<BaseBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text("Base bottom sheet"),
        ],
      ),
    );
  }
}
