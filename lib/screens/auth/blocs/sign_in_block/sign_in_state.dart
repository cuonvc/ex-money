part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}
final class SignInFailure extends SignInState {}
final class SignInLoading extends SignInState {}
final class SignInSuccess extends SignInState {
  final List data;
  const SignInSuccess(this.data);

  @override
  List<Object?> get props => data;
}
