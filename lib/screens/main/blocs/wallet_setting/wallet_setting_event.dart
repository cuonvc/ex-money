part of 'wallet_setting_bloc.dart';

sealed class WalletSettingEvent extends Equatable {
  const WalletSettingEvent();

  @override
  List<Object> get props => [];
}

class WalletSettingEv extends WalletSettingEvent {
  final num walletId;
  final WalletSettingRequest request;

  const WalletSettingEv({
    required this.walletId,
    required this.request
  });
}
