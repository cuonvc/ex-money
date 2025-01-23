import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'wallet_setting_event.dart';
part 'wallet_setting_state.dart';

class WalletSettingBloc extends Bloc<WalletSettingEvent, WalletSettingState> {

  final WalletRepository walletRepository;

  WalletSettingBloc(this.walletRepository) : super(WalletSettingInitial()) {
    on<WalletSettingEv>((event, emit) async {
      emit(WalletSettingLoading());
      try {
        HttpResponse response = await walletRepository.setting(event.walletId.toString(), event.request);
        if (response.code == 0) {
          WalletResponse wallet = WalletResponse.fromMap(response.data[0]);
          emit(WalletSettingSuccess(response: wallet));
        } else {
          emit(WalletSettingFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to change expense limit");
        emit(WalletSettingFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
