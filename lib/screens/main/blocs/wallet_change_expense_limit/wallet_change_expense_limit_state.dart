part of 'wallet_change_expense_limit_bloc.dart';

sealed class WalletChangeExpenseLimitState extends Equatable {
  const WalletChangeExpenseLimitState();

  @override
  List<Object> get props => [];
}

final class WalletChangeExpenseLimitInitial extends WalletChangeExpenseLimitState {}
final class WalletChangeExpenseLimitLoading extends WalletChangeExpenseLimitState {}
final class WalletChangeExpenseLimitFailure extends WalletChangeExpenseLimitState {
  final String message;

  const WalletChangeExpenseLimitFailure({
    required this.message
  });
}

final class WalletChangeExpenseLimitSuccess extends WalletChangeExpenseLimitState {
  final num amount;

  const WalletChangeExpenseLimitSuccess({
    required this.amount
  });
}