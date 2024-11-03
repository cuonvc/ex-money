import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:repository/repository.dart';

class ExpenseDetail extends StatefulWidget {
  const ExpenseDetail({super.key});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  @override
  Widget build(BuildContext context) {

    final detail = ModalRoute.of(context)?.settings.arguments as ExpenseResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: ModalRoute.of(context)!.canPop
            ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new))
            : null,
        title: const Text(
          "Chi tiết chi chi tiêu",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ngày tạo", style: labelFormat(),),
                Text(dateTimeFormatedFromStr(detail.createdAt), style: valueFormat()),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ví", style: labelFormat(),),
                Text(detail.walletName, style: valueFormat()),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh mục", style: labelFormat(),),
                Text(detail.categoryName, style: valueFormat()),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Số tiền", style: labelFormat(),),
                Text("${detail.amount}", style: valueFormat()),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phương thức", style: labelFormat(),),
                Text("${detail.type}", style: valueFormat()),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Chi chú", style: labelFormat(),),
                Text("${detail.description}", style: valueFormat()),
              ],
            ),
            const SizedBox(height: 50,),
            buttonView(true, "Sửa", null),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen, vertical: 20),
        child: buttonView(false, "Xóa", Colors.red),
      ),
    );
  }

  TextStyle labelFormat() {
    return TextStyle(
      color: cTextDisable,
      fontWeight: FontWeight.w500,
      fontSize: 14
    );
  }

  TextStyle valueFormat() {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 14
    );
  }
}
