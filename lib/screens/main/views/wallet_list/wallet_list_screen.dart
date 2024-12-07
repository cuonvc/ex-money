import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/member_tab.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/wallet_info.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_bottom_sheet.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {

  late int walletCount = 0;
  bool expenseTab = true;
  bool accountTab = false;
  bool informationTab = false;
  List<WalletResponse> walletList = [];
  int currentWalletIndex = 0;
  late double cardHeight = 0;
  double statsHeight = 120;
  WalletResponse currentWallet = WalletResponse.empty();

  final ScrollController _walletScrollController = ScrollController();
  final ScrollController _expenseScrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    // Add listener to the child ScrollController
    _expenseScrollController.addListener(() {
      double currentPosition = _expenseScrollController.position.pixels;
      double minPosition = _expenseScrollController.position.minScrollExtent;
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
    });
  }


  @override
  void dispose() {
    super.dispose();
    _walletScrollController.dispose();
    _expenseScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.sizeOf(context).height;
    cardHeight = fullHeight / 5;
    return BlocProvider(
      create: (context) => GetWalletListBloc(WalletRepositoryImpl())..add(GetWalletListEv()),
      child: BlocBuilder<GetWalletListBloc, GetWalletListState>(
        builder: (context, state) {
          if (state is GetWalletListLoading) {
            return const Center(child: Loading(),);
          } else if (state is GetWalletListSuccess) {
            walletList = state.walletList;
            walletCount = walletList.length;
            //init screen
            if (currentWallet.id == 0) {
              currentWallet = walletList[0];
            }
            return Column(
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
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => BaseBottomSheet(),
                            isScrollControlled: false
                        );
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
                    controller: PageController(viewportFraction: walletCount >= 2 ? 0.9 : 1),
                    onPageChanged: (int index) {
                      setState(() {
                        currentWalletIndex = index;
                        currentWallet = walletList[index];
                      });
                    },
                    itemBuilder: (context, idx) {
                      // currentWallet = walletList[currentWalletIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: walletCount >= 2 ? 6 : 0),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            // width: fullWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                                color: cBlurPrimary,
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(3, 3), // changes position of shadow
                                  ),
                                ]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${currentWallet.balance} VND",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900
                                      ),
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
                                            Text("Hạn mức ${currentWallet.totalIncome}")
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
                                            Text("Đã chi ${currentWallet.totalExpense}")
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      currentWallet.name,
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
                      //demo
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: statsHeight,
                          child: Image.asset('assets/images/test/test_stats_wallet.png')
                      ),

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height - cardHeight - statsHeight - 20,
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
                                      informationTab = false;
                                    });
                                  },
                                  child: tabTitle("GD gần đây", expenseTab),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      expenseTab = false;
                                      accountTab = true;
                                      informationTab = false;
                                    });
                                  },
                                  child: tabTitle("Thành viên", accountTab),
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        expenseTab = false;
                                        accountTab = false;
                                        informationTab = true;
                                      });
                                    },
                                    child: tabTitle("Thông tin ví", informationTab)
                                ),
                              ],
                            ),
                            //expenses tab
                            Visibility(
                              visible: expenseTab,
                              child: Expanded(
                                child: ExpenseList(
                                  walletList[currentWalletIndex].expenses,
                                  true,
                                  _expenseScrollController
                                ),
                              ),
                            ),
                            //member tab
                            Visibility(
                              visible: accountTab,
                              child: Expanded(child: MemberTab(wallet: currentWallet, key: ValueKey(currentWallet),),),
                            ),
                            //wallet info tab
                            Visibility(
                              visible: informationTab,
                              child: WalletInfo(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          } else if (state is GetWalletListFailure) {
            return Center(child: Text("Ops! ${state.message}"));
          } else {
            return const Center(child: Text("Ops! Có lỗi xảy ra"));
          }
        },
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
