part of 'delete_wallet_bloc.dart';

sealed class DeleteWalletEvent extends Equatable {
  const DeleteWalletEvent();

  @override
  List<Object> get props => [];
}

class DeleteWalletEv extends DeleteWalletEvent {
  final num id;

  const DeleteWalletEv({
    required this.id
  });
}