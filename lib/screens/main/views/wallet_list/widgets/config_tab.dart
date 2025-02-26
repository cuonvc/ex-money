import 'dart:convert';
import 'dart:developer';

import 'package:ex_money/screens/main/blocs/create_expense_scheduler/create_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense_scheduler/update_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/expense_scheduler_edit.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../blocs/delete_expense/delete_expense_bloc.dart';
import '../../../blocs/update_expense/update_expense_bloc.dart';
import '../../../blocs/wallet_setting/wallet_setting_bloc.dart';
import '../../expense_detail/expense_detail.dart';

class ConfigTab extends StatefulWidget {
  final ScrollController scrollController;
  WalletResponse wallet;
  ConfigTab(this.scrollController, this.wallet, {super.key});

  @override
  State<ConfigTab> createState() => _ConfigTabState();
}

class _ConfigTabState extends State<ConfigTab> {

  final limitAmountController = TextEditingController();
  final warningLevel1Controller = TextEditingController();
  final warningLevel2Controller = TextEditingController();
  final warningLevel3Controller = TextEditingController();
  bool isLoading = false;
  bool schedulerLoading = false;
  UserResponse currentUser = UserResponse.empty();
  // late num walletId;
  // num? expenseLimitAmt;

  @override
  void initState() {
    super.initState();
    initializeData();
    limitAmountController.text = toAmountFormat(widget.wallet.expenseLimit);
    warningLevel1Controller.text = toAmountFormat(widget.wallet.expenseWarningLevel1);
    warningLevel2Controller.text = toAmountFormat(widget.wallet.expenseWarningLevel2);
    warningLevel3Controller.text = toAmountFormat(widget.wallet.expenseWarningLevel3);
  }

