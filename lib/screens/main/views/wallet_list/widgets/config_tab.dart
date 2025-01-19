import 'package:ex_money/screens/main/blocs/wallet_change_expense_limit/wallet_change_expense_limit_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigTab extends StatefulWidget {
  num walletId;
  num? expenseLimit;
  ConfigTab({super.key, required this.walletId, required this.expenseLimit});

  @override
  State<ConfigTab> createState() => _ConfigTabState();
}

class _ConfigTabState extends State<ConfigTab> {
  
  final limitAmountController = TextEditingController();
  bool isLoading = false;
  // late num walletId;
  // num? expenseLimitAmt;

  @override
  void initState() {
    // walletId = widget.walletId;
    // expenseLimitAmt = widget.expenseLimit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletChangeExpenseLimitBloc, WalletChangeExpenseLimitState>(
  listener: (context, state) {
    if (state is WalletChangeExpenseLimitLoading) {
      isLoading = true;
    } else if (state is WalletChangeExpenseLimitFailure) {
      isLoading = false;
      Navigator.pop(context);
      showDialogResponse(context, false, "Thiết lập hạn mức", state.message);
    } else if (state is WalletChangeExpenseLimitSuccess) {
      isLoading = false;
      Navigator.pop(context);
      setState(() {
        widget.expenseLimit = state.amount;
      });
      showDialogResponse(context, true, "Thiết lập hạn mức", "Thiết lập thành công");
    }
  },
  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hạn mức", style: titleStyle(),),
            const SizedBox(width: 30,),
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)
                        ),
                        title: Text("Nhập hạn mức", style: titleStyle(),),
                        content: BaseTextField(
                            controller: limitAmountController, 
                            inputType: TextInputType.number, 
                            icon: null, 
                            hintText: widget.expenseLimit == null ? "Chưa thiết lập" : toAmountFormat(widget.expenseLimit),
                            passwordField: false
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.read<WalletChangeExpenseLimitBloc>().add(
                                  WalletChangeExpenseLimitEv(walletId: widget.walletId, amount: numberFromString(limitAmountController.text))
                                );
                              },
                              child: Text("Lưu")
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Hủy")
                          ),
                        ],
                      );
                    }
                );
              },
              child: Row(
                children: [
                  Text("Chỉnh sửa", style: TextStyle(color: cPrimary, fontSize: 13),),
                  Icon(Icons.edit_note, color: cPrimary, size: 16,)
                ],
              ),
            )
          ],
        ),
        Text(
          "Hạn mức cảnh báo hiện tại: "
              "${widget.expenseLimit == null ? "Chưa thiết lập" : "${toAmountFormat(widget.expenseLimit)} VNĐ"}",
          style: descriptionStyle(),
        )
      ],
    ),
);
  }

  TextStyle titleStyle() {
    return TextStyle(
      color: cText,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }

  TextStyle descriptionStyle() {
    return TextStyle(
      color: cTextDisable,
      fontWeight: FontWeight.w400,
      fontSize: 13
    );
  }
}
