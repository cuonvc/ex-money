import 'dart:async';

import 'package:ex_money/screens/auth/blocs/sign_in_block/sign_in_bloc.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/full_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import '../../../widgets/otp_count_down.dart';
import '../blocs/active_account/active_account_bloc.dart';

class ActiveAccount extends StatefulWidget {
  final SignUpModel? model;
  final num limitTime; //minutes
  final String message;

  const ActiveAccount({required this.model, required this.limitTime, required this.message, super.key});

  @override
  State<ActiveAccount> createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {

  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _moveToFirstEmptyBox() {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNodes[i]);
        return;
      }
    }
    // If all boxes are filled, keep focus on the last one
    FocusScope.of(context).requestFocus(_focusNodes.last);
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    _moveToFirstEmptyBox();
  }

  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isNotEmpty) {
        _controllers[index].clear();
      } else if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        _controllers[index - 1].clear();
      }
      _moveToFirstEmptyBox();
    }
  }

  @override
  Widget build(BuildContext context) {

    double sizeOfBox = (MediaQuery.sizeOf(context).width - (2 * ConstantSize.hozPadScreen)) / 6 - 14;

    return widget.model == null ? const Center(child: Text("Error"),) : BlocListener<ActiveAccountBloc, ActiveAccountState>(
      listener: (context, state) async {
        if (state is ActiveAccountLoading) {
          showBlurLoading(context);
        } else if (state is ActiveAccountSuccess) {
          await showDialogResponse(context, true, "Kích hoạt tài khoản", state.message);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) => BlocProvider(
                  create: (context) => SignInBloc(UserRepositoryImpl()),
                  child: const SignIn(),
                )
            ), (route) => false,
          );
        } else if (state is ActiveAccountFailure) {
          await showDialogResponse(context, false, "Kích hoạt tài khoản", state.message);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
          child: ListView(
            children: [
              const SizedBox(height: 100,),
              const Text(
                "Kích hoạt tài khoản",
                style: TextStyle(
                  color: cText,
                  fontSize: 26,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 20,),
              OTPCountdown(rawMessage: widget.message, initialMinutes: widget.limitTime.toInt(), initialSeconds: 0,),
              const SizedBox(height: 40,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: sizeOfBox,
                    height: sizeOfBox,
                    child: RawKeyboardListener(
                      onKey: (event) => _onKey(event, index),
                      focusNode: FocusNode(),
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.only(top: 0, bottom: 0, left: 2, right: 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: cPrimary, width: 1),
                          ),
                        ),
                        onChanged: (value) => _onChanged(value, index),
                        onTap: _moveToFirstEmptyBox
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 100,),
              GestureDetector(
                onTap: () {
                  String activeCode = _controllers.map((number) => number.text.trim()).join();
                  context.read<ActiveAccountBloc>().add(ActiveAccountEv(model: widget.model!, activeCode: activeCode));
                },
                child: buttonView(true, "Kích hoạt", null),
              )
            ],
          ),
        ),
      ),
    );
  }
}