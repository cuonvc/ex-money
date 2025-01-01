import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:ex_money/screens/main/blocs/get_expense_filter_resource/get_expense_filter_resource_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_home_overview/home_overview_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_wallet_list/get_wallet_list_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../blocs/get_category/get_category_bloc.dart';
import '../blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool isLoading = true;
  static int initiated = 0;
  final totalInit = 5;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeOverviewBloc(OverviewRepositoryImpl())..add(HomeOverViewEv(month: null, isReload: true)),
        ),
        BlocProvider(
          create: (context) => GetWalletListBloc(WalletRepositoryImpl())..add(GetWalletListEv(isReload: true)),
        ),
        BlocProvider(
          create: (context) => GetCategoryBloc(CategoryRepositoryImpl())..add(GetCategoryEv(walletId: null, isReload: true)),
        ),
        BlocProvider(
          create: (context) => GetExpenseEditResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseEditResourceEv(walletId: null, isReload: true)),
        ),
        BlocProvider(
          create: (context) => GetExpenseFilterResourceBloc(ExpenseRepositoryImpl())..add(GetExpenseFilterResourceEv(null)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeOverviewBloc, HomeOverviewState>(
            listener: (context, state) {
              checking(state);
            },
          ),
          BlocListener<GetWalletListBloc, GetWalletListState>(
            listener: (context, state) {
              checking(state);
            },
          ),
          BlocListener<GetCategoryBloc, GetCategoryState>(
            listener: (context, state) {
              checking(state);
            },
          ),
          BlocListener<GetExpenseFilterResourceBloc, GetExpenseFilterResourceState>(
            listener: (context, state) {
              checking(state);
            },
          ),
          BlocListener<GetExpenseEditResourceBloc, GetExpenseEditResourceState>(
            listener: (context, state) {
              checking(state);
            },
          ),
        ],
        child: Scaffold(
          body: Center(child: Text("WELCOME EXMONEY"),),
        ),
      ),
    );
  }

  void checking(Equatable state) {
    log("====================> Init resource");
    if (state is HomeOverviewSuccess || state is GetWalletListSuccess || state is GetCategorySuccess
        || state is GetExpenseEditResourceSuccess || state is GetExpenseFilterResourceSuccess) {

      setState(() {
        initiated++;
        if (initiated == totalInit) {
          isLoading = false;
        }
        log("Current initiated: $initiated");
      });
      if (initiated == totalInit) {
        Navigator.pushNamed(context, NavigatePath.homePath); //or auth selection
      }
    } else if (state is HomeOverviewFailure || state is GetWalletListFailure || state is GetCategoryFailure
        || state is GetExpenseEditResourceFailure || state is GetExpenseFilterResourceFailure) {

      setState(() {
        isLoading = false;
      });
    }
  }
}
