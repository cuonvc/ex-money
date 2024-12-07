import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:repository/repository.dart';

class ExpenseList extends StatelessWidget {
  final ScrollController expenseScrollController;
  final List<ExpenseResponse> expenseList;
  const ExpenseList(this.expenseList, this.expenseScrollController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
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
              controller: expenseScrollController,
              itemCount: expenseList.length,
              itemBuilder: (ctx, int i) {
                ExpenseResponse expense = expenseList[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NavigatePath.expenseDetailPath, arguments: expense);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            // offset: const Offset(0, 10), // changes position of shadow
                          ),
                        ]
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
}
