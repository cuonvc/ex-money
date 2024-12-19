import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/base_description_field.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../category/category_all.dart';

class ExpenseDetail extends StatefulWidget {
  final ExpenseResponse? detail;
  const ExpenseDetail({super.key, required this.detail});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {

  late TextEditingController dateTimeController;
  late TextEditingController categoryIdController;
  late TextEditingController categoryNameController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late DateTime selectedDateTime;
  ExpenseResponse? response;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateTimeController = TextEditingController(text: "");
    categoryIdController = TextEditingController(text: "");
    categoryNameController = TextEditingController(text: "");
    amountController = TextEditingController();
    descriptionController = TextEditingController(text: "");
    selectedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    dateTimeController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    amountController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail as ExpenseResponse;

    response ??= detail;

    if (dateTimeController.text.isEmpty) {
      dateTimeController.text = dateTimeFormatedFromStr(detail.entryDate, true);
      selectedDateTime = dateTimeFromString(detail.entryDate);
    }

    if (amountController.text.isEmpty) {
      amountController.text = detail.amount.toString();
    }

    if (categoryIdController.text.isEmpty) {
      categoryIdController.text = detail.categoryId.toString();
    }

    if (categoryNameController.text.isEmpty) {
      categoryNameController.text = detail.categoryName;
    }

    if (descriptionController.text.isEmpty) {
      descriptionController.text = (detail.description ?? "");
    }


    return BlocListener<UpdateExpenseBloc, UpdateExpenseState>(
      listener: (context, state) {
        if (state is UpdateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is UpdateExpenseSuccess) {
          setState(() {
            response = state.response;
          });
          showDialogResponse(context, true, "Chỉnh sửa chi tiêu", state.message);
        } else if (state is UpdateExpenseFailure) {
          showDialogResponse(context, false, "Chỉnh sửa chi tiêu", state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: ModalRoute.of(context)!.canPop
              ? IconButton(onPressed: () => Navigator.pop(context, response), icon: const Icon(Icons.arrow_back_ios_new))
              : null,
          title: const Text(
            "Chi tiết chi chi tiêu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),

        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
        child: ListView(
          children: [
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thời gian", style: labelFormat(),),
                selectDateTime(detail)
              ],
            ),
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
                selectCategory(detail)
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Số tiền", style: labelFormat(),),
                selectAmount(detail)
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
                Row(
                  children: [
                    Text(descriptionController.text, style: !isEditing ? valueFormat() : labelFormat()),
                    const SizedBox(width: 6,),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Visibility(
              visible: isEditing,
              child: BaseDescriptionField(
                  controller: descriptionController,
                  hintText: detail.description,
                  minLine: 2,
                  maxLine: 4
              ),
            ),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                setState(() {
                  isEditing = !isEditing;
                  dateTimeController.clear();
                  categoryIdController.clear();
                  categoryNameController.clear();
                  amountController.clear();
                  descriptionController.clear();
                });
              },
              child: !isEditing ? buttonView(true, "Sửa", null) : buttonView(false, "Hủy", null),
            ),
            Visibility(
              visible: isEditing,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    // log("New entry date: ${getDateTimeToRequest(selectedDateTime.toString())}");
                    // log("New amount: ${amountController.text}");
                    // log("New category: ${categoryIdController.text}");
                    // log("New description: ${descriptionController.text}");
                    ExpenseUpdateRequest req = ExpenseUpdateRequest(
                        description: descriptionController.text,
                        amount: numberFromString(amountController.text),
                        entryDate: getDateTimeToRequest(selectedDateTime.toString()),
                        categoryId: numberFromString(categoryIdController.text)
                    );
                    context.read<UpdateExpenseBloc>().add(UpdateExpenseEv(id: detail.id, request: req));
                    // detail.entryDate = req.entryDate;
                    // detail.amount = req.amount;
                    // detail.description = req.description;
                    // detail.categoryId = req.categoryId;
                    // detail.categoryName = req.
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: buttonView(true, "Lưu", null),
                ),
              ),
            )
          ],
        ),
      ),
        bottomSheet: Visibility(
        visible: !isEditing,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen, vertical: 20),
          child: buttonView(false, "Xóa", Colors.red),
        ),
      ),
      ),
    );
  }

  Widget selectDateTime(ExpenseResponse detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.3,
          child: TextFormField(
            controller: dateTimeController,
            readOnly: true,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.end,
            style: !isEditing ? valueFormat() : editingFormat(null),
            decoration: InputDecoration(
                border: InputBorder.none
            ),
            onTap: () async {
              TimeOfDay? timeOfDay;
              DateTime? newDate = await showDatePicker(
                  context: context,
                  locale: const Locale("vi"),
                  initialDate: selectedDateTime,
                  firstDate: dateTimeFromString(detail.entryDate).add(Duration(days: -1)),
                  lastDate: dateTimeFromString(detail.entryDate).add(Duration(days: 365))
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
                  dateTimeController.text = dateTimeFormated(selectedDateTime, true);
                  // log("${DateTime.parse(selectedDateTime.toString())}");
                  // detail.entryDate = selectedDateTime;
                });
                // log("Trigger - ${showDateTimeSelected}");
              }
            },
          ),
        ),
        Visibility(
          visible: isEditing,
            child: Icon(Icons.keyboard_arrow_right)
        )
      ],
    );
  }

  Widget selectCategory(ExpenseResponse detail) {
    return GestureDetector(
      onTap: () async {
        ExpenseCategoryResponse? selected = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryAll(walletId: detail.walletId,))
        );
        if (selected != null) {
          setState (() {
            categoryIdController.text = selected.id.toString();
            categoryNameController.text = selected.name;
          });
        }
      },
      child: Row(
        children: [
          Text(categoryNameController.text, style: !isEditing ? valueFormat() : editingFormat(null)),
          const SizedBox(width: 6,),
          Visibility(
              visible: isEditing,
              child: const Icon(Icons.keyboard_arrow_right)
          )
        ],
      ),
    );
  }

  Widget selectAmount(ExpenseResponse detail) {
    return Row(
      children: [
        Visibility(
          visible: !isEditing,
          child: Text(amountController.text, style: valueFormat()),
        ),
        const SizedBox(width: 6,),
        Visibility(
          visible: isEditing,
          child: SizedBox(
            width: (MediaQuery.sizeOf(context).width - 2 * ConstantSize.hozPadScreen) * (2/3),
            height: 40,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: editingFormat(16),
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: cLineText, width: 1),
                    borderRadius: BorderRadius.circular(ConstantSize.borderButton)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: cLineText),
                    borderRadius: BorderRadius.circular(ConstantSize.borderButton)
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                hintText: detail.amount.toString(),
                hintStyle: const TextStyle(
                    color: cTextDisable,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
                // filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  TextStyle editingFormat(double? frontSize) {
    return TextStyle(
        color: cText,
        fontWeight: FontWeight.w500,
        fontSize: frontSize ?? 14
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
      color: cTextDisable,
      fontWeight: FontWeight.w400,
      fontSize: 14
    );
  }
}
