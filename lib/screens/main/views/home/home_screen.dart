import 'package:ex_money/screens/main/views/home/components/expense_list.dart';
import 'package:ex_money/screens/main/views/home/components/wallet_detail.dart';
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
        const SizedBox(height: 20,),
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
                      const Text(
                        "Chào buổi tối",
                        style: TextStyle(
                            fontSize: 12,
                            color: cText
                        ),
                      ),
                      Text(
                        userInfo.name,
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
        const SizedBox(height: 30,),
        const Expanded(child: WalletDetail())
      ]
    );
  }
}


