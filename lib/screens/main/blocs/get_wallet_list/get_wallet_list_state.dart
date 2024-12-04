part of 'get_wallet_list_bloc.dart';

sealed class GetWalletListState extends Equatable {
  const GetWalletListState();

  @override
  List<Object?> get props => [];
}

final class GetWalletListInitial extends GetWalletListState {}
final class GetWalletListLoading extends GetWalletListState {}
final class GetWalletListFailure extends GetWalletListState {
  final String message;

  const GetWalletListFailure(this.message);
}
final class GetWalletListSuccess extends GetWalletListState {
  final List<WalletResponse> walletList;

  const GetWalletListSuccess(this.walletList);
}
