part of 'wallet_change_user_bloc.dart';

sealed class WalletChangeUserEvent extends Equatable {
  const WalletChangeUserEvent();

  @override
  List<Object> get props => [];
}

class WalletChangeUserEv extends WalletChangeUserEvent {
  final String action;
  final String email;
  final String walletId;

  const WalletChangeUserEv(this.action, this.email, this.walletId);
}
