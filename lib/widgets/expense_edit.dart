import 'dart:developer';
import 'dart:ui';

import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/screens/main/views/category/category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../utils/constant.dart';

Widget expenseEdit(BuildContext context) {
  bool isShowWalletList = false;
  ExpenseCategoryResponse categorySelected = ExpenseCategoryResponse.isEmpty();
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thêm chi tiêu", style: TextStyle(fontSize: 18),),
          ],
        ),
      ],
    ),
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 2,
            child: BlocBuilder<GetExpenseEditResourceBloc, GetExpenseEditResourceState>(
              builder: (context, state) {
                if (state.props.isNotEmpty) {
                  List data = state.props;
                  ExpenseEditResource resource = ExpenseEditResource.fromMap(data[0]);
                  String walletId = resource.walletId;
                  String walletName = resource.walletName;
                  var categories = ExpenseCategoryResponse.fromList(resource.categories);
                  List<Map<dynamic, dynamic>> otherWalletMap = resource.otherWalletMap;
                  return Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Only allow digits
                          LengthLimitingTextInputFormatter(11),
                          MoneyInputFormatter(), // Custom formatter
                        ],
                        style: const TextStyle(
                            color: cTextDisable,
                            fontSize: 28,
                            fontWeight: FontWeight.w900
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: '0 VND',
                          hintStyle: TextStyle(
                              color: cTextInputHint,
                              fontSize: 28,
                              fontWeight: FontWeight.w900
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    iconStyle(Icons.wallet),
                                    const SizedBox(width: 10,),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isShowWalletList = !isShowWalletList;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(walletName, style: textStyle(),),
                                          iconStyle(isShowWalletList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                child: Text("Mặc định", style: textStyle(),),
                                visible: false,
                              )
                            ],
                          ),
                          Visibility(
                            visible: isShowWalletList,
                            child: SizedBox(
                              height: otherWalletMap.length * 30,
                              width: MediaQuery.sizeOf(context).width,
                              child: ListView.builder(
                                itemCount: otherWalletMap.length,
                                itemBuilder: (context, index) {
                                  Map<dynamic, dynamic> walletMap = otherWalletMap[index];
                                  String name = walletMap.values.first;
                                  String id = walletMap.keys.first;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isShowWalletList = false;
                                      });
                                      context.read<GetExpenseEditResourceBloc>().add(GetExpenseEditResourceEv(id));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                      child: Text(name, style: const TextStyle(color: cTextDisable, fontSize: 14),),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              iconStyle(Icons.format_list_bulleted),
                              const SizedBox(width: 10,),
                              Text("Danh mục", style: textStyle(),)
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Navigator.pushNamed(context, NavigatePath.categoryListPath, arguments: walletId);
                              ExpenseCategoryResponse selected = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategoryList(walletId: walletId,))
                              );
                              setState (() {
                                categorySelected = selected;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Tất cả", style: textStyle(),),
                                iconStyle(Icons.keyboard_arrow_right)
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6,),
                      Visibility(
                        visible: categorySelected.id.isEmpty ? false : true,
                        child: Column(
                          children: [
                            Text("Test đã chọn"),
                            Text("id: ${categorySelected.id}"),
                            Text("name: ${categorySelected.name}")
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          iconStyle(Icons.sticky_note_2_outlined),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: TextField(
                              style: textStyle(),
                              decoration: InputDecoration(
                                  hintText: "Ghi chú",
                                  hintStyle: textStyle(),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none
                              ),
                            ),
                          )
                        ],
                      ),
                      // const SizedBox(height: 10,), //??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          iconStyle(Icons.access_time_rounded),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: TextField(
                              style: textStyle(),
                              decoration: InputDecoration(
                                  hintText: "Thời gian",
                                  hintStyle: textStyle(),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return Center();
                }
              },
            )
        );
      }
    ),
  );
}

Widget iconStyle(IconData icon) {
  return Icon(
    icon,
    size: 20,
    color: cTextDisable,
  );
}

TextStyle textStyle() {
  return const TextStyle(
    fontSize: 16,
    color: cTextDisable,
  );
}


//from chatGPT
class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    // Only update if user input is numeric
    if (newValue.text.isEmpty || !RegExp(r'^\d+$').hasMatch(newValue.text)) {
      return oldValue;
    }

    // Add the "$" symbol at the end, without it being typed directly
    final String newText = "${newValue.text} VND";
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - 4),
    );
  }
}
