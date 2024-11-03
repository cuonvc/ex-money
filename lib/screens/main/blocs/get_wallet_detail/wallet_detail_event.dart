part of 'wallet_detail_bloc.dart';

sealed class WalletDetailEvent extends Equatable {
  const WalletDetailEvent();

  @override
  List<Object?> get props => [];
}

class WalletDetailEv extends WalletDetailEvent {
  WalletDetailResponse? response;
  String walletId;

  WalletDetailEv(this.walletId);

  @override
  List<Object?> get props => [response];
}
