import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_overview_event.dart';
part 'home_overview_state.dart';

class HomeOverviewBloc extends Bloc<HomeOverViewEvent, HomeOverviewState> {

  final OverviewRepository overviewRepository;

  HomeOverviewBloc(this.overviewRepository) : super(HomeOverviewInitial()) {
    on<HomeOverViewEv>((event, emit) async {
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.homeOverviewPref;
      final isReload = event.isReload;

      try {
        final Object? dataCached = prefs.get(partOfPrefKey);
        if (dataCached == null || isReload) {
          emit(HomeOverviewLoading());
          HttpResponse response = await overviewRepository.getHomeOverview(event.month, event.year);
          if (response.code == 0) {
            HomeOverviewResponse data = HomeOverviewResponse.fromMap(response.data[0]);
            emit(HomeOverviewSuccess(data));

            if (event.month == null || event.year == null) { //chỉ cache tháng hiện tại
              Map<String, dynamic> json = HomeOverviewResponse.toMap(data);
              await prefs.setString(partOfPrefKey, jsonEncode(json));
            }
          } else {
            emit(HomeOverviewFailure(response.message));
          }
        } else {
          log("Trigger home overview from disk");
          Map<String, dynamic> fromDisk = jsonDecode(dataCached.toString());
          HomeOverviewResponse dataFromDisk = HomeOverviewResponse.fromMap(fromDisk);
          emit(HomeOverviewSuccess(dataFromDisk));
        }
      } catch (e) {
        log("Get home overview failed: $e");
        emit(HomeOverviewFailure(e.toString()));
      }
    });
  }
}
