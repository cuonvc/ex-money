import 'package:ex_money/screens/main/blocs/get_expense/get_expense_bloc.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class ExpenseListData extends StatelessWidget {
  const ExpenseListData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpenseBloc, GetExpenseState>(
        builder: (context, state) {
          if (state is GetExpenseLoading) {
            return const Center(child: Loading(),);
          } else if (state is GetExpenseSuccess) {
            List<ExpenseResponse> expenseList = state.data;
            return ExpenseList(expenseList, false, ScrollController());
          } else if (state is GetExpenseFailure) {
            return Center(child: Text(state.message),);
          } else {
            return const Center(child: Text("Ops..."),);
          }
        }
    );
  }
}
