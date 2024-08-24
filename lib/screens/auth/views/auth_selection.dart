import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: Size.hozPadScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/logo/1.png'),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
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
                    child: Text("Or", style: TextStyle(color: cText, fontWeight: FontWeight.w500),),
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
      onTap: () {

      },
      child: Container(
        height: Size.buttonHeight,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: cLineText),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
