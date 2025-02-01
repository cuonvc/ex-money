import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {

    int length = 7;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        spacing: ConstantSize.hozPadScreen / 2,
        runSpacing: ConstantSize.hozPadScreen / 2,
        children: List.generate(length + 2, (index) { //nhớ + 2 cho vị trí cuối cho nó nhô lên
          return (index == length + 1 || index == length + 2)
              ? SizedBox(width: MediaQuery.sizeOf(context).width, height: 150,)
              : Container(
                width: MediaQuery.sizeOf(context).width / 2 - ConstantSize.hozPadScreen - ConstantSize.hozPadScreen / 4 - 6,
                height: 200, //tạm
                padding: const EdgeInsets.all(8),
                margin: (index == 0 || index == 1) ? const EdgeInsets.only(top: 3) : (index % 2 == 0 ? const EdgeInsets.only(left: 3) : const EdgeInsets.only(right: 3)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        // offset: const Offset(0, 10), // changes position of shadow
                      ),
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Đây là tiêu đề ghi chú có xuống dòng Đây là tiêu đề ghi chú có xuống dòng",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: cText
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                            "Đây là nội dung phần đầu ghi chú Đây là nội dung phần đầu ghi chú Đây là nội dung phần đầu ghi chú Đây là nội dung phần đầu ghi chú Đây là nội dung phần đầu ghi chú Đây là nội dung phần đầu ghi chú",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: cText
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      "${dateTimeFormated(DateTime.now(), false)}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: cTextDisable
                      ),
                    )
                  ],
                ),
          );
        }),
      ),
    );
  }
}
