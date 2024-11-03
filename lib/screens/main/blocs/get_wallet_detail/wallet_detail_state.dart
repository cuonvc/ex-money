part of 'wallet_detail_bloc.dart';

sealed class WalletDetailState extends Equatable {
  const WalletDetailState();
  List<Object?> get props => [];
}

final class WalletDetailInitial extends WalletDetailState {}
final class WalletDetailLoading extends WalletDetailState {}
final class WalletDetailFailure extends WalletDetailState {}
final class WalletDetailSuccess extends WalletDetailState {
  final List data;
  const WalletDetailSuccess(this.data);

  @override
  List<Object?> get props => data;
}
