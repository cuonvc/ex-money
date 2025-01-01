import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_expense_edit_resource_event.dart';
part 'get_expense_edit_resource_state.dart';

class GetExpenseEditResourceBloc extends Bloc<GetExpenseEditResourceEvent, GetExpenseEditResourceState> {

  final ExpenseRepository expenseRepository;

  GetExpenseEditResourceBloc(this.expenseRepository) : super(GetExpenseEditResourceInitial()) {
    on<GetExpenseEditResourceEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.expenseEditResourcePref;
      final isReload = event.isReload;

      try {
        final Object? dataCached = prefs.get(partOfPrefKey);
        if (dataCached == null || isReload) {
          emit(GetExpenseEditResourceLoading());
          HttpResponse response = await expenseRepository.getExpenseEditResource(event.walletId);
          if (response.code == 0) {
            ExpenseEditResource resource = ExpenseEditResource.fromMap(response.data[0]);
            emit(GetExpenseEditResourceSuccess(resource));

            Map<String, dynamic> json = response.data[0];
            await prefs.setString(partOfPrefKey, jsonEncode(json));
          } else {
            emit(GetExpenseEditResourceFailure(response.message));
          }
        } else {
          log("Trigger expense edit resource from disk");
          Map<String, dynamic> fromDisk = jsonDecode(dataCached.toString());
          ExpenseEditResource dataFromDisk = ExpenseEditResource.fromMap(fromDisk);
          emit(GetExpenseEditResourceSuccess(dataFromDisk));
        }
      } catch (e) {
        log("Get expense resource for edit failure: $e");
        emit(GetExpenseEditResourceFailure(e.toString()));
      }
    });
  }
}
