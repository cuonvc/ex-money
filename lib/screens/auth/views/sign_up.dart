import 'package:ex_money/screens/auth/blocs/active_account/active_account_bloc.dart';
import 'package:ex_money/screens/auth/views/active_account.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../widgets/button_view.dart';
import '../../../widgets/full_loading.dart';
import '../blocs/sign_in_block/sign_in_bloc.dart';
import '../blocs/sign_up/sign_up_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController passwordConfirmInput = TextEditingController();
  bool passwordVisible = true;

  SignUpModel? model;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) async {
          if (state is SignUpLoading) {
            showBlurLoading(context);
          } else if (state is SignUpSuccess) {
            String email = state.email;
            String timeLimit = state.limitTime;
            String message = state.message;

            if (model != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => BlocProvider(
                        create: (ctx) => ActiveAccountBloc(UserRepositoryImpl()),
                        child: ActiveAccount(model: model, limitTime: num.parse(timeLimit), message: message),
                      ),
                  ), (route) => false
              );
            }
          } else if (state is SignUpFailure) {
            await showDialogResponse(context, false, "Tạo tài khoản", state.message);
            Navigator.pop(context);
          }
        },
        child: Scaffold(
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset('assets/images/logo/1.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tạo tài khoản",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 18,),
                          BaseTextField(controller: emailInput, inputType: TextInputType.emailAddress, icon: Icons.email, hintText: "Nhập địa chỉ email", passwordField: false),
                          const SizedBox(height: 18,),
                          BaseTextField(controller: nameInput, inputType: TextInputType.text, icon: Icons.person, hintText: "Nhập tên của bạn", passwordField: false),
                          const SizedBox(height: 18,),
                          BaseTextField(controller: passwordInput, inputType: TextInputType.visiblePassword, icon: Icons.key, hintText: "Nhập mật khẩu", passwordField: true),
                          const SizedBox(height: 18,),
                          BaseTextField(controller: passwordConfirmInput, inputType: TextInputType.visiblePassword, icon: Icons.key, hintText: "Nhập lại mật khẩu", passwordField: true),
                          const SizedBox(height: 16,),

                          const SizedBox(height: 16,),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                model = SignUpModel(email: emailInput.text, name: nameInput.text, password: passwordInput.text, passwordConfirm: passwordConfirmInput.text);
                              });
                              if (model != null) {
                                context.read<SignUpBloc>().add(SignUpEv(model: model!));
                              }
                            },
                            child: buttonView(true, "Tạo tài khoản", null),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bạn đã có tài khoản? ",
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext ctx) => BlocProvider(
                                                create: (context) => SignInBloc(UserRepositoryImpl()),
                                                child: const SignIn(),
                                              )
                                          )
                                      );
                                    },
                                    child: const Text("Đăng nhập", style: TextStyle(color: cPrimary),),
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
      ),
    );
  }
}
