import 'package:ex_money/utils/constant.dart';
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
                        "Tạo tài khoản",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 18,),
                  credInputFiled(emailInput, TextInputType.emailAddress, false, Icons.email, "Nhập địa chỉ email"),
                  const SizedBox(height: 18,),
                  credInputFiled(nameInput, TextInputType.text, false, Icons.person, "Nhập tên của bạn"),
                  const SizedBox(height: 18,),
                  credInputFiled(passwordInput, TextInputType.visiblePassword, true, Icons.key, "Nhập mật khẩu"),
                  const SizedBox(height: 18,),
                  credInputFiled(passwordConfirmInput, TextInputType.visiblePassword, true, Icons.key, "Nhập lại mật khẩu"),
                  const SizedBox(height: 16,),

                  const SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () {

                    },
                    child: buttonView(true, "Tạo tài khoản"),
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
