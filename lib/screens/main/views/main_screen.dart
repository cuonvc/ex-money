import 'package:ex_money/screens/main/blocs/add_expense/add_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense/get_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/screens/main/views/home/home_screen.dart';
import 'package:ex_money/screens/main/views/note/note_screen.dart';
import 'package:ex_money/screens/main/views/stats/stats_screen.dart';
import 'package:ex_money/screens/main/views/wallet_list/wallet_list_screen.dart';
import 'package:ex_money/widgets/expense_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:repository/repository.dart';

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
                child: getSelectedScreen(screenIndex) //dynamic switch screens
              ),


              // ---- Bottom bar ----
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 64,
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
                            child: SizedBox(
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
                                      size: screenIndex == _homeIndex ? 22 : 20,
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
                            child: SizedBox(
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
                                      size: screenIndex == _statsIndex ? 22 : 20,
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
                          Flexible(
                            child: Container(
                                width: MediaQuery.of(context).size.width / 5,
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Thêm \nchi tiêu",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: unselectedTab
                                  ),
                                )
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
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
                                      size: screenIndex == _walletIndex ? 22 : 20,
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
                            child: SizedBox(
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
                                      size: screenIndex == _noteIndex ? 22 : 20,
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
              ),
            ]
        ),
      ),

      floatingActionButtonLocation: CustomFABLocation(offsetY: 2),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: 45,
          height: 45,
          child: FloatingActionButton(
            backgroundColor: cPrimary,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              ExpenseCreateRequest? newExpense = await showDialog<ExpenseCreateRequest>(
                context: context,
                builder: (BuildContext ctx) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (ctx) => GetExpenseEditResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseEditResourceEv(null)),
                      ),
                      BlocProvider(
                        create: (ctx) => AddExpenseBloc(ExpenseRepositoryImpl()),
                      ),
                    ],
                    child: const ExpenseEdit(),
                  );
                }
              );

              // if (newExpense != null) {
              //   context.read<GetExpenseBloc>().add(GetExpenseEv(newExpense.walletId));
              // }
            },
          ),
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
        return const WalletListScreen();
      case _noteIndex:
        return const NoteScreen();
      default:
        return const HomeScreen();
    }
  }
}

//from chatGPT
class CustomFABLocation extends FloatingActionButtonLocation {
  final double offsetY; // Allows customization of vertical positioning

  CustomFABLocation({this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width / 2) -
        (scaffoldGeometry.floatingActionButtonSize.width / 2);

    // Default positioning with manual adjustment for BottomAppBar height
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        48 - // Approximate height of the BottomAppBar
        offsetY; // Custom offset for elevation

    return Offset(fabX, fabY);
  }
}