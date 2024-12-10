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
        HttpResponse response = await walletRepository.getWalletList();
        if (response.code == 0) {
          List dataList = response.data[0];
          List<WalletResponse> list = dataList.map((wallet) => WalletResponse.fromMap(wallet)).toList();
          emit(GetWalletListSuccess(list));
        }
      } catch (e) {
        log("Get wallet list failed: $e");
        emit(GetWalletListFailure(e.toString()));
      }
    });
  }
}
