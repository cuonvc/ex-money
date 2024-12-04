part of 'home_overview_bloc.dart';

sealed class HomeOverviewState extends Equatable {
  const HomeOverviewState();
  List<Object?> get props => [];
}

final class HomeOverviewInitial extends HomeOverviewState {}
final class HomeOverviewLoading extends HomeOverviewState {}
final class HomeOverviewFailure extends HomeOverviewState {
  final String message;

  const HomeOverviewFailure(this.message);
}
final class HomeOverviewSuccess extends HomeOverviewState {
  final HomeOverviewResponse data;

  const HomeOverviewSuccess(this.data);
}
