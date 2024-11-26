part of 'home_overview_bloc.dart';

sealed class HomeOverViewEvent extends Equatable {
  const HomeOverViewEvent();

  @override
  List<Object?> get props => [];
}

class HomeOverViewEv extends HomeOverViewEvent {
  HomeOverviewResponse? response;
  int? month;

  HomeOverViewEv(this.month);

  @override
  List<Object?> get props => [response];
}
