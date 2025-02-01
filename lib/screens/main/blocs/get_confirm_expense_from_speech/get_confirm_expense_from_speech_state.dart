part of 'get_confirm_expense_from_speech_bloc.dart';

sealed class GetConfirmExpenseFromSpeechState extends Equatable {
  const GetConfirmExpenseFromSpeechState();

  @override
  List<Object> get props => [];
}

final class GetConfirmExpenseFromSpeechInitial extends GetConfirmExpenseFromSpeechState {}
final class GetConfirmExpenseFromSpeechLoading extends GetConfirmExpenseFromSpeechState {}
final class GetConfirmExpenseFromSpeechFailure extends GetConfirmExpenseFromSpeechState {
  final String message;

  const GetConfirmExpenseFromSpeechFailure({
    required this.message
  });
}

final class GetConfirmExpenseFromSpeechSuccess extends GetConfirmExpenseFromSpeechState {
  final String message;
  final ExpenseConfirmResponse response;

  const GetConfirmExpenseFromSpeechSuccess({
    required this.message,
    required this.response
  });
}