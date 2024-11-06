import 'package:ex_money/screens/main/views/home/home_screen.dart';
import 'package:ex_money/screens/main/views/note/note_screen.dart';
import 'package:ex_money/screens/main/views/stats/stats_screen.dart';
import 'package:ex_money/screens/main/views/wallet_list/wallet_screen.dart';
import 'package:ex_money/widgets/expense_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int screenIndex = 0;
  late Color selectedTab = cPrimary;
  Color unselectedTab = Colors.grey;

  //static screen index
  static const int _homeIndex = 0;
  static const int _statsIndex = 1;
  static const int _walletIndex = 2;
  static const int _noteIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      body: SafeArea(
        child: Stack(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
                  child: getSelectedScreen(screenIndex) //dynamic switch screens
                ),
              ),


              // ---- Bottom bar ----
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomAppBar(
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 6,
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget> [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  screenIndex = _homeIndex;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: screenIndex == _homeIndex ? selectedTab : unselectedTab,
                                    size: screenIndex == _homeIndex ? 26 : 24,
                                  ),
                                  Text(
                                    "Tổng quan",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: screenIndex == _homeIndex ? selectedTab : unselectedTab
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  screenIndex = _statsIndex;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.query_stats,
                                    color: screenIndex == _statsIndex ? selectedTab : unselectedTab,
                                    size: screenIndex == _statsIndex ? 26 : 24,
                                  ),
                                  Text(
                                    "Biểu đồ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: screenIndex == _statsIndex ? selectedTab : unselectedTab
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(width: MediaQuery.of(context).size.width / 5,),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  screenIndex = _walletIndex;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.wallet,
                                    color: screenIndex == _walletIndex ? selectedTab : unselectedTab,
                                    size: screenIndex == _walletIndex ? 26 : 24,
                                  ),
                                  Text(
                                    "Quản lý ví",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: screenIndex == _walletIndex ? selectedTab : unselectedTab
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  screenIndex = _noteIndex;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.edit_note_sharp,
                                    color: screenIndex == _noteIndex ? selectedTab : unselectedTab,
                                    size: screenIndex == _noteIndex ? 26 : 24,
                                  ),
                                  Text(
                                    "Ghi chú",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: screenIndex == _noteIndex ? selectedTab : unselectedTab
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ]
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: FloatingActionButton(
          backgroundColor: cPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return expenseEdit(context);
                }
            );
          },
        ),
      ),
    );
  }

  Widget getSelectedScreen(int screenIndex) {
    switch (screenIndex) {
      case _homeIndex:
        return const HomeScreen();
      case _statsIndex:
        return const StatsScreen();
      case _walletIndex:
        return const WalletScreen();
      case _noteIndex:
        return const NoteScreen();
      default:
        return const HomeScreen();
    }
  }
}
