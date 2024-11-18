import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {

  late int walletCount = 0;
  final List<bool> isExpandedList = [];

  @override
  Widget build(BuildContext context) {
    walletCount = 3;
    setState(() {
      isExpandedList.addAll(List.generate(walletCount, (_) => false));
    });
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Quản lý ví", style: titleStyle(),)
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                "Tất cả ví ($walletCount)",
              style: TextStyle(fontSize: 16),
            ), //sau sẽ thêm bộ lọc
          ],
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: walletCount,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpandedList[index] = !isExpandedList[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.wallet, size: 60, color: cMediumPrimary,), //icon sẽ được custom = ảnh
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tên ví này Tên ví này Tên ví",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text("Mô tả ví này", style: TextStyle(fontSize: 14),)
                                  ],
                                ),
                              ],
                            ),
                            AnimatedRotation(
                              turns: isExpandedList[index] ? 0.75 : 0.5,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      child: Visibility(
                        visible: isExpandedList[index],
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Detail of Wallet $index",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
