import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_expense/get_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_filter_resource/get_expense_filter_resource_bloc.dart';
import 'package:ex_money/screens/main/views/expense/expense_list_data.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field_submit.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../../utils/utils.dart';

class ExpenseAll extends StatefulWidget {
  const ExpenseAll({super.key});

  @override
  State<ExpenseAll> createState() => _ExpenseAllState();
}

class _ExpenseAllState extends State<ExpenseAll> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetExpenseFilterResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseFilterResourceEv(walletId: null, isReload: false, isCache: false)),
        ),
        BlocProvider(
          create: (context) => GetExpenseBloc(ExpenseRepositoryImpl())..add(
              GetExpenseEv(
                  walletId: null,
                  keyword: null,
                  categoryId: null,
                  createdById: null,
                  startDate: null,
                  endDate: null
              )
          ),
        ),
      ], child: const ExpenseAllView(),
    );
  }
}

class ExpenseAllView extends StatefulWidget {
  const ExpenseAllView({super.key});

  @override
  State<ExpenseAllView> createState() => _ExpenseAllViewState();
}

class _ExpenseAllViewState extends State<ExpenseAllView> {

  TextEditingController searchTxtController = TextEditingController();
  num? walletSelected;
  num? memberSelected;
  num? categorySelected;
  String? startDate;
  String? endDate;

  late bool searchSelected;
  late bool filterByMemberVisible;
  late bool filterByCategoryVisible;
  late bool filterByWalletVisible;

  late String walletDisplay;
  late String authorDisplay;
  late String categoryDisplay;

