import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_filter_resource/get_expense_filter_resource_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_home_overview/home_overview_bloc.dart';
import 'package:ex_money/screens/main/blocs/mark_read_notification/mark_read_notification_bloc.dart';
import 'package:ex_money/screens/main/views/stats/stats_line_chart.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../blocs/get_wallet_list/get_wallet_list_bloc.dart';


class HomeScreen extends StatefulWidget {
  // final ExpenseResponse? newExpense;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  GlobalKey comparePrevMonthKey = GlobalKey();
  GlobalKey selectMonthKey = GlobalKey();
  GlobalKey notiListKey = GlobalKey();

  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _expenseScrollController = ScrollController();

  List<NotificationResponse> notificationList = [];


  @override
  void initState() {
    super.initState();

    // Add listener to the child ScrollController
    _expenseScrollController.addListener(() {
      double currentPosition = _expenseScrollController.position.pixels;
      double minPosition = _expenseScrollController.position.minScrollExtent;
      if (currentPosition == minPosition) {
        _homeScrollController.animateTo(
          _homeScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (currentPosition > minPosition) { // > 0
        _homeScrollController.animateTo(
          _homeScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _homeScrollController.dispose();
    _expenseScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ExpenseResponse? expenseAdd = widget.newExpense;
    return BlocBuilder<HomeOverviewBloc, HomeOverviewState>(
      builder: (context, state) {
        if (state is HomeOverviewFailure) {
          return const Center(child: Text(""),);
        } else if (state is HomeOverviewLoading) {
          return const Center(
            child: Loading(loadingColor: null,)
          );
        } else if (state is HomeOverviewSuccess) {
          final HomeOverviewResponse response = state.data;
          List<ExpenseResponse> expenseList = response.ownerExpenses;
          notificationList = response.notifications;
          int unseenNotiCount = notificationList.where((item) => !item.seen).length;
          // if (expenseAdd != null) {
          //   setState(() {
          //     expenseList.add(expenseAdd);
          //   });
          // }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeOverviewBloc>().add(HomeOverViewEv(month: null, year: null, isReload: true));
              context.read<GetWalletListBloc>().add(GetWalletListEv(isReload: true));
              context.read<GetExpenseEditResourceBloc>().add(GetExpenseEditResourceEv(walletId: null, isReload: true));
              context.read<GetExpenseFilterResourceBloc>().add(GetExpenseFilterResourceEv(walletId: null, isReload: true, isCache: true));
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  //header
                  Expanded(
                    child: ListView(
                      controller: _homeScrollController,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: cPrimary, width: 4),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.person, size: 34, color: cPrimary,),
                                  ),
                                  const SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateTime.now().hour < 12
                                            ? "Chào buổi sáng"
                                            : (DateTime.now().hour > 12 && DateTime.now().hour < 18
                                              ? "Chào buổi chiều"
                                              : "Chào buổi tối"
                                            ),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: cText
                                        ),
                                      ),
                                      Text(
                                        response.user.name,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: cText
                                        ),
                                      ),
                                    ],
                                  )
                                ]
                            ),
                            GestureDetector(
                              onTap: () async {
                                showBubbleNotificationList(context);
                              },
                              child: Stack(
                                key: notiListKey,
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    size: 28,
                                  ),
                                  unseenNotiCount > 0 ? Positioned(
                                    right: 0,
                                    top: -1,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cPrimary,
                                      ),
                                      child: Text(
                                        "$unseenNotiCount",
                                        style: TextStyle(color: Colors.white, fontSize: unseenNotiCount > 9 ? 7 : 10),
                                      ),
                                    ),
                                  ) : const Text("")
                                ],
                              ),
                            ),
                          ],
                        ),
                        //---- end header
                        const SizedBox(height: 16,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Đã chi tiêu",
                              style: TextStyle(
                                fontSize: 14,
                                color: cText,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                int selectedMonth = await showMonthSelect(context, response.currentMonth);
                                if (context.mounted) {
                                  context.read<HomeOverviewBloc>().add(HomeOverViewEv(month: selectedMonth, year: null, isReload: true));
                                }
                              },
                              child: Container(
                                key: selectMonthKey,
                                child: Row(
                                  children: [
                                    Text(
                                      "Tháng ${getCurrentMonth(response.currentMonth.toInt())}",
                                      // "Tháng ${response.currentMonth == response.currentMonth ? "này" : response.currentMonth}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: cTextDisable
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: cTextDisable,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 6,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  toAmountFormat(response.totalExpenseAmount),
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: cPrimary
                                  ),
                                ),
                                const Text("VNĐ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cTextDisable),)
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showBubbleComparePrevMonth(context, -150000);
                              },
                              child: Container(
                                key: comparePrevMonthKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.arrow_upward_rounded, color: Colors.red, size: 12,),
                                        Text(
                                          " ${toAmountFormat(response.moreThanLastMonth)}",
                                          style: const TextStyle(fontSize: 12, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          "So với tháng trước ",
                                          style: TextStyle(color: cTextDisable, fontSize: 12),
                                        ),
                                        Icon(Icons.info_outline, size: 12,)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 200,
                            child: StatsLineChart(weekList: response.weeks,)
                        ),

                        const SizedBox(height: 10,),

                        SizedBox(
                            height: MediaQuery.of(context).size.height - 40,
                            child: ExpenseList(expenseList, true, _expenseScrollController)
                        ),
                      ],
                    ),
                  )
                ]
            ),
          );
        } else {
          // showDialogResponse(context, false, "Có lỗi xảy ra", "");
          return const Center();
        }
      },
    );
  }

  Future<int> showMonthSelect(BuildContext context, num oldSelectedMonth) async {
    RenderBox box = selectMonthKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    return await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Stack(
            children: [
              Positioned(
                top: position.dy,
                right: ConstantSize.hozPadScreen, // Center the bubble horizontally around the icon
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 4,
                    height: 300,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (ctx, idx) {
                        idx++;
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, idx);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: idx == oldSelectedMonth ? cMediumPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text("Tháng ${getCurrentMonth(idx)}", style: TextStyle(color: idx == oldSelectedMonth ? Colors.white : cTextDisable),),
                          ),
                        );
                      }
                    )
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  void showBubbleNotificationList(BuildContext context) {
    RenderBox box = notiListKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    Size size = box.size;
    double parentHeight = size.height;

    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return BlocProvider(
            create: (context) => MarkReadNotificationBloc(NotificationRepositoryImpl()),
            child: Stack(
              children: [
                Positioned(
                  top: position.dy + parentHeight, // Add padding between icon and bubble
                  right: ConstantSize.hozPadScreen, // Center the bubble horizontally around the icon
                  child: Material(
                    color: Colors.transparent,
                    child: BlocListener<MarkReadNotificationBloc, MarkReadNotificationState>(
                      listener: (context, state) {
                        if (state is MarkReadNotificationFailure) {
                          showDialogResponse(context, false, "Có lỗi xảy ra", "Có lỗi khi cập nhật thông báo");
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 1.4,
                        height: MediaQuery.sizeOf(context).height / 1.5,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Thông báo", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Row(
                                    children: [
                                      Icon(Icons.read_more, size: 16,),
                                      SizedBox(width: 4,),
                                      Text("Đọc tất cả", style: TextStyle(
                                        fontSize: 12
                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: notificationList.isEmpty ? const Center(
                                child: Text("Chưa có thông báo nào"),
                              ) : ListView.builder(
                                itemCount: notificationList.length,
                                itemBuilder: (ctx, idx) {
                                  NotificationResponse data = notificationList[idx];
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<MarkReadNotificationBloc>().add(MarkReadNotificationEv(id: data.id, all: false));
                                      setState(() {
                                        data.seen = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      color: data.seen ? Colors.white : cBlurPrimary,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  getNotificationTypeIcon(data.type),
                                                  const SizedBox(width: 6,),
                                                  Text(
                                                    getNotificationTypeName(data.type),
                                                    style: const TextStyle(
                                                        color: cTextDisable,
                                                      fontSize: 12
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                dateTimeFormatedFromStr(data.createdAt, false),
                                                style: const TextStyle(fontSize: 12, color: cTextDisable),
                                              )
                                            ],
                                          ),
                                          Text(data.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12
                                            ),
                                          ),
                                          const SizedBox(height: 4,),
                                          Text(
                                            data.content,
                                            style: const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void showBubbleComparePrevMonth(BuildContext context, num amount) {
    RenderBox box = comparePrevMonthKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    Size size = box.size;
    double parentHeight = size.height;
    String content = "";
    if (amount < 0) {
      amount = amount.abs();
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu ít hơn ${toAmountFormat(amount)} so với ngày này tháng trước";
    } else if (amount == 0) {
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu bằng ngày này tháng trước";
    } else {
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu nhiều hơn ${toAmountFormat(amount)} so với ngày này tháng trước";
    }
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Stack(
            children: [
              Positioned(
                top: position.dy + parentHeight, // Add padding between icon and bubble
                right: ConstantSize.hozPadScreen, // Center the bubble horizontally around the icon
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "So với ngày này tháng trước",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: cTextDisable,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 12,
                            color: cTextDisable,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}


