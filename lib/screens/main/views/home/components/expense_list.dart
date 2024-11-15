import 'dart:developer';

import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../blocs/get_expense/get_expense_bloc.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetExpenseBloc(ExpenseRepositoryImpl())..add(GetExpenseEv(null)), //default walletId is blank
      child: BlocBuilder<GetExpenseBloc, GetExpenseState>(
          builder: (context, state) {
            if (state is GetExpenseFailure) {
              return const Center(child: Text("Get Expense failed!"),);
            } else if (state is GetExpenseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              final List list = state.props;
              return Container(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, int i) {
                    ExpenseResponse expense = ExpenseResponse.fromMap(list[i]);
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
                                const Icon(
                                  Icons.pets,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                const SizedBox(width: 10,),
                                Text(
                                  "hmmm",
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
              );
            }
          }
      ),
    );
  }
}