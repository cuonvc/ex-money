part of 'password_change_bloc.dart';

sealed class PasswordChangeEvent extends Equatable {
  const PasswordChangeEvent();

  @override
  List<Object> get props => [];
}

class PasswordChangeEv extends PasswordChangeEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const PasswordChangeEv({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}