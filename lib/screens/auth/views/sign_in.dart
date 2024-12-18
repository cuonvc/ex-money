import 'dart:developer';
import 'dart:ui';

import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../widgets/button_view.dart';
import '../blocs/sign_in_block/sign_in_bloc.dart';
import '../widgets/widget_base.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  bool passwordVisible = true;
  bool isLoading = false;
  late SignInModel signInModel;


  @override
  void initState() {
    super.initState();
    signInModel = SignInModel.empty();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.pushNamed(context, NavigatePath.homePath, arguments: state.data);
        } else if (state is SignInLoading) {
          setState(() {
            isLoading = true;
          });
        } else {
          log("Login faileddd");
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/logo/1.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Đăng nhập",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 18,),
                          BaseTextField(
                            controller: emailInput,
                            inputType: TextInputType.emailAddress,
                            icon: Icons.person,
                            hintText: "Nhập địa chỉ email",
                            passwordField: false,
                          ),
                          const SizedBox(height: 18,),
                          BaseTextField(
                            controller: passwordInput,
                            inputType: TextInputType.visiblePassword,
                            icon: Icons.key,
                            hintText: "Nhập mật khẩu",
                            passwordField: true,
                          ),
                          // credInputFiled(passwordInput, TextInputType.visiblePassword, true, Icons.key, "Nhập mật khẩu"),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {

                                },
                                child: const Text("Quên mật khẩu?", style: TextStyle(color: cPrimary),),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          GestureDetector(
                            onTap: () {
                              signInModel.email = emailInput.text;
                              signInModel.password = passwordInput.text;
                              context.read<SignInBloc>().add(SignInEv(signInModel));
                            },
                            child: buttonView(true, "Đăng nhập", null),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "Hoặc đăng nhập với",
                              style: TextStyle(
                                  color: cTextMediumBlur,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {

                                },
                                child: oAuthSelectionBtn(Colors.white, "Google", 14, "google", 28),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: oAuthSelectionBtn(Colors.white, "Github", 14, "github", 64),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bạn chưa có tài khoản? ",
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, NavigatePath.signUpPath);
                                    },
                                    child: const Text("Đăng ký", style: TextStyle(color: cPrimary),),
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
