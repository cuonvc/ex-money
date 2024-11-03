import 'package:ex_money/screens/main/blocs/get_wallet_detail/wallet_detail_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class WalletDetail extends StatefulWidget {
  const WalletDetail({super.key});

  @override
  State<WalletDetail> createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletDetailBloc(WalletRepositoryImpl())..add(WalletDetailEv('2024101068fbfc4c1c2444d38c9c31874bdcf3cc52339')), //temp
      child: BlocBuilder<WalletDetailBloc, WalletDetailState>(
        builder: (context, state) {
          if (state is WalletDetailLoading) {
            return Center(child: CircularProgressIndicator(),);
          } else if (state is WalletDetailFailure) {
            return Center(child: Text("Loading detail failed"),);
          } else {
            final List data = state.props;
            if(data.isNotEmpty) {
              WalletDetailResponse response = WalletDetailResponse.fromMap(data[0]);
              List<ExpenseResponse> expenseList = response.expenses;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Số dư còn lại",
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

                  Text(
                    "${response.balance} VND",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900
                    ),
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 34,
                              color: Colors.green,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Hạn mức",
                                ),
                                Text(
                                    "${response.totalIncome}"
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.trending_down,
                              color: Colors.red,
                              size: 34,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Đã chi",
                                ),
                                Text(
                                    "${response.totalExpense}"
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${response.name}",
                            style: TextStyle(
                                fontSize: 14,
                                color: cTextDisable,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: cTextDisable,
                            size: 14,
                          )
                        ],
                      ),
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
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.pets,
                                        color: Colors.amber,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "${expense.name}",
                                        style: TextStyle(
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
                                        "${expense.amount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "${dateTimeFormatedFromStr(expense.createdAt)}",
                                        style: TextStyle(
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
            return Center();
          }
        },
      ),
    );
  }
}
