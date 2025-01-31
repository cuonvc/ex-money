import 'dart:developer';
import 'dart:ui';

import 'package:ex_money/screens/main/blocs/create_expense_scheduler/create_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_category/get_category_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense_scheduler/update_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/views/category/category_all.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/dialog_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:repository/repository.dart';

class ExpenseSchedulerEdit extends StatefulWidget {
  final WalletResponse wallet;
  final ExpenseSchedulerResponse? item;
  const ExpenseSchedulerEdit({super.key, required this.wallet, required this.item});

  @override
  State<ExpenseSchedulerEdit> createState() => _ExpenseSchedulerEditState();
}

class _ExpenseSchedulerEditState extends State<ExpenseSchedulerEdit> {

  bool isLoading = false;
  bool isShowIntervalList = false;
  bool isKeyboardVisible = false;

  late ExpenseCategoryResponse categorySelected;
  late ExpenseCreateRequest expenseRequest;
  late String selectedInterval;
  double rootHeight = 0;

  List<ExpenseCategoryResponse> categories = []; //dung de show popular cateogry

  TextEditingController amountController = TextEditingController();
  TextEditingController walletIdController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController intervalType = TextEditingController();
  int dateOrTimeVal = 1;


  @override
  void initState() {
    categorySelected = ExpenseCategoryResponse.empty();
    selectedInterval = ScheduleTimeIntervalType.monthly.value;
    intervalType.text = ScheduleTimeIntervalType.monthly.key;
    expenseRequest = ExpenseCreateRequest.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    rootHeight = MediaQuery.of(context).size.height / 1.8;
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return MultiBlocListener(
  listeners: [
    BlocListener<CreateExpenseSchedulerBloc, CreateExpenseSchedulerState>(
        listener: (context, state) {
          if(state is CreateExpenseSchedulerLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is CreateExpenseSchedulerFailure) {
            Navigator.pop(context, null);
            showDialogResponse(context, false, "Lên lịch chi tiêu", state.message);
          } else if (state is CreateExpenseSchedulerSuccess) {
            Navigator.pop(context, state.response);
          }
        },
    ),
    BlocListener<UpdateExpenseSchedulerBloc, UpdateExpenseSchedulerState>(
      listener: (context, state) {
        if(state is UpdateExpenseSchedulerLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is UpdateExpenseSchedulerFailure) {
          Navigator.pop(context, null);
          showDialogResponse(context, false, "Lên lịch chi tiêu", state.message);
        } else if (state is UpdateExpenseSchedulerSuccess) {
          Navigator.pop(context, state.response);
        }
      },
    ),
  ],
  child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
              ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.item == null ? "Chi tiêu định kỳ" : "Chỉnh sửa", style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: rootHeight,
                    minHeight: 100
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: rootHeight - (isKeyboardVisible ? 100 : 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            typeAmount(widget.item),
                            Row(
                              children: [
                                iconStyle(Icons.wallet),
                                const SizedBox(width: 10,),
                                Text(widget.wallet.name, style: hintStyle(),),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            selectCategory(walletIdController.text, widget.item),
                            const SizedBox(height: 10,),
                            noteInput(widget.item),
                            selectIntervalType(rootHeight),
                            selectDateTime(),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !isKeyboardVisible,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: TextButton(
                            child: !isLoading ? buttonView(true, "Lưu", null) : buttonLoading(false, null),
                            onPressed: () {
                              String rawAmount = amountController.text;
                              ExpenseCreateRequest? expense = widget.item == null ? ExpenseCreateRequest(
                                description: noteController.text,
                                amount: rawAmount.isNotEmpty
                                    ? num.parse(rawAmount.substring(0, rawAmount.length - 4))
                                    : 0,
                                entryType: ExpenseConstant.entry_type_expense, //tạm
                                entryDate: getDateTimeToRequest(DateTime.now().toString()),
                                type: ExpenseConstant.entry_type_schedule, //tạm
                                walletId: widget.wallet.id,
                                categoryId: numberFromString(categoryIdController.text),
                              ) : null;

                              ExpenseSchedulerRequest request = ExpenseSchedulerRequest(
                                expense: expense,
                                //tajm
                                timeInterval: intervalType.text,
                                timeValue: dateOrTimeVal
                              );

                              if (widget.item == null) {
                                if (amountController.text.isEmpty) {
                                  showDialogWarningSingle(context, "Thêm chi tiêu", "Bạn chưa nhập số tiền");
                                } else if (categoryIdController.text.isEmpty || categoryIdController.text.compareTo("0") == 0) {
                                  showDialogWarningSingle(context, "Thêm chi tiêu", "Bạn chưa chọn danh mục");
                                } else {
                                  context.read<CreateExpenseSchedulerBloc>().add(CreateExpenseSchedulerEv(request: request));
                                }
                              } else {
                                context.read<UpdateExpenseSchedulerBloc>().add(UpdateExpenseSchedulerEv(id: widget.item!.id, request: request));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
);
  }

  Widget typeAmount(ExpenseSchedulerResponse? oldData) {
    return TextField(
      readOnly: oldData != null,
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
      decoration: InputDecoration(
        hintText: oldData == null ? '0 VND' : '${oldData.data.amount} VND',
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

  Row selectCategory(String walletId, ExpenseSchedulerResponse? oldData) {
    num id = numberFromString(walletId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            iconStyle(Icons.format_list_bulleted),
            const SizedBox(width: 10,),
            categorySelected.id == 0
                ? Text(oldData == null ? "Danh mục" : oldData.data.categoryName, style: hintStyle(),)
                : Text(categorySelected.name, style: selectedStyle(),)
          ],
        ),
        const SizedBox(width: 8,),
        Visibility(
          visible: oldData == null,
          child: GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context, NavigatePath.categoryListPath, arguments: walletId);
              ExpenseCategoryResponse? selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => BlocProvider(
                          create: (context) => GetCategoryBloc(CategoryRepositoryImpl())..add(GetCategoryEv(walletId: numberFromString(walletId), isReload: false)),
                          child: CategoryAll(walletId: id,)
                      )
                  )
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
          ),
        )
      ],
    );
  }

  Widget noteInput(ExpenseSchedulerResponse? oldData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconStyle(Icons.sticky_note_2_outlined),
        const SizedBox(width: 10,),
        Expanded(
          child: TextField(
            controller: noteController,
            readOnly: oldData != null,
            style: hintStyle(),
            decoration: InputDecoration(
                hintText: oldData == null ? "Ghi chú" : (oldData.data.description == null || oldData.data.description!.isNotEmpty ? oldData.data.description : "Ghi chú"),
                hintStyle: hintStyle(),
                border: InputBorder.none,
                focusedBorder: InputBorder.none
            ),
          ),
        )
      ],
    );
  }

  Widget selectIntervalType(double oldRootHeight) {

    List<MapEntry<String, String>> typeList = ScheduleTimeIntervalType.interval_type_list;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconStyle(Icons.hourglass_bottom),
                const SizedBox(width: 10,),
                Text("Lặp lại", style: hintStyle(),),
              ],
            ),
            const SizedBox(width: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  isShowIntervalList = !isShowIntervalList;
                  dateOrTimeVal = 1;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(selectedInterval, style: selectedStyle(),),
                  AnimatedRotation(
                      turns: isShowIntervalList ? 0.75 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.grey,
                        size: 26,
                      )
                  )
                ],
              )
            )
          ],
        ),

        Visibility(
          visible: isShowIntervalList,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 2 * 30,
              width: MediaQuery.sizeOf(context).width,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                runSpacing: 6,
                children: List.generate(typeList.length, (idx) {
                  MapEntry<String, String> typeMap = typeList[idx];
                  String type = typeMap.key;
                  String name = typeMap.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isShowIntervalList = false;
                        intervalType.text = type;
                        selectedInterval = name;
                      });
                    },
                    child: Text(name, style: const TextStyle(color: cTextDisable, fontSize: 14),),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectDateTime() {
    int maxVal = 0;
    if (intervalType.text.compareTo(ScheduleTimeIntervalType.monthly.key) == 0) {
      maxVal = 31;
    } else if (intervalType.text.compareTo(ScheduleTimeIntervalType.weekly.key) == 0) {
      maxVal = 7;
    } else if (intervalType.text.compareTo(ScheduleTimeIntervalType.daily.key) == 0) {
      maxVal = 24;
    }

    // dateOrTimeVal = defaultVal;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NumberPicker(
        value: dateOrTimeVal,
        minValue: 1,
        maxValue: maxVal,
        itemHeight: 50,
        itemWidth: 80,
        axis: Axis.horizontal,
        infiniteLoop: true,
        onChanged: (value) => setState(() => dateOrTimeVal = value),
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
