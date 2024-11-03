import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'wallet_detail_event.dart';
part 'wallet_detail_state.dart';

class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {

  final WalletRepository walletRepository;

  WalletDetailBloc(this.walletRepository) : super(WalletDetailInitial()) {
    on<WalletDetailEv>((event, emit) async {
      emit(WalletDetailLoading());
      try {
        List data = await walletRepository.getWalletDetail(event.walletId);
        emit(WalletDetailSuccess(data));
      } catch (e) {
        log("Get Expense failed: $e");
        emit(WalletDetailFailure());
      }
    });
  }
}
