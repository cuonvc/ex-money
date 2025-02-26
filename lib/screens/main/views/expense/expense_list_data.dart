import 'package:ex_money/screens/main/blocs/get_expense/get_expense_bloc.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../../widgets/dialog_response.dart';

class ExpenseListData extends StatefulWidget {
  const ExpenseListData({super.key});

  @override
  State<ExpenseListData> createState() => _ExpenseListDataState();
}

class _ExpenseListDataState extends State<ExpenseListData> {

  bool isLoading = false;

  List<ExpenseResponse> expenseList = [];

  void onExpenseUpdate(ExpenseResponse? expense) {
    // setState(() {
    //   rebuildExpenseList(expenseList, expense);
    // });
  }

  void onResetNewExpense() {

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetExpenseBloc, GetExpenseState>(
        listener: (context, state) async {
          if (state is GetExpenseLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is GetExpenseSuccess) {
            setState(() {
              isLoading = false;
              expenseList = state.data;
            });
          } else if (state is GetExpenseFailure) {
            if (state.statusCode == 403) {
              await showDialogToRedirectLogin(context, state.message);
            } else {
              showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
            }
            setState(() {
              isLoading = false;
            });
          }
        },
      child: isLoading ? const Center(child: Loading(loadingColor: null,),)
          : ExpenseList(expenseList, false, ScrollController(), null, onExpenseUpdate, onResetNewExpense),
    );
  }
}
