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
  final ExpenseResponse? newExpense; //just create new
  final Function(ExpenseResponse?) onExpenseUpdate;
  final VoidCallback resetNewExpense;
  final bool selectAllBtn;

  const ExpenseList(this.expenseList,
      this.selectAllBtn,
      this.expenseScrollController,
      this.newExpense,
      this.onExpenseUpdate,
      this.resetNewExpense,
      {super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {

  bool isContains() {
    if (widget.newExpense != null) {
      for (ExpenseResponse item in widget.expenseList) {
        if (item.id == widget.newExpense!.id) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  // @override
  // void didUpdateWidget(covariant ExpenseList oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   // Ensure resetNewExpense is called AFTER widget rebuilds
  //
  // }

  @override
  Widget build(BuildContext context) {

    List<ExpenseResponse> expenseList = widget.expenseList;
    // expenseList = rebuildExpenseList(expenseList, widget.newExpense);

    // chỉ update list khi tạo mới, còn xóa hay sửa thì gọi call back
    if (widget.newExpense != null && !isContains()) {
      expenseList = rebuildExpenseList(expenseList, widget.newExpense);
    }

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
                    widget.onExpenseUpdate(expUpdated);
                    // call back to the main screen để clear newExpense sau khi add (case thêm mới)
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.resetNewExpense();
                    });
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
