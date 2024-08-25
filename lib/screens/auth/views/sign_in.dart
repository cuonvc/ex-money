import 'dart:ui';

import 'package:ex_money/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/button_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Size.hozPadScreen),
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
                  credInputFiled(emailInput, TextInputType.emailAddress, false, Icons.person, "Nhập địa chỉ email"),
                  const SizedBox(height: 18,),
                  credInputFiled(passwordInput, TextInputType.visiblePassword, true, Icons.key, "Nhập mật khẩu"),
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

                    },
                    child: buttonView(true, "Đăng nhập"),
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
                            Navigator.pushNamed(context, '/auth/sign_up');
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
      ),
    );
  }

  TextFormField credInputFiled(TextEditingController controller, TextInputType inputType, bool passwordField, IconData icon, String hintText) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: passwordField ? passwordVisible : false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: cLineText, width: 1),
              borderRadius: BorderRadius.circular(Size.borderButton)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: cLineText),
              borderRadius: BorderRadius.circular(Size.borderButton)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: Icon(
            icon,
            size: 26,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400
          ),
          // filled: true,
          fillColor: Colors.white,
          suffixIcon: passwordField ?
          IconButton(
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          ) : null
      ),
    );
  }
}
