part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}
final class SignInFailure extends SignInState {
  final int statusCode;
  final String message;

  const SignInFailure({
    required this.statusCode,
    required this.message
  });
}
final class SignInLoading extends SignInState {}
final class SignInSuccess extends SignInState {
  final SignInResponse response;

  const SignInSuccess({
    required this.response
  });
}
