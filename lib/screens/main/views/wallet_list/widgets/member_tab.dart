import 'package:ex_money/screens/main/views/wallet_list/widgets/member_remove.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../../../utils/constant.dart';
import '../../../blocs/wallet_change_user/wallet_change_user_bloc.dart';
import 'add_user_to_wallet.dart';

class MemberTab extends StatefulWidget {
  final ScrollController scrollController;
  final WalletResponse wallet;
  const MemberTab(this.scrollController, this.wallet, {super.key});

  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {

  late WalletResponse currentWallet;
  final accountExpandedList = [];
  WalletResponse? afterMemberRemoved;

  void handleMessage(WalletResponse walletChanged) {
    if (walletChanged.id != 0) {
      setState(() {
        currentWallet = walletChanged; // Update the state with the received message
      });
    }
  }


  @override
  void initState() {
    currentWallet = widget.wallet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = currentWallet.currentUserId == currentWallet.ownerUserId;
    return BlocProvider(
      create: (_) => WalletChangeUserBloc(WalletRepositoryImpl()),
      child: Column(
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
                child: Visibility(
                  visible: isOwner,
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: cPrimary,),
                      Text("Thêm thành viên", style: TextStyle(color: cPrimary),)
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: currentWallet.members.length + 2,
              itemBuilder: (context3, index3) {
                if (index3 >= currentWallet.members.length) {
                  return Container(
                    height: ConstantSize.heightBottomBar + 50,
                    color: Colors.transparent,
                  );
                }
                accountExpandedList.addAll(List.generate(currentWallet.members.length, (_) => false));
                UserResponse currentMember = currentWallet.members[index3];
                bool currentIsOwner = currentMember.id == currentWallet.ownerUserId;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!currentIsOwner) {
                          setState(() {
                            if (!accountExpandedList[index3]) {
                              accountExpandedList.clear();
                              accountExpandedList.addAll(List.generate(currentWallet.members.length, (_) => false));
                            }
                            accountExpandedList[index3] = !accountExpandedList[index3];
                          });
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: currentMember.avatarUrl != null ? NetworkImage(currentMember.avatarUrl!) : const AssetImage('assets/images/profile/avt.png'),
                            ),
                            const SizedBox(width: 10,),
                            Text(currentMember.name),
                            !currentIsOwner ? (
                                isOwner ? AnimatedRotation(
                                    turns: accountExpandedList[index3] ? 0.75 : 0.5,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.grey,
                                      size: 26,
                                    )
                                ) : const Text("")
                            ) : Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(width: 1, color: cPrimary)
                                ),
                                child: const Text("Chủ sở hữu", style: TextStyle(fontSize: 10),),
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
                          visible: accountExpandedList[index3] && !currentIsOwner && isOwner,
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
                                MemberRemove(currentWallet: currentWallet, currentMember: currentMember, walletChange: handleMessage,),
                                // BlocConsumer<WalletChangeUserBloc, WalletChangeUserState>(
                                //     listener: (context, state) {
                                //       if (state is WalletChangeUserSuccess) {
                                //         showDialog(
                                //             context: context,
                                //             builder: (_) => AlertDialog(
                                //             title: Text("Success"),
                                //             content: Text("OK"),
                                //             actions: [
                                //               TextButton(
                                //                 onPressed: () => Navigator.pop(context),
                                //                 child: Text("OK"),
                                //               ),
                                //             ],
                                //           ),
                                //         );
                                //       } else if (state is WalletChangeUserFailure) {
                                //         showDialog(
                                //           context: context,
                                //           builder: (_) => AlertDialog(
                                //             title: Text("Error"),
                                //             content: Text("FAILED"),
                                //             actions: [
                                //               TextButton(
                                //                 onPressed: () => Navigator.pop(context),
                                //                 child: Text("OK"),
                                //               ),
                                //             ],
                                //           ),
                                //         );
                                //       }
                                //     },
                                //     builder: (context, state) {
                                //       // if (state is WalletChangeUserLoading) {
                                //       //     return Center(child: CircularProgressIndicator());
                                //       // }
                                //       return GestureDetector(
                                //         onTap: () async {
                                //           bool confirmed = await showDialogConfirm(context, "Xóa thành viên", "Bạn chắc chắn muốn xóa tài khoản này khỏi ví?");
                                //           if (confirmed) {
                                //             context3.read<WalletChangeUserBloc>().add(
                                //                 WalletChangeUserEv(
                                //                     WalletUserChange.wallet_user_change_remove,
                                //                     currentMember.email,
                                //                     currentWallet.id.toString()
                                //                 )
                                //             );
                                //           }
                                //         },
                                //         child: Text("Xóa khỏi ví"),
                                //       );
                                //     }
                                // ),
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
      ),
    );
  }
}