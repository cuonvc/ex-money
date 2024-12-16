part of 'create_wallet_bloc.dart';

sealed class CreateWalletState extends Equatable {
  const CreateWalletState();

  @override
  List<Object> get props => [];
}

final class CreateWalletInitial extends CreateWalletState {}
final class CreateWalletLoading extends CreateWalletState {}
final class CreateWalletFailure extends CreateWalletState {
  final String message;

  const CreateWalletFailure({
    required this.message
  });
}

final class CreateWalletSuccess extends CreateWalletState {
  final WalletResponse wallet;

  const CreateWalletSuccess({
    required this.wallet
  });
}