import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
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
  int currentWallet = 0;

  @override
  Widget build(BuildContext context) {
    accountExpandedList.addAll(List.generate(2, (_) => false)); //get from account of wallet
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
              List<WalletResponse> walletList = rawData.map((wallet) => WalletResponse.fromMap(wallet)).toList();

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
                          currentWallet = index;
                        });
                      },
                      itemBuilder: (context, idx) {
                        double fullHeight = MediaQuery.sizeOf(context).height;
                        double heightCard = fullHeight / 5;
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
                                        "${walletList[currentWallet].balance} VND",
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
                                              Text("Hạn mức ${walletList[currentWallet].totalIncome}")
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
                                              Text("Đã chi ${walletList[currentWallet].totalExpense}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        walletList[currentWallet].name,
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
                              child: tabTitle("Gần đây", expenseTab),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expenseTab = false;
                                  accountTab = true;
                                  informationTab = false;
                                });
                              },
                              child: tabTitle("Tài khoản", accountTab),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    expenseTab = false;
                                    accountTab = false;
                                    informationTab = true;
                                  });
                                },
                                child: tabTitle("Thông tin", informationTab)
                            ),
                          ],
                        ),
                        //expenses tab
                        Visibility(
                          visible: expenseTab,
                          child: Expanded(child: ExpenseList(walletList[currentWallet].expenses),),
                        ),
                        //member tab
                        Visibility(
                            visible: accountTab,
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: walletList[currentWallet].members.length,
                                itemBuilder: (context3, index3) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            accountExpandedList[index3] = !accountExpandedList[index3];
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.account_circle_rounded),
                                            Text(walletList[currentWallet].members[index3]),
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
                                      AnimatedSize(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.linear,
                                          child: Visibility(
                                            visible: accountExpandedList[index3],
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 16),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Xóa khỏi ví"),
                                                  Text("Chỉnh sửa quyền"),
                                                  Text("Thông tin")
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                        ),
                        Visibility(
                          visible: informationTab,
                          child: Center(child: Text("Thong tin vi"),),
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