import 'package:ex_money/screens/main/blocs/wallet_change_user/wallet_change_user_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserToWallet extends StatefulWidget {
  String walletId;

  AddUserToWallet({super.key, required this.walletId});

  @override
  State<AddUserToWallet> createState() => _AddUserToWalletState();
}

class _AddUserToWalletState extends State<AddUserToWallet> {

  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletIdData = widget.walletId;
    return BlocListener<WalletChangeUserBloc, WalletChangeUserState>(
      listener: (context, state) {
        if (state is WalletChangeUserLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is WalletChangeUserSuccess) {
          Navigator.pop(context, state.response);
          showDialogResponse(context, true, "Thêm thành viên", "Đã gửi yêu cầu");
        } else if (state is WalletChangeUserFailure) {
          String message = state.message;
          Navigator.pop(context, null);
          showDialogResponse(context, true, "Thêm thành viên", message);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: (2/3) * MediaQuery.sizeOf(context).height
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_arrow_down, color: cDisableBtn, size: 30,)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Thêm người dùng vào ví",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: baseInputTextField(controller, TextInputType.emailAddress, null, "Nhập email người dùng"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GestureDetector(
                    onTap: () {
                      context.read<WalletChangeUserBloc>().add(
                          WalletChangeUserEv(WalletUserChange.wallet_user_change_add, controller.text, walletIdData)
                      );
                    },
                    child: isLoading
                        ? buttonLoading(true, Colors.white)
                        : buttonView(true, "Gửi yêu cầu", Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
