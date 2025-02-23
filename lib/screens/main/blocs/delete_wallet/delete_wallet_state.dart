part of 'delete_wallet_bloc.dart';

sealed class DeleteWalletState extends Equatable {
  const DeleteWalletState();

  @override
  List<Object> get props => [];
}

final class DeleteWalletInitial extends DeleteWalletState {}
final class DeleteWalletLoading extends DeleteWalletState {}
final class DeleteWalletFailure extends DeleteWalletState {
  final String message;

  const DeleteWalletFailure({
    required this.message
  });
}
final class DeleteWalletSuccess extends DeleteWalletState {
  final String message;

  const DeleteWalletSuccess({
    required this.message
  });
}