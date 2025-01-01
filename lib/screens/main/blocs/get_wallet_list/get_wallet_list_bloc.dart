import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_wallet_list_event.dart';
part 'get_wallet_list_state.dart';

class GetWalletListBloc extends Bloc<GetWalletListEvent, GetWalletListState> {

  final WalletRepository walletRepository;

  GetWalletListBloc(this.walletRepository) : super(GetWalletListInitial()) {
    on<GetWalletListEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.walletListPref;
      final isReload = event.isReload;

      try {
        final Object? listCached = prefs.get(partOfPrefKey);
        if (listCached == null || isReload) {
          emit(GetWalletListLoading());
          HttpResponse response = await walletRepository.getWalletList();
          if (response.code == 0) {
            List dataList = response.data[0];
            List<WalletResponse> list = dataList.map((wallet) => WalletResponse.fromMap(wallet)).toList();
            emit(GetWalletListSuccess(list));

            List json = dataList;
            await prefs.setString(partOfPrefKey, jsonEncode(json));
          } else {
            emit(GetWalletListFailure(response.message));
          }
        } else {
          log("Trigger wallet list from disk");
          List fromDisk = jsonDecode(listCached.toString());
          List<WalletResponse> dataFromDisk = fromDisk.map((w) => WalletResponse.fromMap(w)).toList();
          emit(GetWalletListSuccess(dataFromDisk));
        }
      } catch (e) {
        log("Get home overview failed: $e");
        emit(GetWalletListFailure(e.toString()));
      }
    });
  }
}
