part of 'account_setting_bloc.dart';

sealed class AccountSettingState extends Equatable {
  const AccountSettingState();

  @override
  List<Object> get props => [];
}

final class AccountSettingInitial extends AccountSettingState {}
final class AccountSettingLoading extends AccountSettingState {}
final class AccountSettingFailure extends AccountSettingState {
  final int statusCode;
  final String message;

  const AccountSettingFailure({
    required this.statusCode,
    required this.message
  });
}

final class AccountSettingSuccess extends AccountSettingState {
  final UserResponse data;

  const AccountSettingSuccess({
    required this.data
  });
}
