part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInEv extends SignInEvent {
  final SignInModel signInModel;

  const SignInEv(this.signInModel);

  @override
  List<Object?> get props => [signInModel];
}
