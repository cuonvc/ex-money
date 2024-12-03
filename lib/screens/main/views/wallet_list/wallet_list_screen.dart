import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/screens/main/blocs/wallet_change_user/wallet_change_user_bloc.dart';
import 'package:ex_money/screens/main/views/wallet_list/add_user_to_wallet.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/member_tab.dart';
import 'package:ex_money/screens/main/views/wallet_list/widgets/wallet_info.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_bottom_sheet.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:flutter/cupertino.dart';
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
  WalletResponse currentWallet = WalletResponse.empty();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWalletListBloc(WalletRepositoryImpl())..add(GetWalletListEv()),
      child: BlocBuilder<GetWalletListBloc, GetWalletListState>(
        builder: (context, state) {
          if (state is GetWalletListLoading) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is GetWalletListSuccess) {
            List data = state.data;
            if (data.isNotEmpty) {

              List rawData = data[0];
              walletCount = rawData.length;
              walletList = rawData.map((wallet) => WalletResponse.fromMap(wallet)).toList();
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
                        log("Current wallet: ${currentWallet.id}");
                        setState(() {
                          currentWalletIndex = index;
                          currentWallet = walletList[index];
                        });
                      },
                      itemBuilder: (context, idx) {
                        double fullHeight = MediaQuery.sizeOf(context).height;
                        double heightCard = fullHeight / 5;
                        // currentWallet = walletList[currentWalletIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: walletCount >= 2 ? 6 : 0),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              // width: fullWidth,
                              height: heightCard,
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
                  //demo
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 120,
                      child: Image.asset('assets/images/test/test_stats_wallet.png')
                  ),

                  Expanded(
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
                          child: Expanded(child: ExpenseList(walletList[currentWalletIndex].expenses),),
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
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return const Center(child: Text("Get wallet list failed"));
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
