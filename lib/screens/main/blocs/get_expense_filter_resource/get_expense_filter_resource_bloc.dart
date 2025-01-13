import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_expense_filter_resource_event.dart';
part 'get_expense_filter_resource_state.dart';

class GetExpenseFilterResourceBloc extends Bloc<GetExpenseFilterResourceEvent, GetExpenseFilterResourceState> {

  final ExpenseRepository expenseRepository;

  GetExpenseFilterResourceBloc(this.expenseRepository) : super(GetExpenseFilterResourceInitial()) {
    on<GetExpenseFilterResourceEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.expenseFilterResourcePref;
      final isReload = event.isReload;

      try {
        final Object? dataCached = prefs.get(partOfPrefKey);
        if (dataCached == null || isReload) {
          emit(GetExpenseFilterResourceLoading());
          HttpResponse response = await expenseRepository.getExpenseFilterResource(event.walletId);
          if (response.code == 0) {
            ExpenseFilterResource resource = ExpenseFilterResource.fromMap(response.data[0]);
            emit(GetExpenseFilterResourceSuccess(resource));

            if (event.isCache) { //hiện tại chỉ cho phép cache khi mở app, còn khi filter không cache
              Map<String, dynamic> json = response.data[0];
              await prefs.setString(partOfPrefKey, jsonEncode(json));
            }
          } else {
            emit(GetExpenseFilterResourceFailure(response.message));
          }
        } else {
          log("Trigger expense filter resource from disk");
          Map<String, dynamic> fromDisk = jsonDecode(dataCached.toString());
          ExpenseFilterResource dataFromDisk = ExpenseFilterResource.fromMap(fromDisk);
          emit(GetExpenseFilterResourceSuccess(dataFromDisk));
        }
      } catch (e) {
        log("Get expense filter resource failure: $e");
        emit(GetExpenseFilterResourceFailure(e.toString()));
      }
    });
  }
}