  Future<void> initializeData() async {
    final user = await getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<UserResponse> getCurrentUser() async {
    final prefs= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
    );
    final partOfPrefKey = CachedPrefKey.signInRespPref;
    try {
      final Object? dataCached = prefs.get(partOfPrefKey);
      List<dynamic> fromDisk = jsonDecode(dataCached.toString());
      return UserResponse.fromMap(fromDisk[2]);
    } catch (e) {
      Navigator.pushNamed(context, NavigatePath.authSelectionPath);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletSettingBloc, WalletSettingState>(
      listener: (context, state) async {
        if (state is WalletSettingLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is WalletSettingFailure) {
          if (state.statusCode == 403) {
            await showDialogToRedirectLogin(context, state.message);
          } else {
            showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
          }
          setState(() {
            isLoading = false;
          });
        } else if (state is WalletSettingSuccess) {
          setState(() {
            isLoading = false;
            widget.wallet = state.response;
          });
          showDialogResponse(context, true, "Thiết lập ví", "Đã cập nhật");
        }
      },
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hạn mức", style: titleStyle(),),
                    const SizedBox(width: 30,),
                    Visibility(
                      visible: currentUser.id == widget.wallet.ownerUserId,
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  title: Center(child: Text("Thiết lập hạn mức", style: titleStyle(),)),
                                  content: SizedBox(
                                    height: MediaQuery.sizeOf(context).height * 0.4,
                                    width: MediaQuery.sizeOf(context).width + 0.2,
                                    child: ListView(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Hạn mức tối đa (VNĐ)", style: TextStyle(color: cTextDisable),),
                                            BaseTextField(
                                                controller: limitAmountController,
                                                inputType: TextInputType.number,
                                                icon: null,
                                                hintText: '',
                                                // hintText: widget.wallet.expenseLimit == null ? "Chưa thiết lập" : toAmountFormat(widget.wallet.expenseLimit),
                                                passwordField: false,
                                                isValidNumber: false,
                                                numberValid: null,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Mức cảnh báo 1 (%)", style: TextStyle(color: cTextDisable),),
                                            BaseTextField(
                                                controller: warningLevel1Controller,
                                                inputType: TextInputType.number,
                                                icon: null,
                                                hintText: '',
                                                // hintText: widget.wallet.expenseWarningLevel1 == null ? "Chưa thiết lập" : toAmountFormat(widget.wallet.expenseWarningLevel1),
                                                passwordField: false,
                                                isValidNumber: true,
                                                numberValid: 100,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Mức cảnh báo 2 (%)", style: TextStyle(color: cTextDisable),),
                                            BaseTextField(
                                                controller: warningLevel2Controller,
                                                inputType: TextInputType.number,
                                                icon: null,
                                                hintText: '',
                                                // hintText: widget.wallet.expenseWarningLevel2 == null ? "Chưa thiết lập" : toAmountFormat(widget.wallet.expenseWarningLevel2),
                                                passwordField: false,
                                                isValidNumber: true,
                                                numberValid: 100,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Mức cảnh báo 3 (%)", style: TextStyle(color: cTextDisable),),
                                            BaseTextField(
                                                controller: warningLevel3Controller,
                                                inputType: TextInputType.number,
                                                icon: null,
                                                hintText: '',
                                                // hintText: widget.wallet.expenseWarningLevel3 == null ? "Chưa thiết lập" : toAmountFormat(widget.wallet.expenseWarningLevel3),
                                                passwordField: false,
                                                isValidNumber: true,
                                                numberValid: 100,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Hủy")
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          widget.wallet.expenseLimit = fromAmountFormatted(limitAmountController.text);
                                          widget.wallet.expenseWarningLevel1 = fromAmountFormatted(warningLevel1Controller.text);
                                          widget.wallet.expenseWarningLevel2 = fromAmountFormatted(warningLevel2Controller.text);
                                          widget.wallet.expenseWarningLevel3 = fromAmountFormatted(warningLevel3Controller.text);
                                          WalletSettingRequest request = WalletSettingRequest(
                                            totalExpenseLimit: widget.wallet.expenseLimit,
                                            expenseWarningLevel1: widget.wallet.expenseWarningLevel1,
                                            expenseWarningLevel2: widget.wallet.expenseWarningLevel2,
                                            expenseWarningLevel3: widget.wallet.expenseWarningLevel3,
                                          );
                                          context.read<WalletSettingBloc>().add(
                                              WalletSettingEv(walletId: widget.wallet.id, request: request)
                                          );
                                        },
                                        child: const Text("Lưu")
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: const Row(
                          children: [
                            Text("Chỉnh sửa", style: TextStyle(color: cPrimary, fontSize: 13),),
                            SizedBox(width: 4,),
                            Icon(Icons.edit_note, color: cPrimary, size: 16,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Hạn mức tối đa: "
                      "${widget.wallet.expenseLimit == null ? "Chưa thiết lập" : "${toAmountFormat(widget.wallet.expenseLimit)} VNĐ"}",
                  style: descriptionStyle(),
                ),
                Text(
                  "Mức cảnh báo: ${"${widget.wallet.expenseWarningLevel1 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel1)}%' : ''} - ${widget.wallet.expenseWarningLevel2 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel2)}%' : ''} - ${widget.wallet.expenseWarningLevel3 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel3)}%' : ''}".compareTo(' -  - ') != 0 && widget.wallet.expenseLimit != null ? "${widget.wallet.expenseWarningLevel1 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel1)}%' : ''} - ${widget.wallet.expenseWarningLevel2 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel2)}%' : ''} - ${widget.wallet.expenseWarningLevel3 != null ? '${toAmountFormat(widget.wallet.expenseWarningLevel3)}%' : ''}" : "Chưa thiết lập"}",
                  style: descriptionStyle(),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chi tiêu định kỳ", style: titleStyle(),),
                      GestureDetector(
                        onTap: () async {
                          ExpenseSchedulerResponse? response = await showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return  MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (ctx) => CreateExpenseSchedulerBloc(TaskRepositoryImpl()),
                                    ),
                                    BlocProvider(
                                      create: (context) => UpdateExpenseSchedulerBloc(TaskRepositoryImpl()),
                                    ),
                                  ],
                                  child: ExpenseSchedulerEdit(wallet: widget.wallet, item: null,),
                                );
                              }
                          );

                          setState(() {
                            if (response != null) {
                              widget.wallet.schedulers.insert(0, response);
                            }
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: cPrimary, size: 20,),
                            Text("Thêm mới", style: TextStyle(color: cPrimary, fontSize: 12),)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      controller: widget.scrollController,
                      itemCount: widget.wallet.schedulers.length + 1,
                      itemBuilder: (ctx, idx) {
                        if (idx >= widget.wallet.schedulers.length) {
                          return Container(
                            height: ConstantSize.heightBottomBar + 50,
                            color: Colors.transparent,
                          );
                        }
                        ExpenseSchedulerResponse item = widget.wallet.schedulers[idx];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTimeIntervalDesc(MapEntry(item.timeInterval, item.timeValue)),
                              style: descriptionStyle(),
                            ),
                            GestureDetector(
                              child: ExpenseItem(expense: item.data),
                              onTap: () async {
                                ExpenseResponse? expUpdated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext ctx) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (ctx) => UpdateExpenseBloc(ExpenseRepositoryImpl()),
                                          ),
                                          BlocProvider(
                                            create: (context) => DeleteExpenseBloc(ExpenseRepositoryImpl()),
                                          ),
                                        ],
                                        child: ExpenseDetail(detail: item.data,),
                                      )
                                  ),
                                );

                                if (expUpdated != null) {
                                  setState(() {
                                    if (expUpdated.isDelete) {
                                      setState(() {
                                        widget.wallet.schedulers.removeWhere((element) => element.data.id == expUpdated.id);
                                      });
                                    } else {
                                      item.data = expUpdated;
                                    }
                                  });
                                }
                              },
                              onLongPress: () async {
                                ExpenseSchedulerResponse? response = await showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return  MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (ctx) => CreateExpenseSchedulerBloc(TaskRepositoryImpl()),
                                          ),
                                          BlocProvider(
                                            create: (context) => UpdateExpenseSchedulerBloc(TaskRepositoryImpl()),
                                          ),
                                        ],
                                        child: ExpenseSchedulerEdit(wallet: widget.wallet, item: item,),
                                      );
                                    }
                                );

                                if (response != null) {
                                  setState(() {
                                    for (int index = 0; index < widget.wallet.schedulers.length; index++) {
                                      if (widget.wallet.schedulers[index].id == response.id) {
                                        widget.wallet.schedulers[index] = response;
                                      }
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 80,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle titleStyle() {
    return const TextStyle(
      color: cText,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }


  TextStyle descriptionStyle() {
    return const TextStyle(
      color: cTextDisable,
      fontWeight: FontWeight.w400,
      fontSize: 13
    );
  }
}
