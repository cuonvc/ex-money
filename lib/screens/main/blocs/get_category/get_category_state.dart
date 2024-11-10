part of 'get_category_bloc.dart';

sealed class GetCategoryState extends Equatable {
  const GetCategoryState();
  List<Object?> get props => [];
}

final class GetCategoryInitial extends GetCategoryState {}
final class GetCategoryLoading extends GetCategoryState {}
final class GetCategoryFailure extends GetCategoryState {}
final class GetCategorySuccess extends GetCategoryState {
  final List data;
  const GetCategorySuccess(this.data);

  @override
  List<Object?> get props => data;
}
