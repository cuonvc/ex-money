import 'dart:developer';

import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field_submit.dart';
import 'package:flutter/material.dart';

class ExpenseAll extends StatefulWidget {
  const ExpenseAll({super.key});

  @override
  State<ExpenseAll> createState() => _ExpenseAllState();
}

class _ExpenseAllState extends State<ExpenseAll> {

  TextEditingController searchTxtController = TextEditingController();

  late bool filterByExpenseVisible;
  late bool filterByCategoryVisible;
  late bool filterByWalletVisible;

  @override
  void initState() {
    filterByExpenseVisible = false;
    filterByCategoryVisible = false;
    filterByWalletVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: ModalRoute.of(context)!.canPop
            ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new))
            : null,
        title: const Text(
          "Tất cả chi tiêu",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
        child: Column(
          children: [
            BaseTextFieldSubmit(
              controller: searchTxtController,
              inputType: TextInputType.text,
              icon: Icons.search,
              hintText: "Nhập danh mục, mô tả hoặc số tiền",
              submitBtn: true,
              fetchMethod: fetchSearch,
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      filterByExpenseVisible = !filterByExpenseVisible;
                      filterByCategoryVisible = false;
                      filterByWalletVisible = false;
                    })
                  },
                  child: Row(
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 8,),
                      Text("Tất cả chi tiêu"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      filterByCategoryVisible = !filterByCategoryVisible;
                      filterByExpenseVisible = false;
                      filterByWalletVisible = false;
                    })
                  },
                  child: Row(
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 8,),
                      Text("Danh mục"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      filterByWalletVisible = !filterByWalletVisible;
                      filterByExpenseVisible = false;
                      filterByCategoryVisible = false;
                    })
    },
                  child: Row(
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 8,),
                      Text("Ví cá nhân"),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: filterByExpenseVisible,
              child: Text("Expense"),
            ),
            Visibility(
              visible: filterByCategoryVisible,
              child: Text("Category"),
            ),
            Visibility(
              visible: filterByWalletVisible,
              child: Text("Wallet"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchSearch(String keyword) async {
    log("Keyword searching -> $keyword");
    //get thêm những element từ class này để call API
  }
}
