part of 'home_overview_bloc.dart';

sealed class HomeOverviewState extends Equatable {
  const HomeOverviewState();
  List<Object?> get props => [];
}

final class HomeOverviewInitial extends HomeOverviewState {}
final class HomeOverviewLoading extends HomeOverviewState {}
final class HomeOverviewFailure extends HomeOverviewState {}
final class HomeOverviewSuccess extends HomeOverviewState {
  final List data;
  const HomeOverviewSuccess(this.data);

  @override
  List<Object?> get props => data;
}
