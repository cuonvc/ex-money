import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:ex_money/screens/main/views/expense_detail/expense_detail.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class ExpenseList extends StatefulWidget {
  final ScrollController expenseScrollController;
  final List<ExpenseResponse> expenseList;
  final bool selectAllBtn;

  const ExpenseList(this.expenseList,
      this.selectAllBtn,
      this.expenseScrollController,
      {super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {

    List<ExpenseResponse> expenseList = widget.expenseList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.selectAllBtn ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NavigatePath.expenseAll);
              },
              child: const Row(
                children: [
                  Text(
                    "Tất cả giao dịch",
                    style: TextStyle(
                      fontSize: 14,
                      color: cTextDisable,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_outlined, size: 10,
                    color: cTextDisable,)
                ],
              ),
            )
          ],
        ) : const SizedBox(height: 0,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              controller: widget.expenseScrollController,
              itemCount: expenseList.length,
              itemBuilder: (ctx, int i) {
                ExpenseResponse expense = expenseList[i];
                return GestureDetector(
                  onTap: () async {
                    ExpenseResponse expUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => BlocProvider(
                            create: (ctx) => UpdateExpenseBloc(ExpenseRepositoryImpl()),
                            child: ExpenseDetail(detail: expense,),
                          )
                      ),
                    );
                    setState(() {
                      expenseList[i] = expUpdated;
                    });
                    // Navigator.pushNamed(ctx, NavigatePath.expenseDetailPath, arguments: expense);
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
                              dateTimeFormatedFromStr(expense.entryDate, false),
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
