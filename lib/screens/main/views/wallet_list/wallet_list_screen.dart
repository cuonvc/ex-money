import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Quản lý ví", style: titleStyle(),)
                  //   ],
                  // ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tất cả ví ($walletCount)",
                        style: TextStyle(fontSize: 16),
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
                  SizedBox(height: 14,),
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
                        double fullWidth = MediaQuery.sizeOf(context).width;
                        double fullHeight = MediaQuery.sizeOf(context).height;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: walletCount >= 2 ? 6 : 0),
                              // width: fullWidth,
                              height: fullHeight / 4 - 30,
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
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "${walletList[currentWallet].balance} VND",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        // width: MediaQuery.of(context).size.width * 0.4,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.trending_up,
                                              size: 34,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 6,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  "Hạn mức",
                                                ),
                                                Text(
                                                    "${walletList[currentWallet].totalIncome}"
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // width: MediaQuery.of(context).size.width * 0.4,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.trending_down,
                                              color: Colors.red,
                                              size: 34,
                                            ),
                                            SizedBox(width: 6,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  "Đã chi",
                                                ),
                                                Text(
                                                    "${walletList[currentWallet].totalExpense}"
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 60, left: ConstantSize.hozPadScreen),
                                    child: Row(
                                      children: [
                                        Text(
                                          walletList[currentWallet].name,
                                          style: TextStyle(fontSize: 14, color: cTextDisable, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // const SizedBox(height: 10,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SizedBox(
                            //       width: walletCount * 24,
                            //       height: 20,
                            //       child: ListView.builder(
                            //         scrollDirection: Axis.horizontal,
                            //         itemCount: walletCount,
                            //         itemBuilder: (context1, index1) {
                            //           return walletCount < 2 ? const Text("") : Row(
                            //             mainAxisAlignment: MainAxisAlignment.center,
                            //             children: [
                            //               Icon(
                            //                 index > index1 || index == walletCount - 1 ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                            //                 size: 24, color: index == index1 ? cPrimary : Colors.grey,
                            //               )
                            //             ],
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20,),
                          ],
                        );
                      },
                    ),
                  ),

                  //khi pageView bên trên kéo qua lại sẽ cần reload data dưới này

                  //demo
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 150,
                      child: Image.asset('assets/images/test/test_stats_wallet.png')
                  ),

                  Expanded(child: ExpenseList(walletList[currentWallet].expenses))
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