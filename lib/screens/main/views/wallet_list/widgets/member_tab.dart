import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../../../utils/constant.dart';
import '../../../blocs/wallet_change_user/wallet_change_user_bloc.dart';
import '../add_user_to_wallet.dart';

class MemberTab extends StatefulWidget {
  final WalletResponse wallet;
  const MemberTab({Key? key, required this.wallet}) : super(key: key);

  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {

  late WalletResponse currentWallet;
  final accountExpandedList = [];


  @override
  void initState() {
    currentWallet = widget.wallet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                WalletResponse? response = await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (ctx) => WalletChangeUserBloc(WalletRepositoryImpl()),
                        child: AddUserToWallet(walletId: currentWallet.id.toString(),),
                      );
                    },
                    isScrollControlled: true
                );

                if (response != null) {
                  setState(() {
                    currentWallet = response;
                  });
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.add, color: cPrimary,),
                  Text("Add member", style: TextStyle(color: cPrimary),)
                ],
              ),
            ),
          ],
        ),

        Expanded(
          child: ListView.builder(
            itemCount: currentWallet.members.length,
            itemBuilder: (context3, index3) {
              accountExpandedList.addAll(List.generate(currentWallet.members.length, (_) => false));
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!accountExpandedList[index3]) {
                          accountExpandedList.clear();
                          accountExpandedList.addAll(List.generate(currentWallet.members.length, (_) => false));
                        }
                        accountExpandedList[index3] = !accountExpandedList[index3];
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage("assets/images/test/avatar.png"), //test, nếu chay thật thì đoạn này lấy link từ back (sử dụng NetworkImage)
                          ),
                          const SizedBox(width: 10,),
                          Text(currentWallet.members[index3]),
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
                  ),
                  const SizedBox(height: 6,),
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
                  const SizedBox(height: 14,)
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}