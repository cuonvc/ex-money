import 'package:ex_money/screens/main/blocs/delete_expense/delete_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:ex_money/screens/main/views/expense_detail/expense_detail.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class ExpenseList extends StatefulWidget {
  final ScrollController expenseScrollController;
  final List<ExpenseResponse> expenseList;
  final ExpenseResponse? newExpense;
  final bool selectAllBtn;

  const ExpenseList(this.expenseList,
      this.selectAllBtn,
      this.expenseScrollController,
      this.newExpense,
      {super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {

  List<ExpenseResponse> rebuildExpenseList(List<ExpenseResponse> currentList, ExpenseResponse? newData) {
    bool updated = false;
    if (newData == null) {
      return currentList;
    } else if (newData.isDelete) {
      currentList.removeWhere((item) => item.id == newData.id);
    }
    for (int i = 0; i < currentList.length; i++) {
      if (currentList[i].id == newData.id) {
        currentList[i] = newData;
        updated = true;
        break;
      }
    }
    if (!updated) {
      currentList.add(newData);
    }
    return currentList;
  }

  @override
  Widget build(BuildContext context) {

    List<ExpenseResponse> expenseList = widget.expenseList;
    rebuildExpenseList(expenseList, widget.newExpense);

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
            child: expenseList.isEmpty ? const Center(child: Text("Không có chi tiêu nào..."),) : ListView.builder(
              controller: widget.expenseScrollController,
              itemCount: expenseList.length + 1,
              itemBuilder: (ctx, int i) {
                if (i >= expenseList.length) {
                  return Container(
                    height: ConstantSize.heightBottomBar + 50,
                    color: Colors.transparent,
                  );
                }
                ExpenseResponse expense = expenseList[i];
                return GestureDetector(
                  onTap: () async {
                    ExpenseResponse? expUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (ctx) => UpdateExpenseBloc(ExpenseRepositoryImpl()),
                              ),
                              BlocProvider(
                                create: (context) => DeleteExpenseBloc(ExpenseRepositoryImpl()),
                              ),
                            ],
                            child: ExpenseDetail(detail: expense,),
                          )
                      ),
                    );

                    rebuildExpenseList(expenseList, expUpdated);
                  },
                  child: ExpenseItem(expense: expense)
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
