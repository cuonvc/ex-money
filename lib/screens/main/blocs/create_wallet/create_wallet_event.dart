part of 'create_wallet_bloc.dart';

sealed class CreateWalletEvent extends Equatable {
  const CreateWalletEvent();

  @override
  List<Object> get props => [];
}

class CreateWalletEv extends CreateWalletEvent {
  final String name;
  final String description;

  const CreateWalletEv(this.name, this.description);
}