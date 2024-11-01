import 'dart:developer';

import 'package:ex_money/screens/auth/blocs/sign_in_block/sign_in_bloc.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/utils/auth_service.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class AuthSelection extends StatefulWidget {
  const AuthSelection({super.key});

  @override
  State<AuthSelection> createState() => _AuthSelectionState();
}

class _AuthSelectionState extends State<AuthSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/logo/1.png'),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<SignInModel>(
                          builder: (BuildContext ctx) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (ctx) => SignInBloc(UserRepositoryImpl()),
                              )
                            ],
                            child: const SignIn(),
                          )
                        ),
                      );
                      Navigator.pushNamed(context, '/auth/sign_in');
                    },
                    child: buttonView(true, "Đăng nhập"),
                  ),
                  const SizedBox(height: 24,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/auth/sign_up');
                    },
                    child: buttonView(false, "Tạo tài khoản"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text("Or", style: TextStyle(color: cTextMediumBlur, fontWeight: FontWeight.w500),),
                  ),
                  authSelectionBtn(Colors.white, "Google", 14, "google", 28),
                  const SizedBox(height: 24,),
                  authSelectionBtn(Colors.white, "Github", 14, "github", 64)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget authSelectionBtn(Color color, String text, double space, String imageName, double imageScale) {
    return GestureDetector(
      onTap: () async {
        UserCredential cred = await AuthService().signInWithGoogle();
        log(cred.additionalUserInfo?.profile?['email']);
      },
      child: Container(
        height: ConstantSize.buttonHeight,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: cLineText),
          borderRadius: BorderRadius.circular(ConstantSize.borderButton),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/auth/$imageName.png', scale: imageScale,),
            SizedBox(width: space),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
