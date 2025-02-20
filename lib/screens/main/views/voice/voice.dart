import 'dart:developer';

import 'package:ex_money/screens/main/blocs/add_expense/add_expense_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_confirm_expense_from_speech/get_confirm_expense_from_speech_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense_edit_resource/get_expense_edit_resource_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/expense_edit.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voice extends StatefulWidget {
  final Function(ExpenseResponse) onExpenseAdd;
  const Voice({super.key, required this.onExpenseAdd});

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {

  String displayText = "";
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  bool isFinalResult = false;
  ExpenseConfirmResponse? expenseConfirm;

  // void checkMic() async {
  //   bool micAvailable = await speechToText.initialize();
  //
  //   if (micAvailable) {
  //     log("Micro available");
  //   } else {
  //     log("Micro access denied");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // checkMic();
    displayText = "";
    expenseConfirm = null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetConfirmExpenseFromSpeechBloc(ExpenseRepositoryImpl()),
        ),
        BlocProvider(
          create: (ctx) => AddExpenseBloc(ExpenseRepositoryImpl()),
        ),
      ],
      child: BlocBuilder<GetExpenseEditResourceBloc, GetExpenseEditResourceState>(
        builder: (context, state) {
          if (state is GetExpenseEditResourceSuccess) {
            final expenseResource = state.resource;
            return BlocListener<GetConfirmExpenseFromSpeechBloc, GetConfirmExpenseFromSpeechState>(
              listener: (context, state) async {
                if (state is GetConfirmExpenseFromSpeechSuccess) {
                  setState(() {
                    expenseConfirm = state.response;
                  });
                  if (isFinalResult && expenseConfirm != null) {
                    ExpenseResponse? newExpense = await showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return BlocProvider(
                            create: (ctx) => AddExpenseBloc(ExpenseRepositoryImpl()),
                            child: ExpenseEdit(resource: expenseResource, confirmFromSpeech: expenseConfirm, ),
                          );
                        }
                    );

                    if (newExpense != null) {
                      widget.onExpenseAdd(newExpense);
                    }
                  }
                } else if (state is GetConfirmExpenseFromSpeechFailure) {
                  showDialogResponse(context, false, "Có lỗi xảy ra", "Không thể trích xuất thông tin");
                }
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text(
                    "Thêm chi tiêu với giọng nói",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!isListening) {
                            bool micAvailable = await speechToText.initialize();

                            if (micAvailable) {
                              setState(() {
                                isListening = true;
                              });

                              speechToText.listen(
                                listenFor: const Duration(seconds: 5),
                                localeId: 'vi_VN',
                                onResult: (result) async {
                                  setState(() {
                                    displayText = result.recognizedWords;
                                    // isListening = false;
                                  });

                                  if (result.finalResult) {
                                    setState(() {
                                      displayText = result.recognizedWords; // Intermediate results
                                      isListening = false;
                                      isFinalResult = true;
                                    });

                                    log("The final text: $displayText");
                                    context.read<GetConfirmExpenseFromSpeechBloc>().add(GetConfirmExpenseFromSpeechEv(text: displayText));
                                  }
                                },
                              );
                            }
                          } else {
                            setState(() {
                              isListening = false;
                              speechToText.stop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: cBlurPrimary,
                          radius: 38,
                          child: isListening
                              ? Image.asset(
                            'assets/images/animation/speaking.gif', scale: 0.5,)
                              : const Icon(Icons.mic, size: 30,),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(displayText.isNotEmpty ? displayText : "Nhấn để nói"),
                      const SizedBox(height: 40,),
                      Visibility(
                        visible: isListening,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isListening = false;
                              displayText = "";
                              speechToText.stop();
                            });
                          },
                          child: const CircleAvatar(
                            child: Icon(Icons.clear),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is GetExpenseEditResourceLoading || state is GetExpenseEditResourceInitial) {
            return const Center(child: Loading(loadingColor: null,),);
          } else {
            // showDialogResponse(context, false, "Có lỗi xảy ra", "Không thể lấy thông tin");
            return const Scaffold(
              body: Center(child: Text("Không thể lấy thông tin"),),
            );
          }
        },
      )
    );
  }
}
