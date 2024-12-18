import 'dart:developer';
import 'dart:ui';

import 'package:ex_money/screens/main/blocs/add_expense/add_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/screens/main/views/category/category_all.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../utils/constant.dart';

class ExpenseEdit extends StatefulWidget {
  const ExpenseEdit({super.key});

  @override
  State<ExpenseEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {

  bool isLoading = false;

  bool isShowWalletList = false;
  late ExpenseCategoryResponse categorySelected;
  late ExpenseCreateRequest expenseRequest;
  late DateTime selectedDateTime;

  TextEditingController amountController = TextEditingController();
  TextEditingController walletIdController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateTimeText = TextEditingController();


  @override
  void initState() {
    selectedDateTime = DateTime.now();
    dateTimeText.text = dateTimeFormated(selectedDateTime, true);
    categorySelected = ExpenseCategoryResponse.empty();
    expenseRequest = ExpenseCreateRequest.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
      listener: (context, state) {
        if(state is AddExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AddExpenseFailure) {
          Navigator.pop(context, null);
          showDialogResponse(context, false, "Thêm chi tiêu", state.message);
        } else if (state is AddExpenseSuccess) {
          // if (state.expense != null) {
          //
          // }
          Navigator.pop(context, state.expense);
        }
      },
      child: AlertDialog(
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
              final screenHeight = MediaQuery.of(context).size.height;
              return SizedBox(
                height: screenHeight / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        child: BlocBuilder<GetExpenseEditResourceBloc, GetExpenseEditResourceState>(
                          builder: (context, state) {
                            if (state is GetExpenseEditResourceLoading) {
                              return Loading();
                            } else if (state is GetExpenseEditResourceFailure) {
                              // showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
                              return Center(child: Text("Ops!\n${state.message}"),);
                            } else if (state is GetExpenseEditResourceSuccess) {
                              ExpenseEditResource resource = state.resource;
                              num walletId = resource.walletId;
                              String walletName = resource.walletName;
                              walletIdController.text = walletId.toString();
                              var categories = ExpenseCategoryResponse.fromList(resource.categories); //dung de show popular cateogry
                              List<Map<dynamic, dynamic>> otherWalletMap = resource.otherWalletMap;
                              return Column(
                                children: [
                                  typeAmount(),
                                  selectWallet(walletName, otherWalletMap),
                                  const SizedBox(height: 20,),
                                  selectCategory(walletId),
                                  const SizedBox(height: 10,),
                                  noteInput(),
                                  // const SizedBox(height: 10,), //??
                                  selectDateTime(),
                                  const SizedBox(height: 10,),
                                ],
                              );
                            } else {
                              // showDialogResponse(context, false, "Có lỗi xảy ra", "Ops!");
                              return const Center(child: Text("Ops!\nCó lỗi xảy ra"),);
                            }
                          },
                        )
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        child: !isLoading ? buttonView(true, "Lưu", null) : buttonLoading(false, null),
                        onPressed: () {
                          String rawAmount = amountController.text;
                          ExpenseCreateRequest request = ExpenseCreateRequest(
                            description: noteController.text,
                            amount: rawAmount.isNotEmpty
                                ? num.parse(rawAmount.substring(0, rawAmount.length - 4))
                                : 0,
                            entryType: ExpenseConstant.entry_type_expense, //tạm
                            entryDate: getDateTimeToRequest(selectedDateTime.toString()),
                            type: ExpenseConstant.type_manual, //tạm
                            walletId: numberFromString(walletIdController.text),
                            categoryId: numberFromString(categoryIdController.text),

                          );
                          context.read<AddExpenseBloc>().add(AddExpenseEv(request));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  TextField typeAmount() {
    return TextField(
      controller: amountController,
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
    );
  }

  Column selectWallet(String walletName, List<Map<dynamic, dynamic>> otherWalletMap) {
    return Column(
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
                          Text(walletName, style: selectedStyle(),),
                          iconStyle(isShowWalletList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                        ],
                      )
                  )
                ],
              ),
            ),
            Visibility(
              child: Text("Mặc định", style: hintStyle(),),
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
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isShowWalletList = false;
                    });
                    context.read<GetExpenseEditResourceBloc>().add(GetExpenseEditResourceEv(numberFromString(walletMap.keys.first)));
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
    );
  }

  Row selectCategory(num walletId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            iconStyle(Icons.format_list_bulleted),
            const SizedBox(width: 10,),
            categorySelected.id == 0
                ? Text("Danh mục", style: hintStyle(),)
                : Text(categorySelected.name, style: selectedStyle(),)
          ],
        ),
        const SizedBox(width: 8,),
        GestureDetector(
          onTap: () async {
            // Navigator.pushNamed(context, NavigatePath.categoryListPath, arguments: walletId);
            ExpenseCategoryResponse? selected = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryAll(walletId: walletId,))
            );
            if (selected != null) {
              setState (() {
                categorySelected = selected;
                categoryIdController.text = selected.id.toString();
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Tất cả", style: hintStyle(),),
              iconStyle(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ],
    );
  }

  Row noteInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconStyle(Icons.sticky_note_2_outlined),
        const SizedBox(width: 10,),
        Expanded(
          child: TextField(
            controller: noteController,
            style: hintStyle(),
            decoration: InputDecoration(
                hintText: "Ghi chú",
                hintStyle: hintStyle(),
                border: InputBorder.none,
                focusedBorder: InputBorder.none
            ),
          ),
        )
      ],
    );
  }

  Widget selectDateTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconStyle(Icons.access_time_rounded),
        Expanded(
          child: TextFormField(
            controller: dateTimeText,
            readOnly: true,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: "Time",
                // filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none
                )
            ),
            onTap: () async {
              TimeOfDay? timeOfDay;
              DateTime? newDate = await showDatePicker(
                  context: context,
                  locale: const Locale("vi"),
                  initialDate: selectedDateTime,
                  firstDate: DateTime.now().add(Duration(days: -1)),
                  lastDate: DateTime.now().add(Duration(days: 365))
              );

              if(newDate != null) {
                timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: newDate.hour, minute: newDate.minute)
                );
              }

              if(newDate != null && timeOfDay != null) {
                setState(() {
                  selectedDateTime = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                    timeOfDay!.hour,
                    timeOfDay.minute
                  );
                  dateTimeText.text = dateTimeFormated(selectedDateTime, true);
                });
              }
            },
          )
        )
      ],
    );
  }

  Widget iconStyle(IconData icon) {
    return Icon(
      icon,
      size: 20,
      color: cTextDisable,
    );
  }

  TextStyle hintStyle() {
    return const TextStyle(
      fontSize: 16,
      color: cTextDisable,
    );
  }

  TextStyle selectedStyle() {
    return const TextStyle(
      fontSize: 16,
      color: cText,
    );
  }
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
