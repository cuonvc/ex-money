import 'package:ex_money/screens/main/views/home/home_screen.dart';
import 'package:ex_money/screens/main/views/note/note_screen.dart';
import 'package:ex_money/screens/main/views/stats/stats_screen.dart';
import 'package:ex_money/screens/main/views/wallet_list/wallet_list_screen.dart';
import 'package:ex_money/widgets/expense_edit.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../utils/constant.dart';
import '../blocs/add_expense/add_expense_bloc.dart';
import '../blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import '../blocs/get_home_overview/home_overview_bloc.dart';
import '../blocs/get_wallet_list/get_wallet_list_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int screenIndex = 0;
  late Color selectedTab = cPrimary;
  Color unselectedTab = Colors.grey;
  ExpenseResponse? expenseAdd;

  //static screen index
  static const int _homeIndex = 0;
  static const int _statsIndex = 1;
  static const int _walletIndex = 2;
  static const int _noteIndex = 3;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeOverviewBloc>(
          create: (context) => HomeOverviewBloc(OverviewRepositoryImpl())..add(HomeOverViewEv(null)),
        ),
        BlocProvider<GetWalletListBloc>(
          create: (context) => GetWalletListBloc(WalletRepositoryImpl())..add(GetWalletListEv()),
        ),
        BlocProvider<GetExpenseEditResourceBloc>(
          create: (context) => GetExpenseEditResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseEditResourceEv(null)),
        ),
      ],
      child: Scaffold(
        backgroundColor: cBackground,
        extendBody: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
            child: IndexedStack(
              index: screenIndex,
                children: [
                  HomeScreen(),
                  const StatsScreen(),
                  const WalletListScreen(),
                  const NoteScreen(),
                ]
            ),
          ),
        ),

        floatingActionButtonLocation: CustomFABLocation(offsetY: 2),
        floatingActionButton: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: 45,
            height: 45,
            child: BlocBuilder<GetExpenseEditResourceBloc, GetExpenseEditResourceState>(
              builder: (context, state) {
                if(state is GetExpenseEditResourceLoading) {
                  return const Center(child: Loading(),);
                } else if (state is GetExpenseEditResourceFailure) {
                  return const Center();
                } else if (state is GetExpenseEditResourceSuccess) {
                  ExpenseEditResource resource = state.resource;
                  return FloatingActionButton(
                    backgroundColor: cPrimary,
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      ExpenseResponse? newExpense = await showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return  BlocProvider(
                              create: (ctx) => AddExpenseBloc(ExpenseRepositoryImpl()),
                              child: ExpenseEdit(resource: resource),
                            );
                          }
                      );
                    },
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ),

        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            shadowColor: Colors.black,
            shape: const CircularNotchedRectangle(),
            height: 70,
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
                            "Phân tích",
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
    );
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
        60 - // Approximate height of the BottomAppBar
        offsetY; // Custom offset for elevation

    return Offset(fabX, fabY);
  }
}