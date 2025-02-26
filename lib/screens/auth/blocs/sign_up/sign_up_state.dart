part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}
final class SignUpLoading extends SignUpState {}
final class SignUpFailure extends SignUpState {
  final int statusCode;
  final String message;

  const SignUpFailure({
    required this.statusCode,
    required this.message
  });
}

final class SignUpSuccess extends SignUpState {
  final String email;
  final String limitTime;
  final String message;

  const SignUpSuccess({
    required this.email,
    required this.limitTime,
    required this.message
  });
}