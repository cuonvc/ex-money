import 'dart:convert';
import 'dart:developer';

import 'package:ex_money/screens/main/blocs/delete_category/delete_category_bloc.dart';
import 'package:ex_money/screens/main/blocs/save_category/save_category_bloc.dart';
import 'package:ex_money/screens/main/views/category_detail/category_icon_selection.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/dialog_warning.dart';

class CategoryDetail extends StatefulWidget {
  bool isCreateMode; //tạo mới thì cũng mở màn này
  ExpenseCategoryResponse? category;
  CategoryDetail({
    super.key,
    required this.isCreateMode,
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
  String iconImage = "";

  List<WalletResponse> walletList = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final list = await getWalletList();
    setState(() {
      walletList = list;
    });
  }

  Future<List<WalletResponse>> getWalletList() async {
    final prefs= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
    );
    final partOfPrefKey = CachedPrefKey.walletListPref;
    try {
      final Object? listCached = prefs.get(partOfPrefKey);
      List fromDisk = jsonDecode(listCached.toString());
      List<WalletResponse> dataFromDisk = fromDisk.map((w) => WalletResponse.fromMap(w)).toList();
      return dataFromDisk;
    } catch (e) {
      Navigator.pushNamed(context, NavigatePath.authSelectionPath);
      rethrow;
    }
  }

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

    if (iconImage.isEmpty) {
      iconImage = category.iconImage ?? "other";
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<SaveCategoryBloc, SaveCategoryState>(
          listener: (context, state) async {
            if (state is SaveCategoryLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is SaveCategoryFailure) {
              setState(() {
                isLoading = false;
              });
              await showDialogResponse(context, false, "Lưu danh mục", state.message);
              Navigator.pop(context, ""); // "" != null
            } else if (state is SaveCategorySuccess) {
              setState(() {
                isLoading = false;
                detail = state.response;
              });
              await showDialogResponse(context, true, "Lưu danh mục", state.message);
              Navigator.pop(context, ""); // "" != null
            }
          },
        ),
        BlocListener<DeleteCategoryBloc, DeleteCategoryState>(
          listener: (context, state) async {
            if (state is DeleteCategoryLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is DeleteCategoryFailure) {
              setState(() {
                isLoading = false;
              });
              await showDialogResponse(context, false, "Xóa danh mục", state.message);
              Navigator.pop(context, ""); // "" != null
            } else if (state is DeleteCategorySuccess) {
              setState(() {
                isLoading = false;
              });
              await showDialogResponse(context, true, "Xóa danh mục", state.message);
              Navigator.pop(context, ""); // "" != null
            }
          },
        ),
      ],
      child: Scaffold(
          backgroundColor: cBackground,
          appBar: AppBar(
            backgroundColor: cBackground,
            title: Text(widget.isCreateMode ? "Thêm mới danh mục" : "Chi tiết danh mục",
              style: const TextStyle(fontSize: 18),
            ),
            centerTitle: true,
            leading: ModalRoute.of(context)!.canPop
                ? IconButton(onPressed: () => Navigator.pop(context, null), icon: const Icon(Icons.arrow_back_ios_new))
                : null,
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
                    GestureDetector(
                      onTap: () async {
                        String iconSelected = await showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return CategoryIconSelection(icon: iconImage,);
                            }
                        );
                        setState(() {
                          iconImage = iconSelected;
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/images/category/$iconImage.png", scale: 4.5,),
                          const SizedBox(width: 10,),
                          const Text("Thay đổi icon", style: TextStyle(color: cPrimary),),
                          const SizedBox(width: 4,),
                          const Icon(Icons.edit, size: 16, color: cPrimary,)
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.isCreateMode,
                      child: GestureDetector(
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
                const SizedBox(height: 10,),
                Visibility(
                  visible: isWalletListExpand && !isSaveTypeExpand && saveType.compareTo(saveByWallet.key) == 0,
                  child: SizedBox(
                    height: walletList.length * 28,
                    width: MediaQuery.sizeOf(context).width - ConstantSize.hozPadScreen * 2,
                    child: ListView.builder(
                      itemCount: walletList.length,
                      itemBuilder: (ctx, idx) {
                        WalletResponse wallet = walletList[idx];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () => {
                                  setState(() {
                                    dropDownText = wallet.name; //đoạn này tên ví 1
                                    refId = wallet.id.toString(); //đoạn này id ví 1
                                    isWalletListExpand = false;
                                  })
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(wallet.name, style: baseStype(),
                                ))
                            ),
                          ],
                        );
                      },
                    ),
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
                        readOnly: !widget.isCreateMode && detail?.type.compareTo("DEFAULT") == 0,
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
                Row(
                  children: [
                    const Text("Danh mục cha:"),
                    const SizedBox(width: 10,),
                    const Text("Đang update ...")
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
                    readOnly: !widget.isCreateMode && detail?.type.compareTo("DEFAULT") == 0,
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
                Visibility(
                  visible: detail?.type.compareTo("CUSTOM") == 0 || widget.isCreateMode,
                  child: GestureDetector(
                    onTap: () {
                      log("Icon selected - $iconImage");
                      log("Name - ${nameController.text}");
                      log("Description - ${descriptionController.text}");
                      log("save type - $saveType");
                      log("ref id - $refId");
                      //save type = WALLET ->  phải check ví đã select chưa
                      if (widget.isCreateMode) {
                        if (saveType.compareTo(saveByWallet.key) == 0 && !refId!.isNotEmpty) {
                          showDialogWarningSingle(context, "Chưa chọn ví", "Bạn phải chọn tới một ví nếu lưu theo ví");
                        } else if (saveType.isEmpty) {
                          showDialogWarningSingle(context, "Lưu theo", "Lưu theo ví hoặc tài khoản?");
                        }
                      }
                      ExpenseCategoryRequest req = ExpenseCategoryRequest(
                        iconImage: iconImage,
                        name: nameController.text,
                        description: descriptionController.text,
                        saveType: saveType.isNotEmpty ? saveType : detail?.saveType,
                        refId: refId == null ? null : numberFromString(refId!),
                        parentId: null
                      );
                      context.read<SaveCategoryBloc>().add(SaveCategoryEv(id: widget.isCreateMode ? null : detail?.id, request: req));
                    },
                    child: isLoading ? buttonLoading(true, null) : buttonView(true, "Lưu", null),
                  ),
                ),
                Visibility(
                  visible: detail?.type.compareTo("DEFAULT") == 0,
                  child: Row(
                    children: [
                      Text("Không thể cập nhật danh mục mặc định", style: TextStyle(fontSize: 12),),
                      SizedBox(width: 6,),
                      Icon(CupertinoIcons.info_circle_fill, color: cDisableBtn, size: 18,),
                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                Visibility(
                  visible: detail?.type.compareTo("CUSTOM") == 0,
                  child: GestureDetector(
                    onTap: () async {
                      bool confirmed = await showDialogConfirm(context, "Xóa danh mục", "Bạn chắc chắn muốn xóa danh mục này?", null, "Xóa");
                      if (confirmed) {
                        context.read<DeleteCategoryBloc>().add(DeleteCategoryEv(id: detail!.id));
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.trash, color: Colors.red, size: 18,),
                        SizedBox(width: 6,),
                        Text("Xóa danh mục này", style: TextStyle(color: Colors.red),)
                      ],
                    ),
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
