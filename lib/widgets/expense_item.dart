import 'dart:math';

import 'package:ex_money/screens/main/blocs/delete_expense/delete_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:ex_money/screens/main/views/expense_detail/expense_detail.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../utils/constant.dart';

class ExpenseItem extends StatefulWidget {
  ExpenseResponse? expense;
  ExpenseItem({super.key, required this.expense});

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {

  ExpenseResponse item = ExpenseResponse.empty();

  @override
  Widget build(BuildContext context) {

    if (widget.expense == null) {
    } else {
      item = widget.expense!;
    }

    return Container(
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
              Image.asset("assets/images/category/${item.categoryIconImage}.png", scale: 4.5,),
              const SizedBox(width: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.categoryName,
                    style: const TextStyle(
                        fontSize: 14,
                        color: cText
                    ),
                  ),
                  Text(
                    item.walletName,
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
                "${toAmountFormat(item.amount)} đ",
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                dateTimeFormatedFromStr(item.entryDate, false),
                style: const TextStyle(
                    fontWeight: FontWeight.w300
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
