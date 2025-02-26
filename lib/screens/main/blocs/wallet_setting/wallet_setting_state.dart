part of 'wallet_setting_bloc.dart';

sealed class WalletSettingState extends Equatable {
  const WalletSettingState();

  @override
  List<Object> get props => [];
}

final class WalletSettingInitial extends WalletSettingState {}
final class WalletSettingLoading extends WalletSettingState {}
final class WalletSettingFailure extends WalletSettingState {
  final int statusCode;
  final String message;

  const WalletSettingFailure({
    required this.statusCode,
    required this.message
  });
}

final class WalletSettingSuccess extends WalletSettingState {
  final WalletResponse response;

  const WalletSettingSuccess({
    required this.response
  });
}