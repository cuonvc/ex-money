import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'create_wallet_event.dart';
part 'create_wallet_state.dart';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {

  final WalletRepository walletRepository;

  CreateWalletBloc(this.walletRepository) : super(CreateWalletInitial()) {
    on<CreateWalletEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKeyWallet = CachedPrefKey.walletListPref;
      final partOfPrefKeyExpenseEditRs = CachedPrefKey.expenseEditResourcePref;
      final partOfPrefKeyExpenseFilterRs = CachedPrefKey.expenseFilterResourcePref;

      emit(CreateWalletLoading());
      try {
        HttpResponse response = await walletRepository.createWallet(event.name, event.description);
        if (response.code == 0) {
          // Map<String, dynamic> walletCreated = response.data[0];
          // final Object? walletListCached = prefs.get(partOfPrefKeyWallet);
          // final Object? expEditRsCached = prefs.get(partOfPrefKeyExpenseEditRs);
          // final Object? expFilterRsCached = prefs.get(partOfPrefKeyExpenseFilterRs);
          //
          // if (walletListCached == null) {
          //   await prefs.setString(partOfPrefKeyWallet, jsonEncode([walletCreated]));
          // } else if (walletListCached is List) {
          //   walletListCached.add(walletCreated);
          //   await prefs.setString(partOfPrefKeyWallet, jsonEncode(walletListCached));
          // } else {
          //   emit(const CreateWalletFailure(message: "Có lỗi khi đồng bộ ví, vui lòng mở lại app"));
          // }
          //
          // if (expEditRsCached is Map<String, dynamic>) {
          //   List<Map<dynamic, dynamic>> otherWalletMap = expEditRsCached['otherWalletMap'];
          //   otherWalletMap.add(MapEntry('id', walletCreated['id']) as Map);
          //   expEditRsCached['otherWalletMap'] = otherWalletMap;
          //   await prefs.setString(partOfPrefKeyExpenseEditRs, jsonEncode(expEditRsCached));
          // } else {
          //   emit(const CreateWalletFailure(message: "Có lỗi khi đồng bộ ví, vui lòng mở lại app"));
          // }

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
