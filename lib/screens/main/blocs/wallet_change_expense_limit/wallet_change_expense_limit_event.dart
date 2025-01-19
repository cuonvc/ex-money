part of 'wallet_change_expense_limit_bloc.dart';

sealed class WalletChangeExpenseLimitEvent extends Equatable {
  const WalletChangeExpenseLimitEvent();

  @override
  List<Object> get props => [];
}

class WalletChangeExpenseLimitEv extends WalletChangeExpenseLimitEvent {
  final num walletId;
  final num amount;

  const WalletChangeExpenseLimitEv({
    required this.walletId,
    required this.amount
  });
}
