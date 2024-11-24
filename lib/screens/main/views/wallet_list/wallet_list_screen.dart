import 'dart:developer';

import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/base_bottom_sheet.dart';
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
  bool expenseTab = true;
  bool accountTab = false;
  bool informationTab = false;
  final accountExpandedList = [];

  @override
  Widget build(BuildContext context) {
    walletCount = 3;
    accountExpandedList.addAll(List.generate(2, (_) => false)); //get from account of wallet
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Quản lý ví", style: titleStyle(),)
        //   ],
        // ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "Tất cả ví ($walletCount)",
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => BaseBottomSheet(),
                  isScrollControlled: false
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.add, color: cPrimary,),
                  Text("Thêm ví mới", style: TextStyle(color: cPrimary),)
                ],
              ),
            )//sau sẽ thêm bộ lọc
          ],
        ),
        Expanded(
          child: PageView.builder(
            itemCount: walletCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              double fullWidth = MediaQuery.sizeOf(context).width;
              double fullHeight = MediaQuery.sizeOf(context).height;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: fullWidth,
                    height: fullHeight / 4,
                    decoration: BoxDecoration(
                        color: cBlurPrimary,
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Column(
                      children: [
                        Text("")
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: walletCount * 24,
                        height: 20,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: walletCount,
                          itemBuilder: (context1, index1) {
                            return walletCount < 2 ? const Text("") : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  index > index1 || index == walletCount - 1 ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                                  size: 24, color: index == index1 ? cPrimary : Colors.grey,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 20,),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = true;
                                  accountTab = false;
                                  informationTab = false;
                                });
                              },
                              child: tabTitle("Gần đây", expenseTab),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = false;
                                  accountTab = true;
                                  informationTab = false;
                                });
                              },
                              child: tabTitle("Tài khoản", accountTab),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = false;
                                  accountTab = false;
                                  informationTab = true;
                                });
                              },
                              child: tabTitle("Thông tin", informationTab)
                            ),
                          ],
                        ),
                        Visibility(
                          visible: expenseTab,
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: 15,
                              itemBuilder: (context2, index2) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, NavigatePath.expenseDetailPath, arguments: null);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                        color: cBlurPrimary,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.pets,
                                              color: Colors.amber,
                                              size: 30,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              "Hmmmm",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: cText
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${12000}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              dateTimeFormated(DateTime.now(), false),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: accountTab,
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context3, index3) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          accountExpandedList[index3] = !accountExpandedList[index3];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.account_circle_rounded),
                                          Text("Cuong Nguyen $index3"),
                                          AnimatedRotation(
                                            turns: accountExpandedList[index3] ? 0.75 : 0.5,
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
                                    AnimatedSize(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.linear,
                                        child: Visibility(
                                          visible: accountExpandedList[index3],
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 16),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Xóa khỏi ví"),
                                                Text("Chỉnh sửa quyền"),
                                                Text("Thông tin")
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ),
                        Visibility(
                          visible: informationTab,
                          child: Center(child: Text("Thong tin vi"),),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Text tabTitle(String title, isSelected) {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? cPrimary : cTextDisable
      ),
    );
  }
}