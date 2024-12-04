import 'package:ex_money/screens/main/blocs/get_home_overview/home_overview_bloc.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/expense_list.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  GlobalKey comparePrevMonthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeOverviewBloc(OverviewRepositoryImpl())..add(HomeOverViewEv(123)), //get default the current month
      child: BlocBuilder<HomeOverviewBloc, HomeOverviewState>(
        builder: (context, state) {
          if (state is HomeOverviewFailure) {
            // showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
            return const Center(child: Text(""),);
          } else if (state is HomeOverviewLoading) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is HomeOverviewSuccess) {
            final HomeOverviewResponse response = state.data;
            List<ExpenseResponse> expenseList = response.ownerExpenses;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  //header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            DecoratedBox(
                              child: Icon(
                                Icons.person, size: 46, color: cPrimary,),
                              decoration: BoxDecoration(
                                border: Border.all(color: cPrimary, width: 4),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            const SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Chào buổi tối",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: cText
                                  ),
                                ),
                                Text(
                                  response.user.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: cText
                                  ),
                                ),
                              ],
                            )
                          ]
                      ),
                      const Icon(
                        Icons.notifications_outlined,
                        size: 28,
                      )
                    ],
                  ),
                  //---- end header
                  const SizedBox(height: 16,),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đã chi tiêu",
                        style: TextStyle(
                          fontSize: 14,
                          color: cText,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Tháng này",
                            style: TextStyle(
                                fontSize: 14,
                                color: cTextDisable
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: cTextDisable,
                            size: 14,
                          )
                        ],
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
                            response.totalExpenseAmount.toString(),
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: cPrimary
                            ),
                          ),
                          const Text(" VNĐ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cTextDisable),)
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
                                    " ${response.moreThanLastMonth}",
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

                  //demo
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 150,
                      child: Image.asset('assets/images/test/test_stats_home.png')
                  ),

                  const SizedBox(height: 10,),

                  Expanded(child: ExpenseList(expenseList))
                ]
            );
          } else {
            // showDialogResponse(context, false, "Có lỗi xảy ra", "");
            return Center();
          }
        },
      ),
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
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu ít hơn $amount so với ngày này tháng trước";
    } else if (amount == 0) {
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu bằng ngày này tháng trước";
    } else {
      content = "Từ đầu tháng tới nay, bạn đang chi tiêu nhiều hơn $amount so với ngày này tháng trước";
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


