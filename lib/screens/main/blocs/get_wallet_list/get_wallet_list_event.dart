part of 'get_wallet_list_bloc.dart';

sealed class GetWalletListEvent extends Equatable {
  const GetWalletListEvent();

  @override
  List<Object?> get props => [];
}

class GetWalletListEv extends GetWalletListEvent {
  late List<WalletResponse?> wallets;

  @override
  List<Object?> get props => wallets;
}