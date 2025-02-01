import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_confirm_expense_from_speech/get_confirm_expense_from_speech_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voice extends StatefulWidget {
  const Voice({super.key});

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {

  String displayText = "";
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetConfirmExpenseFromSpeechBloc(ExpenseRepositoryImpl()),
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
                          onResult: (result) {
                            setState(() {
                              displayText = result.recognizedWords;
                              // isListening = false;
                            });

                            if (result.finalResult) {
                              setState(() {
                                displayText = result.recognizedWords; // Intermediate results
                                isListening = false;
                                log("The final text: $displayText");
                                //submit to server
                              });
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
                      ? Image.asset('assets/images/animation/speaking.gif', scale: 0.5,)
                      : const Icon(Icons.mic, size: 30,),
                ),
              ),
              const SizedBox(height: 10,),
              Text(displayText.isNotEmpty ? displayText : "Nhấn để nói"),
              const SizedBox(height: 40,),
              Visibility(
                visible: /*displayText.isNotEmpty || */ isListening,
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
  }
}
