import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_wallet_list_event.dart';
part 'get_wallet_list_state.dart';

class GetWalletListBloc extends Bloc<GetWalletListEvent, GetWalletListState> {

  final WalletRepository walletRepository;

  GetWalletListBloc(this.walletRepository) : super(GetWalletListInitial()) {
    on<GetWalletListEv>((event, emit) async {
      emit(GetWalletListLoading());
      try {
        List data = await walletRepository.getWalletList();
        emit(GetWalletListSuccess(data));
      } catch (e) {
        log("Get home overview failed: $e");
        emit(GetWalletListFailure());
      }
    });
  }
}
