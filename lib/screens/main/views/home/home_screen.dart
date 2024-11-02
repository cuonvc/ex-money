import 'package:ex_money/screens/main/views/home/components/expense_list.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repository/repository.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context)?.settings.arguments as List;
    UserResponse userInfo = UserResponse.fromMap(data[2]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 60,),
        //header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                children: [
                  DecoratedBox(
                    child: Icon(Icons.person, size: 46, color: cPrimary,),
                    decoration: BoxDecoration(
                      border: Border.all(color: cPrimary, width: 4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  SizedBox(width: 14,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chào buổi tối",
                        style: TextStyle(
                            fontSize: 12,
                            color: cText
                        ),
                      ),
                      Text(
                        "${userInfo.name}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cText
                        ),
                      ),
                    ],
                  )
                ]
            ),
            Icon(
              Icons.notifications_outlined,
              size: 28,
            )
          ],
        ),
        //---- end header


        SizedBox(height: 24,),


        Row(
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


        SizedBox(height: 10,),


        Text(
          "-3.500.500 VND",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900
          ),
        ),


        SizedBox(height: 20,),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 34,
                    color: Colors.green,
                  ),
                  Column(
                    children: [
                      Text(
                        "Tổng số",
                      ),
                      Text(
                          "5.000.000"
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.trending_down,
                    color: Colors.red,
                    size: 34,
                  ),
                  Column(
                    children: [
                      Text(
                        "Tổng số",
                      ),
                      Text(
                          "5.000.000"
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Tên ví 1",
                  style: TextStyle(
                      fontSize: 14,
                      color: cTextDisable,
                      decoration: TextDecoration.underline
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: cTextDisable,
                  size: 14,
                )
              ],
            ),
            Text(
              "Tất cả giao dịch",
              style: TextStyle(
                  fontSize: 14,
                  color: cTextDisable,
                  decoration: TextDecoration.underline
              ),
            )
          ],
        ),

        const Expanded(child: ExpenseList(),),
      ],
    );
  }
}


