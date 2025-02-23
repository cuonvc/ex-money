import 'dart:developer';

import 'package:ex_money/screens/main/blocs/create_expense_scheduler/create_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/blocs/create_wallet/create_wallet_bloc.dart';
import 'package:ex_money/screens/main/blocs/delete_wallet/delete_wallet_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_filter_resource/get_expense_filter_resource_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense_scheduler/update_expense_scheduler_bloc.dart';
import 'package:ex_money/screens/main/blocs/wallet_setting/wallet_setting_bloc.dart';
import 'package:ex_money/screens/main/views/stats/stats_pie_chart.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/create_wallet.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/member_tab.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/config_tab.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../blocs/get_home_overview/home_overview_bloc.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {

  late int walletCount = 0;
  bool expenseTab = true;
  bool accountTab = false;
  bool configTab = false;
  bool isLoading = false;
  List<WalletResponse> walletList = [];
  int currentWalletIndex = 0;
  late double cardHeight = 0;
  final double statsHeight = 300;
  // WalletResponse currentWallet = WalletResponse.empty();

  final ScrollController _walletScrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();

  PageController pageController = PageController(initialPage: 0);

  void executeScrollingAction() {
    double currentPosition = _tabScrollController.position.pixels;
    double minPosition = _tabScrollController.position.minScrollExtent;
    if (currentPosition == minPosition) {
      _walletScrollController.animateTo(
        _walletScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (currentPosition > minPosition) { // > 0
      _walletScrollController.animateTo(
        _walletScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  void initState() {
    super.initState();

    // Add listener to the child ScrollController
    _tabScrollController.addListener(() => executeScrollingAction());
  }


  @override
  void dispose() {
    super.dispose();
    _walletScrollController.dispose();
    _tabScrollController.dispose();
  }

  void onExpenseUpdate(ExpenseResponse? expense) {
    if (expense != null) {
      context.read<GetWalletListBloc>().add(GetWalletListEv(isReload: true)); //đoạn này xử lý realtime hơi khó nên thôi load lại
      context.read<HomeOverviewBloc>().add(HomeOverViewEv(month: null, year: null, isReload: true)); //reload ẩn
    }
  }

  void onRefresh(BuildContext ctx) {
    context.read<HomeOverviewBloc>().add(HomeOverViewEv(month: null, year: null, isReload: true));
    context.read<GetWalletListBloc>().add(GetWalletListEv(isReload: true));
    context.read<GetExpenseEditResourceBloc>().add(GetExpenseEditResourceEv(walletId: null, isReload: true));
    context.read<GetExpenseFilterResourceBloc>().add(GetExpenseFilterResourceEv(walletId: null, isReload: true, isCache: true));
  }

  void onResetNewExpense() {

  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.sizeOf(context).height;
    cardHeight = fullHeight / 5;
    return MultiBlocListener(
  listeners: [
    BlocListener<GetWalletListBloc, GetWalletListState>(
      listener: (context, state) {
        if (state is GetWalletListLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is GetWalletListSuccess) {
          setState(() {
            isLoading = false;
            walletList = state.walletList;
            walletCount = walletList.length;
            pageController = PageController(viewportFraction: walletCount >= 2 ? 0.9 : 1);
          });

        } else if (state is GetWalletListFailure) {
          setState(() {
            isLoading = false;
          });
          showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
        }
      },
    ),
    BlocListener<DeleteWalletBloc, DeleteWalletState>(
      listener: (ctx, state) async {
        if (state is DeleteWalletFailure) {
          await showDialogResponse(ctx, false, "Xóa ví", state.message);
          onRefresh(ctx);
        } else if (state is DeleteWalletSuccess) {
          await showDialogResponse(context, true, "Xóa ví", state.message);
          onRefresh(ctx);
          setState(() {
            currentWalletIndex = 0;
            // if (currentWalletIndex >= walletList.length) {
            //   currentWalletIndex = walletList.isNotEmpty ? walletList.length - 1 : 0;
            // }
          });
        }
      },

    )
  ],
  child: isLoading || walletList.isEmpty ? const Center(child: Loading(loadingColor: null,),) : RefreshIndicator(
        onRefresh: () async {
          onRefresh(context);
        },
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tất cả ví ($walletCount)",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    WalletResponse? newWallet = await showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (ctx) => CreateWalletBloc(WalletRepositoryImpl()),
                                ),
                                BlocProvider(
                                  create: (ctx) => HomeOverviewBloc(OverviewRepositoryImpl()),
                                ),
                                BlocProvider(
                                  create: (ctx) => GetWalletListBloc(WalletRepositoryImpl()),
                                ),
                                BlocProvider(
                                  create: (ctx) => GetExpenseEditResourceBloc(ExpenseRepositoryImpl()),
                                ),
                                BlocProvider(
                                  create: (ctx) => GetExpenseFilterResourceBloc(ExpenseRepositoryImpl()),
                                )
                              ],
                              child: const CreateWallet()
                          );
                        },
                        isScrollControlled: true
                    );
                    if (newWallet != null) {
                      onRefresh(context);
                    }
                    setState(() {
                      if (newWallet != null) {
                        walletCount++;
                        pageController.animateToPage(walletCount - 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: cPrimary,),
                      Text("Thêm ví mới", style: TextStyle(color: cPrimary),)
                    ],
                  ),
                )//sau sẽ thêm bộ lọc
              ],
            ),
            const SizedBox(height: 14,),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 4,
              child: PageView.builder(
                itemCount: walletCount,
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (int index) {
                  setState(() {
                    currentWalletIndex = index;
                    // currentWallet = walletList[index];
                  });
                },
                itemBuilder: (context, idx) {
                  // currentWallet = walletList[currentWalletIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        // width: fullWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${toAmountFormat(walletList[currentWalletIndex].balance)} VND",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        bool confirmed = await showDialogConfirm(context, "Xóa ví", "Bạn có chắc chắc muốn xóa ${walletList[currentWalletIndex].name}?", null, "Xóa");
                                        if (confirmed) {
                                          context.read<DeleteWalletBloc>().add(DeleteWalletEv(id: walletList[currentWalletIndex].id));
                                        }
                                      },
                                      child: const Icon(CupertinoIcons.delete, size: 18, color: cTextDisable,),
                                    )
                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.circle_sharp,
                                          size: 24,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 6,),
                                        Text("Hạn mức ${toAmountFormat(walletList[currentWalletIndex].expenseLimit)}")
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.trending_down,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 6,),
                                        Text("Đã chi ${toAmountFormat(walletList[currentWalletIndex].totalExpense)}")
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  walletList[currentWalletIndex].name,
                                  style: const TextStyle(fontSize: 14, color: cTextDisable, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            //khi pageView bên trên kéo qua lại, Bloc sẽ reload data dưới này, không call lại API
            Expanded(
              child: ListView(
                controller: _walletScrollController,
                children: [
                  SizedBox(
                      height: 300,
                      child: StatsPieChart(expenses: walletList[currentWalletIndex].expenses,)
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height - cardHeight,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = true;
                                  accountTab = false;
                                  configTab = false;
                                });
                              },
                              child: tabTitle("GD gần đây", expenseTab),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = false;
                                  accountTab = true;
                                  configTab = false;
                                });
                              },
                              child: tabTitle("Thành viên", accountTab),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    expenseTab = false;
                                    accountTab = false;
                                    configTab = true;
                                  });
                                },
                                child: tabTitle("Thiết lập", configTab)
                            ),
                          ],
                        ),
                        // expenses tab
                        Visibility(
                          visible: expenseTab,
                          child: Expanded(
                            child: ExpenseList(
                                walletList[currentWalletIndex].expenses,
                                true,
                                _tabScrollController,
                                null,
                                onExpenseUpdate,
                                onResetNewExpense
                            ),
                          ),
                        ),
                        // member tab
                        Visibility(
                          visible: accountTab,
                          child: Expanded(child: MemberTab(
                            _tabScrollController,
                            walletList[currentWalletIndex],
                            key: ValueKey(walletList[currentWalletIndex]),
                          ),),
                        ),
                        // wallet info tab
                        Visibility(
                          visible: configTab,
                          child:  MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (ctx) => WalletSettingBloc(WalletRepositoryImpl()),
                              ),
                              BlocProvider(
                                create: (context) => CreateExpenseSchedulerBloc(TaskRepositoryImpl()),
                              ),
                              BlocProvider(
                                create: (context) => UpdateExpenseSchedulerBloc(TaskRepositoryImpl()),
                              ),
                            ],
                            child: ConfigTab(
                                _tabScrollController,
                                walletList[currentWalletIndex]
                            ),
                          ),
                          // child: ConfigTab(walletId: walletList[currentWalletIndex].id, expenseLimit: walletList[currentWalletIndex].expenseLimit,),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
);
  }

  Text tabTitle(String title, isSelected) {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? cPrimary : cTextDisable
      ),
    );
  }
}
