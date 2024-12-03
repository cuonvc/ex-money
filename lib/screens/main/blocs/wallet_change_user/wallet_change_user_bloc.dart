import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'wallet_change_user_event.dart';
part 'wallet_change_user_state.dart';

class WalletChangeUserBloc extends Bloc<WalletChangeUserEvent, WalletChangeUserState> {

  final WalletRepository walletRepository;

  WalletChangeUserBloc(this.walletRepository) : super(WalletChangeUserInitial()) {
    on<WalletChangeUserEv>((event, emit) async {
      emit(WalletChangeUserLoading());
      try {
        HttpResponse response = await walletRepository.changeUser(event.action, event.email, event.walletId);
        if (response.code == 0) {
          WalletResponse walletResponse = WalletResponse.fromMap(response.data[0]);
          emit(WalletChangeUserSuccess(response: walletResponse));
        } else {
          emit(WalletChangeUserFailure(message: response.message));
        }
      } catch (e) {
        log("Fail to change user wallet: ${e}");
        emit(WalletChangeUserFailure(message: e.toString()));
      }
    });
  }
}
