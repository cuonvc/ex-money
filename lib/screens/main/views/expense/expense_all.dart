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
          create: (context) => GetExpenseFilterResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseFilterResourceEv(null)),
        ),
        BlocProvider(
          create: (context) => GetExpenseBloc(ExpenseRepositoryImpl())..add(GetExpenseEv(null, null, null, null)),
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

  late bool filterByMemberVisible;
  late bool filterByCategoryVisible;
  late bool filterByWalletVisible;

  @override
  void initState() {
    filterByMemberVisible = false;
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
      body: BlocBuilder<GetExpenseFilterResourceBloc, GetExpenseFilterResourceState>(
        builder: (context, state) {
          if (state is GetExpenseFilterResourceLoading) {
            return const Center(child: Loading(),);
          } else if (state is GetExpenseFilterResourceSuccess) {
            ExpenseFilterResource resource = state.resource;
            walletSelected = resource.walletId;
            String walletDisplay = resource.walletName;
            return Padding(
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
                            filterByWalletVisible = !filterByWalletVisible;
                            filterByMemberVisible = false;
                            filterByCategoryVisible = false;
                          })
                        },
                        child: Row(
                          children: [
                            Icon(Icons.filter_list),
                            SizedBox(width: 8,),
                            Text(walletDisplay),
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
                            Icon(Icons.filter_list),
                            SizedBox(width: 8,),
                            Text("Chi tiêu của bạn"),
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
                            Icon(Icons.filter_list),
                            SizedBox(width: 8,),
                            Text("Danh mục"),
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
                  });
                  context.read<GetExpenseFilterResourceBloc>().add(GetExpenseFilterResourceEv(numberFromString(walletMap.keys.first)));
                  context.read<GetExpenseBloc>().add(GetExpenseEv(walletSelected, searchTxtController.text, categorySelected, memberSelected));
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
                  });
                  context.read<GetExpenseBloc>().add(GetExpenseEv(walletSelected, searchTxtController.text, categorySelected, memberSelected));
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
                  });
                  context.read<GetExpenseBloc>().add(GetExpenseEv(walletSelected, searchTxtController.text, categorySelected, memberSelected));
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
    context.read<GetExpenseBloc>().add(GetExpenseEv(walletSelected, keyword, categorySelected, memberSelected));
  }
}

