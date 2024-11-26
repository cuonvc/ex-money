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
        List data = await overviewRepository.getHomeOverview(event.month);
        emit(HomeOverviewSuccess(data));
      } catch (e) {
        log("Get home overview failed: $e");
        emit(HomeOverviewFailure());
      }
    });
  }
}
