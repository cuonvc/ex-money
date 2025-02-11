import 'package:ex_money/screens/auth/blocs/password_change/password_change_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();

  bool isLoading = false;

  void onBackScreen(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordChangeBloc, PasswordChangeState>(
  listener: (context, state) {
    if (state is PasswordChangeLoading || state is PasswordChangeInitial) {
      setState(() {
        isLoading = true;
      });
    } else if (state is PasswordChangeSuccess) {
      setState(() {
        isLoading = false;
      });
      oldPasswordController.clear();
      newPasswordController.clear();
      newPasswordConfirmController.clear();
      showDialogResponse(context, true, "Thay đổi mật khẩu", state.message);
    } else if (state is PasswordChangeFailure) {
      setState(() {
        isLoading = false;
      });
      showDialogResponse(context, false, "Thay đổi mật khẩu", state.message);
    }
  },
  child: PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          onBackScreen(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Thay đổi mật khẩu",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
          centerTitle: true,
          leading: ModalRoute.of(context)!.canPop
              ? IconButton(onPressed: () => onBackScreen(context),
              icon: const Icon(Icons.arrow_back_ios_new))
              : null,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
          child: ListView(
            children: [
              const SizedBox(height: 20,),
              BaseTextField(controller: oldPasswordController, inputType: TextInputType.text, icon: null, hintText: "Mật khẩu hiện tại", passwordField: true),
              const SizedBox(height: 26,),
              BaseTextField(controller: newPasswordController, inputType: TextInputType.text, icon: null, hintText: "Mật khẩu mới", passwordField: true),
              const SizedBox(height: 26,),
              BaseTextField(controller: newPasswordConfirmController, inputType: TextInputType.text, icon: null, hintText: "Nhập lại mật khẩu mới", passwordField: true),
              const SizedBox(height: 40,),
              const Text("Quên mật khẩu? chưa làm", style: TextStyle(color: cPrimary),),
              const SizedBox(height: 40,),
              isLoading ? buttonLoading(true, null) : GestureDetector(
                onTap: () {
                  context.read<PasswordChangeBloc>().add(
                      PasswordChangeEv(
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                          confirmPassword: newPasswordConfirmController.text
                      )
                  );
                },
                child: buttonView(true, "Đặt lại mật khẩu", null),
              )
            ],
          ),
        ),
      ),
    ),
);
  }
}
