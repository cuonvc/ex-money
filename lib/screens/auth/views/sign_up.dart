import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/button_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    Navigator.pushNamed(context, '/auth/sign_in');
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
    );
  }
}
