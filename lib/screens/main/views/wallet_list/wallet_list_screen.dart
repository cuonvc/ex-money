import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/screens/main/blocs/wallet_change_user/wallet_change_user_bloc.dart';
import 'package:ex_money/screens/main/views/wallet_list/add_user_to_wallet.dart';
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
  final accountExpandedList = [];
  int currentWalletIndex = 0;
  WalletResponse currentWallet = WalletResponse.empty();

  void _updateCurrentWallet(WalletResponse response) {
    log("===========> Data response: ${currentWallet.members.length}");
    setState(() {
      // currentWallet = response;
      accountExpandedList.add(false);
    });
    context.read<GetWalletListBloc>().add(
          UpdateCurrentWalletEv(
            response,
            currentWalletIndex,
          ),
        );
    log("===========> Data response: ${currentWallet.members.length}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetWalletListBloc(WalletRepositoryImpl())..add(GetWalletListEv()),
      child: BlocBuilder<GetWalletListBloc, GetWalletListState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          if (state is GetWalletListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetWalletListSuccess) {
            if (state.listWallet.isNotEmpty) {
              accountExpandedList.addAll(List.generate(state.listWallet.length,
                  (_) => false)); //get from account of wallet
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
                              isScrollControlled: false);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: cPrimary,
                            ),
                            Text(
                              "Thêm ví mới",
                              style: TextStyle(color: cPrimary),
                            )
                          ],
                        ),
                      ) //sau sẽ thêm bộ lọc
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 4,
                    child: PageView.builder(
                      itemCount: walletCount,
                      scrollDirection: Axis.horizontal,
                      controller: PageController(
                          viewportFraction: walletCount >= 2 ? 0.9 : 1),
                      onPageChanged: (int index) {
                        setState(() {
                          currentWalletIndex = index;
                          currentWallet = state.listWallet[index];
                        });
                      },
                      itemBuilder: (context, idx) {
                        double fullHeight = MediaQuery.sizeOf(context).height;
                        double heightCard = fullHeight / 5;
                        currentWallet = state.listWallet[currentWalletIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: walletCount >= 2 ? 6 : 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              // width: fullWidth,
                              height: heightCard,
                              decoration: BoxDecoration(
                                  color: cBlurPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(
                                          3, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${currentWallet.balance} VND",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.circle_sharp,
                                                size: 24,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                  "Hạn mức ${currentWallet.totalIncome}")
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.trending_down,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                  "Đã chi ${currentWallet.totalExpense}")
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
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: cTextDisable,
                                            fontWeight: FontWeight.bold),
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
                      child: Image.asset(
                          'assets/images/test/test_stats_wallet.png')),

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
                                child:
                                    tabTitle("Thông tin ví", informationTab)),
                          ],
                        ),
                        //expenses tab
                        expenseListTab(state.listWallet[currentWalletIndex]),
                        //member tab
                        memberTab(state.listWallet[currentWalletIndex]),
                        //wallet info tab
                        walletInfoTab(state.listWallet[currentWalletIndex])
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(child: Text("Get wallet list failed"));
          }
        },
      ),
    );
  }

  Widget expenseListTab(WalletResponse data) {
    return Visibility(
      visible: expenseTab,
      child: Expanded(
        child: ExpenseList(data.expenses),
      ),
    );
  }

  Widget memberTab(WalletResponse itemWallet) {
    return Visibility(
      visible: accountTab,
      child: Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    WalletResponse? response = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return BlocProvider(
                            create: (ctx) =>
                                WalletChangeUserBloc(WalletRepositoryImpl()),
                            child: AddUserToWallet(
                              walletId: itemWallet.id.toString(),
                            ),
                          );
                        },
                        isScrollControlled: true);

                    if (response != null) {
                      _updateCurrentWallet(response);
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: cPrimary,
                      ),
                      Text(
                        "Add member",
                        style: TextStyle(color: cPrimary),
                      )
                    ],
                  ),
                ),
              ],
            ),

            //I want to current wallet update here
            Expanded(
              child: ListView.builder(
                itemCount: itemWallet.members.length,
                itemBuilder: (context3, index3) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!accountExpandedList[index3]) {
                              accountExpandedList.clear();
                              accountExpandedList.addAll(List.generate(
                                  itemWallet.members.length, (_) => false));
                            }
                            accountExpandedList[index3] =
                                !accountExpandedList[index3];
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                    "assets/images/test/avatar.png"), //test, nếu chay thật thì đoạn này lấy link từ back (sử dụng NetworkImage)
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(currentWallet.members[index3]),
                              AnimatedRotation(
                                turns: accountExpandedList[index3] ? 0.75 : 0.5,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.grey,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                          child: Visibility(
                            visible: accountExpandedList[index3],
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Xóa khỏi ví"),
                                  Text("Chỉnh sửa quyền"),
                                  Text("Thông tin")
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 14,
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget walletInfoTab(WalletResponse data) {
    return Visibility(
      visible: informationTab,
      child: Center(
        child: Text("Thong tin vi"),
      ),
    );
  }

  Text tabTitle(String title, isSelected) {
    return Text(
      title,
      style: TextStyle(color: isSelected ? cPrimary : cTextDisable),
    );
  }
}
