import 'dart:developer';

import 'package:ex_money/screens/main/blocs/save_category/save_category_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../../widgets/dialog_warning.dart';

class CategoryDetail extends StatefulWidget {
  ExpenseCategoryResponse? category;
  CategoryDetail({
    super.key,
    required this.category
  });

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {

  ExpenseCategoryResponse? detail;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MapEntry<String, String> saveByWallet = CategorySaveType.category_save_type.entries.first;
  MapEntry<String, String> saveByAccount = CategorySaveType.category_save_type.entries.last;
  bool isLoading = false;

  bool isSaveTypeExpand = false;
  bool isWalletListExpand = false;
  String dropDownText = "Lưu theo"; //initial...

  String saveType = "";
  String? refId = "";

  @override
  Widget build(BuildContext context) {
    final category = widget.category as ExpenseCategoryResponse;

    detail ??= category;

    if (nameController.text.isEmpty) {
      nameController.text = detail!.name;
    }

    if (descriptionController.text.isEmpty) {
      descriptionController.text = detail!.description;
    }

    return BlocListener<SaveCategoryBloc, SaveCategoryState>(
      listener: (context, state) {
        if (state is SaveCategoryLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is SaveCategoryFailure) {
          setState(() {
            isLoading = false;
          });
          showDialogResponse(context, false, "Lưu danh mục", state.message);
        } else if (state is SaveCategorySuccess) {
          setState(() {
            isLoading = false;
            detail = state.response;
          });
          showDialogResponse(context, true, "Lưu danh mục", state.message);
        }
      },
      child: Scaffold(
        backgroundColor: cBackground,
        appBar: AppBar(
          backgroundColor: cBackground,
          title: const Text("Chi tiết danh mục", style: TextStyle(fontSize: 18),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/category/${widget.category?.iconImage ?? "other"}.png", scale: 4.5,),
                      const SizedBox(width: 10,),
                      const Text("Thay đổi icon", style: TextStyle(color: cPrimary),),
                      const SizedBox(width: 4,),
                      const Icon(Icons.edit, size: 16, color: cPrimary,)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSaveTypeExpand = !isSaveTypeExpand;
                      });
                    },
                    child: Row(
                      children: [
                        Text(dropDownText),
                        AnimatedRotation(
                            turns: isSaveTypeExpand ? 0.75 : 0.5,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.grey,
                              size: 26,
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
              //=================> expand of save type (WALLET - ACCOUNT)
              Visibility(
                visible: isSaveTypeExpand,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => {
                              setState(() {
                                dropDownText = saveByWallet.value;
                                saveType = saveByWallet.key;
                                refId = "";
                                isSaveTypeExpand = false;
                                isWalletListExpand = true;
                              })
                            },
                            child: Text(saveByWallet.value, style: baseStype())
                        ),
                        TextButton(
                            onPressed: () => {
                              setState(() {
                                dropDownText = saveByAccount.value;
                                saveType = saveByAccount.key;
                                refId = "";
                                isSaveTypeExpand = false;
                              })
                            },
                            child: Text(saveByAccount.value, style: baseStype())
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ===================> expand of wallet list
              Visibility(
                visible: isWalletListExpand && !isSaveTypeExpand && saveType.compareTo(saveByWallet.key) == 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => {
                              setState(() {
                                dropDownText = "Ví 1"; //đoạn này tên ví 1
                                refId = "wallet_id_1"; //đoạn này id ví 1
                                isWalletListExpand = false;
                              })
                            },
                            child: Text("Ví 1", style: baseStype())
                        ),
                        TextButton(
                            onPressed: () => {
                              setState(() {
                                dropDownText = "Ví 2"; //đoạn này tên ví 2
                                refId = "wallet_id_2"; //đoạn này id ví 2
                                isWalletListExpand = false;
                              })
                            },
                            child: Text("Ví 2", style: baseStype())
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text("Tên danh mục"),
                  const SizedBox(width: 4,),
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 2 * ConstantSize.hozPadScreen) * (2/3),
                    child: TextFormField(
                      controller: nameController,
                      onTapOutside: (PointerDownEvent event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      cursorColor: cLineText,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        hintText: "Nhập tên danh mục",
                        hintStyle: TextStyle(
                            color: cTextDisable,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                        // filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width - 2 * ConstantSize.hozPadScreen),
                child: TextFormField(
                  controller: descriptionController,
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  minLines: 3,
                  maxLines: 4,
                  cursorColor: cLineText,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: cLineText, width: 1),
                        borderRadius: BorderRadius.circular(ConstantSize.borderButton)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: cLineText),
                        borderRadius: BorderRadius.circular(ConstantSize.borderButton)
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: "Mô tả danh mục",
                    hintStyle: const TextStyle(
                        color: cTextDisable,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                    filled: true,
                    fillColor: cBackground,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  log("Name - ${nameController.text}");
                  log("Description - ${descriptionController.text}");
                  log("save type - ${saveType}");
                  log("ref id - ${refId}");
                  //save type = WALLET ->  phải check ví đã select chưa
                  if (saveType.compareTo(saveByWallet.key) == 0 && !refId!.isNotEmpty) {
                    showDialogWarningSingle(context, "Chưa chọn ví", "Bạn phải chọn tới một ví nếu lưu theo ví");
                  } else if (saveType.isEmpty) {
                    showDialogWarningSingle(context, "Lưu theo", "Lưu theo ví hoặc tài khoản?");
                  }
                  // ExpenseCategoryRequest req = ExpenseCategoryRequest(
                  //   name: nameController.text,
                  //   description: descriptionController.text,
                  //
                  // );
                  // context.read<SaveCategoryBloc>().add(SaveCategoryEv(id: detail.id, request: req));
                },
                child: buttonView(true, "Lưu", null),
              ),
              const SizedBox(height: 50,),
              GestureDetector(
                onTap: () async {
                  bool confirmed = await showDialogConfirm(context, "Xóa danh mục", "Bạn chắc chắn muốn xóa danh mục này?", null, "Xóa");
                  if (confirmed) {
                    //deleting
                  }
                },
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.trash, color: Colors.red, size: 18,),
                    SizedBox(width: 6,),
                    Text("Xóa danh mục này", style: TextStyle(color: Colors.red),)
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  TextStyle baseStype() {
    return TextStyle(
      fontSize: 14
    );
  }
}
