part of 'password_change_bloc.dart';

sealed class PasswordChangeState extends Equatable {
  const PasswordChangeState();

  @override
  List<Object> get props => [];
}

final class PasswordChangeInitial extends PasswordChangeState {}
final class PasswordChangeLoading extends PasswordChangeState {}
final class PasswordChangeFailure extends PasswordChangeState {
  final int statusCode;
  final String message;

  const PasswordChangeFailure({
    required this.statusCode,
    required this.message
  });
}

final class PasswordChangeSuccess extends PasswordChangeState {
  final String message;

  const PasswordChangeSuccess({
    required this.message
  });
}