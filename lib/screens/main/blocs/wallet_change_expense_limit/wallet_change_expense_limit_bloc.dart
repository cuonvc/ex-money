import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'wallet_change_expense_limit_event.dart';
part 'wallet_change_expense_limit_state.dart';

class WalletChangeExpenseLimitBloc extends Bloc<WalletChangeExpenseLimitEvent, WalletChangeExpenseLimitState> {

  final WalletRepository walletRepository;

  WalletChangeExpenseLimitBloc(this.walletRepository) : super(WalletChangeExpenseLimitInitial()) {
    on<WalletChangeExpenseLimitEv>((event, emit) async {
      emit(WalletChangeExpenseLimitLoading());
      try {
        HttpResponse response = await walletRepository.changeExpenseLimit(event.walletId.toString(), event.amount);
        if (response.code == 0) {
          num amount = response.data[0];
          emit(WalletChangeExpenseLimitSuccess(amount: amount));
        } else {
          emit(WalletChangeExpenseLimitFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to change expense limit");
        emit(WalletChangeExpenseLimitFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
