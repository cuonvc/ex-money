part of 'get_confirm_expense_from_speech_bloc.dart';

sealed class GetConfirmExpenseFromSpeechEvent extends Equatable {
  const GetConfirmExpenseFromSpeechEvent();

  @override
  List<Object> get props => [];
}

class GetConfirmExpenseFromSpeechEv extends GetConfirmExpenseFromSpeechEvent {
  final String text;

  const GetConfirmExpenseFromSpeechEv({
    required this.text
  });
}
