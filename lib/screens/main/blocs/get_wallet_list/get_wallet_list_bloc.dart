import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_wallet_list_event.dart';
part 'get_wallet_list_state.dart';

class GetWalletListBloc extends Bloc<GetWalletListEvent, GetWalletListState> {
  final WalletRepository walletRepository;

  GetWalletListBloc(this.walletRepository) : super(GetWalletListInitial()) {
    on<GetWalletListEv>(_getWalletData);
    on<UpdateCurrentWalletEv>(_updateCurrentWallet);
  }

  FutureOr<void> _getWalletData(event, emit) async {
    emit(GetWalletListLoading());
    try {
      List data = await walletRepository.getWalletList();
      List rawData = data[0];
      var walletList =
          rawData.map((wallet) => WalletResponse.fromMap(wallet)).toList();
      emit(GetWalletListSuccess(
        walletList,
      ));
    } catch (e) {
      log("Get home overview failed: $e");
      emit(GetWalletListFailure());
    }
  }

  FutureOr<void> _updateCurrentWallet(
      UpdateCurrentWalletEv event, Emitter<GetWalletListState> emit) {
    if (state is GetWalletListSuccess) {
      var list = (state as GetWalletListSuccess).listWallet;
      list[event.index] = event.walletResponse;
      emit(
        GetWalletListSuccess(
          list,
        ),
      );
    }
  }
}
