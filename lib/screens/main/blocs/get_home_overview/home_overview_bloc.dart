import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'home_overview_event.dart';
part 'home_overview_state.dart';

class HomeOverviewBloc extends Bloc<HomeOverViewEvent, HomeOverviewState> {

  final OverviewRepository overviewRepository;

  HomeOverviewBloc(this.overviewRepository) : super(HomeOverviewInitial()) {
    on<HomeOverViewEv>((event, emit) async {
      emit(HomeOverviewLoading());
      try {
        HttpResponse response = await overviewRepository.getHomeOverview(event.month);
        if (response.code == 0) {
          HomeOverviewResponse data = HomeOverviewResponse.fromMap(response.data[0]);
          emit(HomeOverviewSuccess(data));
        } else {
          emit(HomeOverviewFailure(response.message));
        }
      } catch (e) {
        log("Get home overview failed: $e");
        emit(HomeOverviewFailure(e.toString()));
      }
    });
  }
}
