import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'delete_wallet_event.dart';
part 'delete_wallet_state.dart';

class DeleteWalletBloc extends Bloc<DeleteWalletEvent, DeleteWalletState> {

  final WalletRepository walletRepository;

  DeleteWalletBloc(this.walletRepository) : super(DeleteWalletInitial()) {
    on<DeleteWalletEv>((event, emit) async {
      emit(DeleteWalletLoading());
      try {
        HttpResponse response = await walletRepository.deleteWallet(event.id);
        if (response.code == 0) {
          emit(DeleteWalletSuccess(message: response.message));
        } else {
          emit(DeleteWalletFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to delete note");
        emit(DeleteWalletFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
