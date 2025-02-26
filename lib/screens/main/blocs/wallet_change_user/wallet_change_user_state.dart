part of 'wallet_change_user_bloc.dart';

sealed class WalletChangeUserState extends Equatable {
  const WalletChangeUserState();

  @override
  List<Object> get props => [];
}

final class WalletChangeUserInitial extends WalletChangeUserState {}
final class WalletChangeUserLoading extends WalletChangeUserState {}
final class WalletChangeUserFailure extends WalletChangeUserState {
  final int statusCode;
  final String message;

  const WalletChangeUserFailure({
    required this.statusCode,
    required this.message
  });
}
final class WalletChangeUserSuccess extends WalletChangeUserState {
  final WalletResponse response;
  const WalletChangeUserSuccess({required this.response});
}
