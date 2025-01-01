import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_category_event.dart';
part 'get_category_state.dart';

class GetCategoryBloc extends Bloc<GetCategoryEvent, GetCategoryState> {

  final CategoryRepository categoryRepository;

  GetCategoryBloc(this.categoryRepository) : super(GetCategoryInitial()) {

    on<GetCategoryEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = "${CachedPrefKey.categoryListPref}${event.walletId}";
      final isReload = event.isReload;

      try {
        final Object? listCategory = prefs.get(partOfPrefKey);
        //get and transfer wallet list name to the screen
        List<Map<dynamic, dynamic>>? wallets = await getWalletList(prefs);
        if (wallets == null) {
          emit(const GetCategoryFailure("Có lỗi xảy ra, vui lòng mở lại app"));
        }

        if (listCategory == null || isReload) {
          emit(GetCategoryLoading());
          HttpResponse response = await categoryRepository.getCategoryList(event.walletId);
          if (response.code == 0) {
            List<ExpenseCategoryResponse> data = ExpenseCategoryResponse.fromList(response.data[0]);
            emit(GetCategorySuccess(data, wallets!));

            List<Map<String, dynamic>> json = ExpenseCategoryResponse.listToMap(data);
            await prefs.setString(partOfPrefKey, jsonEncode(json));
          } else {
            emit(GetCategoryFailure(response.message));
          }
        } else {
          log("Trigger get data from disk");
          List fromDisk = jsonDecode(listCategory.toString());
          List<ExpenseCategoryResponse> dataFromDisk = ExpenseCategoryResponse.fromList(fromDisk);
          emit(GetCategorySuccess(dataFromDisk, wallets!));
        }
      } catch (e) {
        log("Get category failed - $e");
        emit(GetCategoryFailure(e.toString()));
      }
    });
  }

  Future<List<Map<dynamic, dynamic>>?> getWalletList(SharedPreferencesWithCache prefs) async {
    final partOfPrefKey = CachedPrefKey.expenseFilterResourcePref;
    final Object? dataCached = prefs.get(partOfPrefKey);

    if (dataCached == null) {
      return null;
    }

    Map<String, dynamic> fromDisk = jsonDecode(dataCached.toString());
    ExpenseFilterResource dataFromDisk = ExpenseFilterResource.fromMap(fromDisk);
    return dataFromDisk.otherWalletMap;
  }
}
