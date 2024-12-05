import 'package:ex_money/screens/main/blocs/wallet_change_user/wallet_change_user_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class MemberRemove extends StatelessWidget {

  final Function(WalletResponse) walletChange; //call back to member tab

  final WalletResponse currentWallet;
  final UserResponse currentMember;

  const MemberRemove({
    required this.walletChange,
    required this.currentWallet,
    required this.currentMember,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletChangeUserBloc, WalletChangeUserState>(
        listener: (context, state) {
          if (state is WalletChangeUserFailure) {
            Navigator.of(context).maybePop();
            walletChange(WalletResponse.empty());
            showDialogResponse(context, false, "Xóa thành viên", state.message);
          } else if (state is WalletChangeUserSuccess) {
            Navigator.of(context).maybePop();
            walletChange(state.response);
            showDialogResponse(context, true, "Xóa thành viên", "Đã xóa người dùng này khỏi ví ${currentWallet.name}");
          }
        },
        builder: (context, state) {
          // if (state is WalletChangeUserLoading) {
          //     return Center(child: CircularProgressIndicator());
          // }
          return GestureDetector(
            onTap: () async {
              bool confirmed = await showDialogConfirm(context, "Xóa thành viên", "Bạn chắc chắn muốn xóa tài khoản này khỏi ví?");
              if (confirmed) {
                context.read<WalletChangeUserBloc>().add(
                    WalletChangeUserEv(
                        WalletUserChange.wallet_user_change_remove,
                        currentMember.email,
                        currentWallet.id.toString()
                    )
                );
              }
            },
            child: Text("Xóa khỏi ví"),
          );
        }
    );
  }
}
