import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_wallet_detail/wallet_detail_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class HomeExpenseScreen extends StatefulWidget {
  const HomeExpenseScreen({super.key});

  @override
  State<HomeExpenseScreen> createState() => _HomeExpenseScreenState();
}

class _HomeExpenseScreenState extends State<HomeExpenseScreen> {

  bool isShowWalletList = false;
  GlobalKey comparePrevMonthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    void showBubbleComparePrevMonth(BuildContext context, num amount) {
      RenderBox box = comparePrevMonthKey.currentContext?.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      Size size = box.size;
      double parentHeight = size.height;
      String content = "";
      if (amount < 0) {
        amount = amount.abs();
        content = "Từ đầu tháng tới nay, bạn đang chi tiêu ít hơn $amount so với ngày này tháng trước";
      } else if (amount == 0) {
        content = "Từ đầu tháng tới nay, bạn đang chi tiêu bằng ngày này tháng trước";
      } else {
        content = "Từ đầu tháng tới nay, bạn đang chi tiêu nhiều hơn $amount so với ngày này tháng trước";
      }
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return Stack(
              children: [
                Positioned(
                  top: position.dy + parentHeight, // Add padding between icon and bubble
                  right: ConstantSize.hozPadScreen, // Center the bubble horizontally around the icon
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "So với ngày này tháng trước",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cTextDisable,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            content,
                            style: TextStyle(
                              fontSize: 12,
                              color: cTextDisable,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      );
    }

    return BlocProvider(
      create: (context) => WalletDetailBloc(WalletRepositoryImpl())..add(WalletDetailEv(null)), //get default the wallet
      child: BlocBuilder<WalletDetailBloc, WalletDetailState>(
        builder: (context, state) {
          if (state is WalletDetailFailure) {
            return const Center(child: Text("Loading detail failedd"),);
          } else {
            final List data = state.props;
            if(data.isNotEmpty) {
              WalletDetailResponse response = WalletDetailResponse.fromMap(data[0]);
              List<ExpenseResponse> expenseList = response.expenses;
              List<Map<dynamic, dynamic>> otherWalletMap = response.otherWalletMap;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đã chi tiêu",
                        style: TextStyle(
                          fontSize: 14,
                          color: cText,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Tháng này",
                            style: TextStyle(
                                fontSize: 14,
                                color: cTextDisable
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: cTextDisable,
                            size: 14,
                          )
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "3.500.000",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: cPrimary
                            ),
                          ),
                          Text(" VNĐ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cTextDisable),)
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showBubbleComparePrevMonth(context, -150000);
                        },
                        child: Container(
                          key: comparePrevMonthKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.arrow_upward_rounded, color: Colors.red, size: 12,),
                                  Text(
                                    " 3.000.000",
                                    style: TextStyle(fontSize: 12, color: Colors.red),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "So với tháng trước ",
                                    style: TextStyle(color: cTextDisable, fontSize: 12),
                                  ),
                                  Icon(Icons.info_outline, size: 12,)
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Tất cả giao dịch",
                            style: TextStyle(
                              fontSize: 14,
                              color: cTextDisable,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, size: 10, color: cTextDisable,)
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: expenseList.length,
                        itemBuilder: (ctx, int i) {
                          ExpenseResponse expense = expenseList[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, NavigatePath.expenseDetailPath, arguments: expense);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 12),
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expense.categoryName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: cText
                                            ),
                                          ),
                                          Text(
                                            expense.walletName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: cTextDisable
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${expense.amount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        dateTimeFormatedFromStr(expense.createdAt, false),
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
                ],
              );
            }
            return const Center();
          }
        },
      ),
    );
  }
}