  @override
  void initState() {
    searchSelected = false;
    filterByMemberVisible = false;
    filterByCategoryVisible = false;
    filterByWalletVisible = false;

    walletDisplay = "";
    authorDisplay = "";
    categoryDisplay = "";
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
          "Tất cả giao dịch",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<GetExpenseFilterResourceBloc, GetExpenseFilterResourceState>(
        builder: (context, state) {
          if (state is GetExpenseFilterResourceLoading) {
            return const Center(child: Loading(loadingColor: null,),);
          } else if (state is GetExpenseFilterResourceSuccess) {
            ExpenseFilterResource resource = state.resource;
            walletSelected = resource.walletId;
            String walletDisplay = resource.walletName;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: searchSelected,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width - 2 * ConstantSize.hozPadScreen,
                          child: BaseTextFieldSubmit(
                            controller: searchTxtController,
                            inputType: TextInputType.text,
                            icon: Icons.search,
                            hintText: "Nhập danh mục, mô tả hoặc số tiền",
                            submitBtn: true,
                            fetchMethod: fetchSearch,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !searchSelected,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Icon(Icons.search),
                              onTap: () {
                                setState(() {
                                  searchSelected = true;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTimeRange? picked = await showDateRangePicker(
                                  context: context,
                                  locale: const Locale("vi"),
                                  initialDateRange: (startDate == null || endDate == null)
                                      ? null
                                      : DateTimeRange(start: dateTimeFromString(startDate!), end: dateTimeFromString(endDate!)),
                                  firstDate: DateTime(DateTime.now().year - 5),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDate = getDateTimeToRequest(picked.start.toString());
                                    endDate = getDateTimeToRequest(picked.end.toString());
                                  });
                                  fetchSearch("");
                                }
                              },
                              child: Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: searchSelected,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Hủy", style: TextStyle(color: cTextDisable, fontWeight: FontWeight.w500),),
                          ),
                          onTap: () {
                            setState(() {
                              searchSelected = false;
                              searchTxtController.clear();
                              fetchSearch;
                            });
                          },
                        ),
                        const SizedBox(width: 10,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            filterByWalletVisible = !filterByWalletVisible;
                            filterByMemberVisible = false;
                            filterByCategoryVisible = false;
                          })
                        },
                        child: Row(
                          children: [
                            Text(walletDisplay),
                            const SizedBox(width: 2,),
                            AnimatedRotation(
                              turns: filterByWalletVisible ? 0.75 : 0.5,
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
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            filterByMemberVisible = !filterByMemberVisible;
                            filterByCategoryVisible = false;
                            filterByWalletVisible = false;
                          })
                        },
                        child: Row(
                          children: [
                            Text(authorDisplay.isEmpty ? "Chi tiêu của bạn" : authorDisplay),
                            AnimatedRotation(
                              turns: filterByMemberVisible ? 0.75 : 0.5,
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
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            filterByCategoryVisible = !filterByCategoryVisible;
                            filterByMemberVisible = false;
                            filterByWalletVisible = false;
                          })
                        },
                        child: Row(
                          children: [
                            Text(categoryDisplay.isEmpty ? "Danh mục" : categoryDisplay),
                            AnimatedRotation(
                              turns: filterByCategoryVisible ? 0.75 : 0.5,
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
                    ],
                  ),
                  selectWallet(resource.otherWalletMap),
                  selectMember(resource.members),
                  selectCategory(resource.categories),
                  SizedBox(height: 20,),
                  Expanded(child: ExpenseListData())
                ],
              ),
            );
          } else if (state is GetExpenseFilterResourceFailure) {
            return Center(child: Text("Failed: ${state.message}"),);
          } else {
            return Center(child: Text("Error not define"),);
          }
        },
      ),
    );
  }

  Visibility selectWallet(List<Map<dynamic, dynamic>> listWalletMap) {
    return Visibility(
        visible: filterByWalletVisible,
        child: SizedBox(
          height: listWalletMap.length * 30,
          child: ListView.builder(
            itemCount: listWalletMap.length,
            itemBuilder: (ctx, idx) {
              Map<dynamic, dynamic> walletMap = listWalletMap[idx];
              String name = walletMap.values.first;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    filterByWalletVisible = false;
                    walletSelected = numberFromString(walletMap.keys.first);

                    memberSelected = null;
                    categorySelected = null;

                    authorDisplay = "";
                    categoryDisplay = "";
                  });
                  context.read<GetExpenseFilterResourceBloc>().add(GetExpenseFilterResourceEv(walletId: numberFromString(walletMap.keys.first), isReload: true, isCache: false));
                  context.read<GetExpenseBloc>().add(
                      GetExpenseEv(
                          walletId: walletSelected,
                          keyword: searchTxtController.text,
                          categoryId: categorySelected,
                          createdById: memberSelected,
                          startDate: startDate,
                          endDate: endDate
                      )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Text(name, style: const TextStyle(color: cTextDisable, fontSize: 14),),
                ),
              );
            },
          ),
        )
    );
  }

  Visibility selectMember(List<Map<dynamic, dynamic>> listMemberMap) {
    return Visibility(
        visible: filterByMemberVisible,
        child: SizedBox(
          height: listMemberMap.length * 30,
          child: ListView.builder(
            itemCount: listMemberMap.length,
            itemBuilder: (ctx, idx) {
              Map<dynamic, dynamic> memberMap = listMemberMap[idx];
              String name = memberMap.values.first;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    filterByMemberVisible = false;
                    memberSelected = numberFromString(memberMap.keys.first);
                    authorDisplay = memberMap.values.first;
                  });
                  context.read<GetExpenseBloc>().add(
                      GetExpenseEv(
                        walletId: walletSelected,
                        keyword: searchTxtController.text,
                        categoryId: categorySelected,
                        createdById: memberSelected,
                        startDate: startDate,
                        endDate: endDate
                      )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Text(name, style: const TextStyle(color: cTextDisable, fontSize: 14),),
                ),
              );
            },
          ),
        )
    );
  }

  Visibility selectCategory(List<Map<dynamic, dynamic>> listCategoryMap) {
    return Visibility(
        visible: filterByCategoryVisible,
        child: SizedBox(
          height: listCategoryMap.length * 30,
          child: ListView.builder(
            itemCount: listCategoryMap.length,
            itemBuilder: (ctx, idx) {
              Map<dynamic, dynamic> categoryMap = listCategoryMap[idx];
              String name = categoryMap.values.first;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    filterByCategoryVisible = false;
                    categorySelected = numberFromString(categoryMap.keys.first);
                    categoryDisplay = categoryMap.values.first;
                  });
                  context.read<GetExpenseBloc>().add(
                      GetExpenseEv(
                        walletId: walletSelected,
                        keyword: searchTxtController.text,
                        categoryId: categorySelected,
                        createdById: memberSelected,
                        startDate: startDate,
                        endDate: endDate
                      )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Text(name, style: const TextStyle(color: cTextDisable, fontSize: 14),),
                ),
              );
            },
          ),
        )
    );
  }

  Future<void> fetchSearch(String keyword) async {
    log("Keyword searching -> $keyword");
    log("Wallet: $walletSelected");
    log("Created by: $memberSelected");
    log("Category: $categorySelected");
    log("start date: $startDate");
    log("End date: $endDate");
    context.read<GetExpenseBloc>().add(
        GetExpenseEv(
          walletId: walletSelected,
          keyword: keyword,
          categoryId: categorySelected,
          createdById: memberSelected,
          startDate: startDate,
          endDate: endDate
        )
    );
  }
}

