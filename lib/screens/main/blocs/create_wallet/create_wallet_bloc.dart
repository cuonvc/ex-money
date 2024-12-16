import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'create_wallet_event.dart';
part 'create_wallet_state.dart';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {

  final WalletRepository walletRepository;

  CreateWalletBloc(this.walletRepository) : super(CreateWalletInitial()) {
    on<CreateWalletEv>((event, emit) async {
      emit(CreateWalletLoading());
      try {
        HttpResponse response = await walletRepository.createWallet(event.name, event.description);
        if (response.code == 0) {
          WalletResponse wallet = WalletResponse.fromMap(response.data[0]);
          emit(CreateWalletSuccess(wallet: wallet));
        } else {
          emit(CreateWalletFailure(message: response.message));
        }
      } catch (e) {
        log("Faild to create wallet - ${e.toString()}");
        emit(CreateWalletFailure(message: e.toString()));
      }
    });
  }
}
