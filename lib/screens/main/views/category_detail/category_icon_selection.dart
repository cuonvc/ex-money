import 'dart:developer';

import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryIconSelection extends StatefulWidget {
  final String icon;
  const CategoryIconSelection({super.key, required this.icon});

  @override
  State<CategoryIconSelection> createState() => _CategoryIconSelectionState();
}

class _CategoryIconSelectionState extends State<CategoryIconSelection> {

  String iconSelected = "";

  @override
  Widget build(BuildContext context) {
    if (iconSelected.isEmpty) {
      iconSelected = widget.icon;
    }

    double hightRoot = MediaQuery.sizeOf(context).height * (1/2);
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 2,
        height: hightRoot,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: hightRoot - 80,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: <Widget>[
                    for (var item in CategoryIcon.list)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            iconSelected = item;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: item.compareTo(iconSelected) == 0 ? cBlurPrimary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Image.asset("assets/images/category/$item.png", scale: 4.5,),
                        )
                      ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                log("Selected icon: $iconSelected");
                Navigator.pop(context, iconSelected);
              },
              child: buttonView(true, "Thay đổi", null),
            )
          ],
        ),
      ),
    );
  }
}
