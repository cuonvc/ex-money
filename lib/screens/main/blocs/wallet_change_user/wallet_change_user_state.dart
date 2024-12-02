part of 'wallet_change_user_bloc.dart';

sealed class WalletChangeUserState extends Equatable {
  const WalletChangeUserState();

  @override
  List<Object> get props => [];
}

final class WalletChangeUserInitial extends WalletChangeUserState {}
final class WalletChangeUserLoading extends WalletChangeUserState {}
final class WalletChangeUserFailure extends WalletChangeUserState {
  final String message;
  const WalletChangeUserFailure({required this.message});

  @override
  List<Object> get props => [message];
}
final class WalletChangeUserSuccess extends WalletChangeUserState {
  final WalletResponse response;
  const WalletChangeUserSuccess({required this.response});

  @override
  List<Object> get props => [response];
}
